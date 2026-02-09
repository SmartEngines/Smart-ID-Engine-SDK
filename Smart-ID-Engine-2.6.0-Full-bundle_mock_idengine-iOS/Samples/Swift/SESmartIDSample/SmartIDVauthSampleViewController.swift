/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

import UIKit
// for NFC reading
import NFCPassportReader

@available(iOS 13.0.0, *)
class VauthSampleViewController: UIViewController,
                                 UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate,
                                 SampleSmartIDViewControllerProtocol,
                                 SmartIDEngineInitializationDelegate {
  var currentDocumenttypeMask : String?
  
  func setModeAndDocumentTypeMask(mode: String, docTypeMask: String) {
    if docTypeMask.contains("phone") || docTypeMask.contains("card_number") { // phone lines scanning mode forces default mode
      smartIDController.sessionSettings().setCurrentModeTo("default")
      self.currentDocumenttypeMask = "default" + " : " + docTypeMask
    } else {
      smartIDController.sessionSettings().setCurrentModeTo(mode)
      self.currentDocumenttypeMask = mode + " : " + docTypeMask
    }
    smartIDController.sessionSettings().removeEnabledDocumentTypes(withMask: "*")
    smartIDController.sessionSettings().addEnabledDocumentTypes(withMask: docTypeMask)
    
    smartIDController.configureDocumentTypeLabel(self.currentDocumenttypeMask!)
    print("Current mode is \(mode), doc type mask is \(docTypeMask)")
    
    var shouldDisplayRoi = false
    let doc_type_it = smartIDController.sessionSettings().enabledDocumentTypesBegin()
    while !doc_type_it.isEqual(toIter: smartIDController.sessionSettings().enabledDocumentTypesEnd() ) {
      if !(doc_type_it.getValue().contains("phone") || doc_type_it.getValue().contains("card_number")) {
        break
      }
      shouldDisplayRoi = true
      doc_type_it.advance()
    }
    
    if shouldDisplayRoi { // special ROI selection for phone lines scanning mode
      smartIDController.shouldDisplayRoi = true
      smartIDController.setRoiWithOffsetX(0.0, andY: 0.5, orientation: UIDeviceOrientation.portrait, displayRoi: true)
    } else {
      smartIDController.setRoiWithOffsetX(0.0, andY: 0.0, orientation: UIDeviceOrientation.portrait, displayRoi: false)
      smartIDController.shouldDisplayRoi = false
    }
  }
  
  func switchFromDefaultToSingleshotMode() {
    if (self.currentDocumenttypeMask != nil) {
      if self.currentDocumenttypeMask!.contains("phone") || self.currentDocumenttypeMask!.contains("card_number") { // phone lines scanning mode ignores singleshot
        return
      }
      let currentMode = self.smartIDController.sessionSettings().getCurrentMode()
      var singleshotMode = "";
      if (currentMode == "default") {
        singleshotMode = "singleshot"
      } else {
        singleshotMode = currentMode + "-singleshot"
      }
      if (self.smartIDController.sessionSettings().hasSupportedMode(withName: singleshotMode)) {
        self.smartIDController.sessionSettings().setCurrentModeTo(singleshotMode)
      }
    }
  }
  
  func switchFromSingleshotToDefaultMode() {
    if (self.currentDocumenttypeMask != nil) {
      let currentMode = self.smartIDController.sessionSettings().getCurrentMode()
      var defaultMode = "";
      if (currentMode == "singleshot") {
        defaultMode = "default"
      } else {
        defaultMode = currentMode.replacingOccurrences(of: "-singleshot", with: "")
      }
      if (self.smartIDController.sessionSettings().hasSupportedMode(withName: defaultMode)) {
        self.smartIDController.sessionSettings().setCurrentModeTo(defaultMode)
      }
    }
  }
  
  // View-related
  
  var pickerImageActivityIndicator:UIActivityIndicatorView!
  var pickerImageActivityIndicatorContainer:UIView!
  var pickerIAIContainerBackground:UIView!
  
  var docTypeListViewController : DocTypesListController!
  
  var resultTableView : UITableView = {
    var resultTableView = UITableView()
    resultTableView.register(TextFieldCell.self, forCellReuseIdentifier: "TextCell")
    resultTableView.register(ImageViewCell.self, forCellReuseIdentifier: "ImageCell")
    resultTableView.estimatedRowHeight = 100
    resultTableView.translatesAutoresizingMaskIntoConstraints = false
    return resultTableView
  }()
  
  func setTableViewAnchors() {
    if #available(iOS 11.0, *) {
      resultTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
      resultTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
      resultTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
      resultTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
    } else {
      resultTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
      resultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
      resultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
      resultTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
    resultTableView.estimatedRowHeight = 600
    resultTableView.allowsSelection = false
  }
  
  //Variables related to RFID reading - start
   private let mrzDataKeys = ["mrz_number", "mrz_cd_number", "mrz_birth_date", "mrz_cd_birth_date", "mrz_expiry_date", "mrz_cd_expiry_date"]
   private var mrzDataDict: [String: String] = [:]
   private var hasRFID = false
   private var mrzkey: String?
   private var isNFCReaderReady = true
   //An instance of the NFCPassportModel class, all information read using NFC is stored here
   private var passport: NFCPassportModel? = nil
   private var doctyperaw: String?
   //Variables related to RFID reading - end
  
  private var resultTextFields = [(fieldName: String, value: String)]()
  private var resultImageFields = [(fieldName: String, value: UIImage)]()
  
  func setResult(result: SEIdResultRef) {
    resultTextFields.removeAll()
    resultImageFields.removeAll()
    
    resultTextFields.append(("Document type", result.getDocumentType()))
    
    self.doctyperaw = result.getDocumentType()
    //Checking that the recognized document can have an NFC chip by definition
    if (self.doctyperaw != nil && self.doctyperaw != "") {
      let docInfo = smartIDController.sessionSettings().getDocumentInfo(forDocument: self.doctyperaw!)
      let supportedRFID = docInfo.supportedRFID()
      if supportedRFID == 1 {
        self.nfcButton.isHidden = false
        self.nfcButton.isEnabled = true
        hasRFID = true
      } else {
        self.nfcButton.isHidden = true
        self.nfcButton.isEnabled = false
        hasRFID = false
      }
    } else {
      self.nfcButton.isHidden = true
      self.nfcButton.isEnabled = false
      hasRFID = false
    }
    
    let textFieldsIter = result.textFieldsBegin()
    let textFieldsEnd = result.textFieldsEnd()
    while !textFieldsIter.isEqual(toIter: textFieldsEnd) {
      resultTextFields.append(
        (textFieldsIter.getKey(), textFieldsIter.getValue().getValue().getFirstString()))
      
      //Mrz parts are extracted from the recognition result to then compose the mrzKey
      if hasRFID {
        if mrzDataKeys.contains(textFieldsIter.getKey()) {
          mrzDataDict[textFieldsIter.getKey()] = textFieldsIter.getValue().getValue().getFirstString()
        }
      }
      
      textFieldsIter.advance()
    }
    
    let imageFieldsIter = result.imageFieldsBegin()
    let imageFieldsEnd = result.imageFieldsEnd()
    while !imageFieldsIter.isEqual(toIter: imageFieldsEnd) {
      resultImageFields.append(
        (imageFieldsIter.getKey(),
         imageFieldsIter.getValue().getValue().convertToUIImage()))
      imageFieldsIter.advance()
    }

    let forensicFieldsIter = result.forensicCheckFieldsBegin()
    let forensicFieldsEnd = result.forensicCheckFieldsEnd()
    var checkStatus: String = ""
    while !forensicFieldsIter.isEqual(toIter: forensicFieldsEnd) {
        if forensicFieldsIter.getValue().getValue() == SEIdCheckStatus.passed {
            checkStatus = "passed"
        } else if forensicFieldsIter.getValue().getValue() == SEIdCheckStatus.failed {
            checkStatus = "failed"
        } else {
            checkStatus = "undefined"
        }
      resultTextFields.append(
          (forensicFieldsIter.getValue().getName(), checkStatus))
        forensicFieldsIter.advance()
    }
    
    //Creating an mrz key using a recognized document. The key is needed to read the document via NFC using PassportReader
    if hasRFID {
      mrzkey = calculateMrzKey(mrzDataDict: mrzDataDict)
    }
    
    resultTextFields.sort(by: {
      return $0.0 < $1.0
    })
    resultImageFields.sort(by: {
      return $0.0 < $1.0
    })
  }
  
  let cameraButton: UIButton = {
    let button = UIButton(type: .roundedRect)
    button.autoresizingMask = .flexibleWidth
    button.setTitle("...", for: .normal)
    button.isEnabled = false
    button.layer.borderColor = UIColor.blue.cgColor
    return button
  }()
  
  let documentListButton: UIButton = {
    let button = UIButton(type: .roundedRect)
    button.autoresizingMask = .flexibleWidth
    button.setTitle("...", for: .normal)
    button.isEnabled = false
    button.layer.borderColor = UIColor.blue.cgColor
    return button
  }()
  
  //NFC reading (using PassportReader) will start when it tapped
  let nfcButton : UIButton = {
    let button = UIButton(type: .roundedRect)
    button.autoresizingMask = .flexibleWidth
    button.setTitle("Read NFC", for: .normal)
    button.isEnabled = false
    button.isHidden = true
    button.layer.borderColor = UIColor.blue.cgColor
    return button
  }()
  
  let resultTextView: UITextView = {
    let view = UITextView()
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.isEditable = false
    view.font = UIFont(name: "Menlo-Regular", size: 12)
    return view
  }()
  
  let resultImageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    view.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
    return view
  }()
  
  let photoLibraryImagePicker : UIImagePickerController = {
    let picker = UIImagePickerController()
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
      picker.sourceType = .photoLibrary
      picker.modalPresentationStyle = .fullScreen
    }
    return picker
  }()
  
  let engineInstance : SmartIDEngineInstance = {
    let signature = "Place your signature here (see doc\README.html)"
    return SmartIDEngineInstance(signature: signature)
  }()
  
  func smartIDEngineInitialized() {
    self.cameraButton.setTitle("Camera", for: .normal)
    self.documentListButton.setTitle("Select type", for: .normal)
    
    self.cameraButton.isEnabled = true
    self.documentListButton.isEnabled = true
    
    self.smartIDController.attach(self.engineInstance)
    self.configureSessionOptions() // calling _after_ attaching engine instance
  }
  
  let smartIDController: SmartIDVauthViewController = {
    let smartIDController = SmartIDVauthViewController(lockedOrientation: true, withTorch: false, withBestDevice: true)
    smartIDController.modalPresentationStyle = .fullScreen
    smartIDController.captureButtonDelegate = smartIDController
    
    // configure optional visualization properties (they are NO by default)
    smartIDController.displayZonesQuadrangles = true
    smartIDController.displayDocumentQuadrangle = true
    smartIDController.displayProcessingFeedback = true
    
    return smartIDController
  }()
  
  override func viewDidLayoutSubviews() {
    let bottomSafeArea: CGFloat
    let topSafeArea: CGFloat
    
    // safe area for phones with notch
    
    if #available(iOS 11.0, *) {
      bottomSafeArea = view.safeAreaInsets.bottom
      topSafeArea = view.safeAreaInsets.top
    } else {
      bottomSafeArea = bottomLayoutGuide.length
      topSafeArea = topLayoutGuide.length
    }
    
    let buttonHeight: CGFloat = 50
    
    cameraButton.frame = CGRect(x: 0,
                                y: view.bounds.size.height - bottomSafeArea - buttonHeight,
                                width: view.bounds.size.width/3,
                                height: buttonHeight)
    
    documentListButton.frame = CGRect(x: view.bounds.size.width*2/3,
                                      y: view.bounds.size.height - bottomSafeArea - buttonHeight,
                                      width: view.bounds.size.width/3,
                                 height: buttonHeight)
    
    //It appears at the right top corner under the selfieButton
    nfcButton.frame = CGRect(x: view.bounds.size.width/2,
                                 y: topSafeArea * 2,
                                 width: view.bounds.size.width/2,
                                 height: buttonHeight)
    
  }
  
  func configureSessionOptions() {
    // you can set mode and document mask here, if you are not using document types table,
    // or other options such as time out or extracting template images
    smartIDController.sessionSettings()
      .setOptionWithName("common.sessionTimeout", to: "5.0")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    smartIDController.smartIDVauthDelegate = self
    
    if #available(iOS 13.0, *) {
      self.view.backgroundColor = .systemBackground
    } else {
      self.view.backgroundColor = .white
    }
    
    view.addSubview(resultTableView)
    setTableViewAnchors()
    resultTableView.delegate = self
    resultTableView.dataSource = self
    
    view.addSubview(cameraButton)
    view.addSubview(documentListButton)
    view.addSubview(nfcButton)
    
    cameraButton.addTarget(
      self, action:#selector(showSmartIdViewController), for: .touchUpInside)
    documentListButton.addTarget(
      self, action: #selector(showDocumenttypeList), for: .touchUpInside)
    nfcButton.addTarget(
      self, action: #selector(readPassport), for: .touchUpInside)
    
    self.engineInstance.setInitializationDelegate(self)
    
    DispatchQueue.main.async {
      
      let bundlePaths = Bundle.main.paths(forResourcesOfType: "se", inDirectory: "data")
      
      if bundlePaths.count == 1 {
        
        self.engineInstance.initializeEngine(bundlePaths[0])
        self.smartIDController.sessionSettings().setCurrentModeTo("default")
        guard self.engineInstance.engine!.canCreateVideoAuthenticationSessionSettings() else {
          self.cameraButton.isEnabled = false
          self.documentListButton.isEnabled = false
          print("No Video Authentication resources in bundle")
          return
        }
        // getting list of supported document modes and types
        
        var modesList = [String]() // modes are not sorted
        let modesEnd = self.smartIDController.sessionSettings().supportedModesEnd()
        let modesIt = self.smartIDController.sessionSettings().supportedModesBegin()
        while !modesIt.isEqual(toIter: modesEnd) {
          defer {
            modesIt.advance()
          }
          // skipping singleshot modes
          if modesIt.getValue().contains("singleshot") {
            continue
          }
          modesList.append(modesIt.getValue())
        }
        
        var docTypesList = [String:[String]]()
        for mode in modesList {
          self.smartIDController.sessionSettings().setCurrentModeTo(mode)
          let masksEnd = self.smartIDController.sessionSettings().permissiblePrefixDocMasksEnd()
          let masksIt = self.smartIDController.sessionSettings().permissiblePrefixDocMasksBegin()
          var masks = [String]()
          while !masksIt.isEqual(toIter: masksEnd) {
            masks.append(masksIt.getValue())
            masksIt.advance()
          }
          docTypesList[mode] = masks
        }
        
        if (modesList.count == 1) && (docTypesList[modesList[0]]!.count == 1) {
          self.setModeAndDocumentTypeMask(
            mode: modesList[0],
            docTypeMask: docTypesList[modesList[0]]![0])
        }
        
        self.docTypeListViewController = DocTypesListController(docTypesList: docTypesList)
        self.docTypeListViewController.delegateSampSID = self
        
      } else {
        print("One bundle is required in the data folder")
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  enum APIError: Error {
    case networkError
    case jsonDecode
    case unknown
    
    var title: String {
      switch self {
      case .networkError:
        return "network error"
      case .jsonDecode:
        return "Json decode error"
      case .unknown:
        return "unknown error"
      }
    }
  }
    
  // Objc -> Swift Async
  // https://developer.apple.com/documentation/swift/calling-objective-c-apis-asynchronously
  func smartIDEngineDidActivationRequest(_ dynKey: String) async -> String?  {
    do {
      guard let url = URL(string: "http://127.0.0.1:8000/client/sign_message/") else {
        throw URLError(.badURL)
      }
      
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "accept")
      request.addValue("", forHTTPHeaderField: "X-API-Key")
                  
      struct resp: Decodable {
        let message: String
      }
      
      request.httpBody = "{\"action\":\"activate_id_session\",\"message\":\"\(dynKey)\"}".data(using: String.Encoding.utf8)
      
      let (data, response) = try await URLSession.shared.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw APIError.networkError
      }
      
      guard let resp = try? JSONDecoder().decode(resp.self, from: data) else {
        throw APIError.jsonDecode
      }
      
      print("activation key: ", resp)
                  
      return resp.message
    } catch {
      print(error)
    }
    return nil
  }
  
  func showAlert(msg: String) {
    let alert = UIAlertController(title: "Warning", message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(
      title: NSLocalizedString("OK", comment: "Default action"),
      style: .default,
      handler: { _ in
        NSLog("The \"OK\" alert occured.")
      }))
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc func showSmartIdViewController() {
    if currentDocumenttypeMask != nil {
      present(smartIDController, animated: true, completion: {
        print("sample: smartIDViewController presented")
      })
    } else {
      showAlert(msg: "Select document type")
    }
  }
  
  @objc func showDocumenttypeList() {
    present(docTypeListViewController, animated: true, completion: nil)
  }
  
  //RFID reading - calculating mrzKey
  func calculateMrzKey(mrzDataDict: [String: String]) -> String? {
    guard let number = mrzDataDict["mrz_number"],  let numberCd = mrzDataDict["mrz_cd_number"], let birthDate = mrzDataDict["mrz_birth_date"], let birthDateCd = mrzDataDict["mrz_cd_birth_date"], let expiryDate = mrzDataDict["mrz_expiry_date"], let expiryDateCd = mrzDataDict["mrz_cd_expiry_date"]
    else {
      return nil
    }
    
    guard let fBirthDate = formatDate(date: birthDate), let fExpiryDate = formatDate(date: expiryDate)
    else {
      return nil
    }
    
    let padNumber = pad(number, fieldLength:9)
    let padBirthDate = pad(fBirthDate, fieldLength:6)
    let padExpiryDate = pad(fExpiryDate, fieldLength:6)
    
    return "\(padNumber)\(numberCd)\(padBirthDate)\(birthDateCd)\(padExpiryDate)\(expiryDateCd)"
  }
  
  //RFID reading - Filling with "<"
  func pad( _ value : String, fieldLength:Int ) -> String {
    // Pad out field lengths with < if they are too short
    let paddedValue = (value + String(repeating: "<", count: fieldLength)).prefix(fieldLength)
    return String(paddedValue)
  }

  //RFID reading - Formatting date for mrzKey as "YYMMDD"
  func formatDate(date: String) -> String? {
    let dateArray = date.components(separatedBy: ".")
    guard dateArray.count >= 3 else { return nil }
    return "\(dateArray[2].suffix(2))\(dateArray[1])\(dateArray[0])"
  }
  
//RFID reading - reading NFC using PassportReader
  @objc func readPassport() {
    if mrzkey == nil {
      showAlert(msg: "Can not read NFC, no data from document.")
      debugPrint("mrzkey is nil: readPassport is impossible")
      return
    }
    isNFCReaderReady = false
    let passportReader = PassportReader()

    //More information about Data Groups and specifications of reading can be found here: https://www.icao.int/publications/pages/publication.aspx?docnum=9303
    
    //COM: Header and Data Group Presence Information (Mandatory)
    //SOD: Document Security Object (Mandatory)
    //DG1: Machine Readable Zone Information (Mandatory)
    //DG2: Encoded Identification Features - Face (Mandatory)
    
    //    let dataGroups : [DataGroupId] = [.COM, .SOD, .DG1, .DG2, .DG7, .DG11, .DG12, .DG14, .DG15]
    let dataGroups : [DataGroupId] = [.COM, .SOD, .DG1, .DG2]
    Task {
      let customMessageHandler : (NFCViewDisplayMessage)->String? = { (displayMessage) in
        //Other display messages can be customize here
        switch displayMessage {
        case .requestPresentPassport:
          return "Hold your iPhone near an NFC enabled passport."
        default:
          // Return nil for all other messages so we use the provided default
          return nil
        }
      }
      
      do {
        //RFID reading - session of reading NFC
        // @mrzKey - string as <passport number><passport number checksum><date of birth><date of birth checksum><expiry date><expiry date checksum>
        // @tags - array of DataGroups
        // @customDisplayMessage - customized messages while it reading
        let passportModel = try await passportReader.readPassport(mrzKey: mrzkey!, tags: dataGroups, customDisplayMessage:customMessageHandler)
        DispatchQueue.main.async {
          self.passport = passportModel
          self.handlePassport()
          self.isNFCReaderReady = true
        }
      } catch {
        debugPrint("NFC Reading", error.localizedDescription)
        isNFCReaderReady = true
      }
    }
  }
  
  func handlePassport() { //Postpocessing of NFC-reading,
    if passport != nil {
      
      //Check that doctype from recogized document and photo from NFC scanning are exist
      if self.doctyperaw != nil && passport!.passportImage != nil {
        //Creating JSON-structure for ProcessData
        let NFCData: [String: Any] = [
          "doc_type": self.doctyperaw!,
          "physical_fields": [
            "rfid_mrz": [
              "value": passport!.passportMRZ, //MRZ from NFC-scanning
              "type": "String"
            ],
            "rfid_photo": [
              "value": passport!.passportImage!.toJpegString(compressionQuality: 1), //Photo as string from NFC-scanning
              "type": "Image"
            ]
          ]
        ]
        do {
          let jsonString = try JSONSerialization.data(withJSONObject: NFCData, options: [])
          //Creating JSON-string
          let jsonStr = String(data: jsonString, encoding: .utf8)!
          
          //ProcessData returns result with next checks that can be interpreted like this
          let checksDictionary = [
            "check_4000000000001": "!Data fraud attempt",
            "check_4000000000002": "!Face fraud attempt"
          ]
          
          //Call ProcessData from the same session where the document was recognized
          let r = self.engineInstance.processVauthData(jsonStr)
          
          if r.getRef().getForensicCheckFieldsCount() > 0 {
            let fr_i = r.getRef().forensicCheckFieldsBegin()
            while !fr_i.isEqual(toIter: r.getRef().forensicCheckFieldsEnd()) {
              var value = "none"
              let status = fr_i.getValue().getValue()
              switch status {
              case SEIdCheckStatus.passed:
                value = "not_detected"
                break
              case SEIdCheckStatus.failed:
                value = "detected"
                break
              case SEIdCheckStatus.undefined:
                value = "undefined"
                break
              }
              if checksDictionary.keys.contains(fr_i.getKey()) {
                self.resultTextFields.append((checksDictionary[fr_i.getKey()]!, value))
              }
              fr_i.advance()
            }
          }
        } catch {
          print(error)
        }
      }

      //Retrieving data from NFC-scanning to display (hack: using "#" place the fields to the top of resultTextFields)
      self.resultTextFields.append(("#rfid Type", passport!.documentType))
      self.resultTextFields.append(("#rfid Document Number", passport!.documentNumber))
      self.resultTextFields.append(("#rfid First Name", passport!.firstName))
      self.resultTextFields.append(("#rfid Document Expiry Date", passport!.documentExpiryDate))
      self.resultTextFields.append(("#rfid Date Of Birth", passport!.dateOfBirth))
      self.resultTextFields.append(("#rfid Gender", passport!.gender))
      self.resultTextFields.append(("#rfid Issuing Authority", passport!.issuingAuthority))
      self.resultTextFields.append(("#rfid Last Name", passport!.lastName))
      self.resultTextFields.append(("#rfid Nationality", passport!.nationality))
      self.resultTextFields.append(("#rfid Passport MRZ", passport!.passportMRZ))
      self.resultTextFields.append(("#rfid Document Signing Certificate Verified",  passport!.documentSigningCertificateVerified ? "YES" : "NO"))
      self.resultTextFields.append(("#rfid Passport Correctly Signed", passport!.passportCorrectlySigned ? "YES" : "NO"))
      self.resultTextFields.append(("#rfid Passport Data Not Tampered", passport!.passportDataNotTampered ? "YES" : "NO"))
      self.resultTextFields.sort(by: {
          return $0.0 < $1.0
      })
      //Retrieving photo from NFC-scanning to display
      if passport!.passportImage != nil {
        self.resultImageFields.append(("#rfid Photo", passport!.passportImage!))
      }
      self.nfcButton.isEnabled = false
      self.resultTableView.reloadData()
    }
  }

}

// MARK: SEResultTableView

@available(iOS 13.0.0, *)
extension VauthSampleViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return resultTextFields.count + resultImageFields.count
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if (indexPath.row < resultTextFields.count) {
      let cell = resultTableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextFieldCell
      cell.fieldName.text = resultTextFields[indexPath.row].fieldName
      cell.resultTextView.text = resultTextFields[indexPath.row].value
      return cell
    } else {
      let cell = resultTableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageViewCell
      cell.fieldName.text = resultImageFields[indexPath.row - resultTextFields.count].fieldName
      cell.imageFieldView.image = resultImageFields[indexPath.row - resultTextFields.count].value
      
      return cell
    }
  }
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}

@available(iOS 13.0.0, *)
extension VauthSampleViewController: SmartIDVauthViewControllerDelegate {
    func smartIDVauthViewControllerDidRecognize(_ result: SEIdResult, from buffer: CMSampleBuffer?) {
    let resultRef = result.getRef()
    if resultRef.getIsTerminal() {
      self.setResult(result: resultRef)
      resultTableView.reloadData()
      dismiss(animated: true, completion: nil)
    }
  }
  
  func smartIDVauthViewControllerDidCancel() {
    resultTextView.text = "Recognition cancelled by user!"
    resultImageView.image = nil
    dismiss(animated: true, completion: nil)
  }
  
  func smartIDVauthViewControllerDidStop(_ result: SEIdResult) {
    self.setResult(result: result.getRef())
    resultTableView.reloadData()
    dismiss(animated: true, completion: nil)
  }
   
}
