/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

import UIKit
// for NFC reading
import NFCPassportReader

protocol SampleViewControllerProtocol : class {
  func setModeAndDocumentTypeMask(mode: String, docTypeMask: String)
}

enum ResultSection {
  case documentInfo([(fieldName: String, value: String, isAccepted: Bool, confidence: Double, attributes: [String: String])])
  case nfcData([(fieldName: String, value: String)])
  case rfidCheck([(fieldName: String, value: String, status: SEIdCheckStatus, attributes: [String: String])])
  case selfieCheck([(fieldName: String, value: String)])
  case forensicCheck([(fieldName: String, value: String, status: SEIdCheckStatus, attributes: [String: String])])
  case images([(fieldName: String, value: UIImage, isAccepted: Bool, confidence: Double, attributes: [String: String])])
  case message(String)
}

@available(iOS 13.0.0, *)
class SampleViewController: UIViewController,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate,
                            SampleViewControllerProtocol,
                            SmartIDEngineInitializationDelegate {
  var currentDocumenttypeMask : String?
  private var resultSections: [ResultSection] = []
  
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
      if self.currentDocumenttypeMask!.contains("phone") || self.currentDocumenttypeMask!.contains("card_number") || self.currentDocumenttypeMask!.contains("face") { // phone lines scanning mode ignores singleshot
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
    print("Current mode:", self.smartIDController.sessionSettings().getCurrentMode())
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
    print("Current mode:", self.smartIDController.sessionSettings().getCurrentMode())
  }
  
  // Selfie-related
  
  var currentPhotoImage : SECommonImage? = nil;
  
  func reinitSelfieButton() {
    self.selfieButton.isEnabled = false
    self.selfieButton.isHidden = true
    self.currentPhotoImage = nil;
  }
  
  let selfieImagePicker : UIImagePickerController = {
    let picker = UIImagePickerController()
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
      picker.sourceType = UIImagePickerController.SourceType.camera
      picker.modalPresentationStyle = .fullScreen
      picker.cameraFlashMode = .off
      picker.cameraDevice = .front
      picker.cameraCaptureMode = .photo
    }
    return picker
  }()
  
  // View-related
  
  var galleryModeFlag = false // flag if recognize only one picture from Gallery
  
  var pickerImageActivityIndicator:UIActivityIndicatorView!
  var pickerImageActivityIndicatorContainer:UIView!
  var pickerIAIContainerBackground:UIView!
  
  var docTypeListViewController : DocTypesListController!
  
  var resultTableView : UITableView = {
    var resultTableView = UITableView()
    resultTableView.estimatedRowHeight = 100
    resultTableView.translatesAutoresizingMaskIntoConstraints = false
    return resultTableView
  }()
  
  func setTableViewAnchors() {
    
    resultTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    resultTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
    resultTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    resultTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
    
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
  let checks = ["check_4000000000001", "check_4000000000002", "check_4000000000003"]
  //Variables related to RFID reading - end
  
  func setMessage(_ message: String) {
    resultSections.removeAll()
    resultSections.append(.message(message))
    resultTableView.reloadData()
  }
  
  func setResult(result: SEIdResultRef) {
    resultSections.removeAll()
    mrzDataDict.removeAll()
    mrzkey = nil
    
    if result.getDocumentType().isEmpty {
      setMessage("Document not found")
      return
    }
    
    self.doctyperaw = result.getDocumentType()
    
    // Document Information
    var documentFields: [(String, String, Bool, Double, [String: String])] = []
    documentFields.append(("Document type", result.getDocumentType(), true, 1.0, [:]))
    
    let textFieldsIter = result.textFieldsBegin()
    let textFieldsEnd = result.textFieldsEnd()
    while !textFieldsIter.isEqual(toIter: textFieldsEnd) {
      let isAccepted = textFieldsIter.getValue().getBaseFieldInfo().getIsAccepted()
      let confidence = textFieldsIter.getValue().getBaseFieldInfo().getConfidence()
      
      var attributes: [String: String] = [:]
      let attrIter = textFieldsIter.getValue().getBaseFieldInfo().attributesBegin()
      let attrEnd = textFieldsIter.getValue().getBaseFieldInfo().attributesEnd()
      while !attrIter.isEqual(toIter: attrEnd) {
        attributes[attrIter.getKey()] = attrIter.getValue()
        attrIter.advance()
      }
      
      documentFields.append(
        (textFieldsIter.getKey(),
         textFieldsIter.getValue().getValue().getFirstString(),
         isAccepted,
         confidence,
         attributes)
      )
      
      // Mrz parts extraction
      if mrzDataKeys.contains(textFieldsIter.getKey()) {
        mrzDataDict[textFieldsIter.getKey()] = textFieldsIter.getValue().getValue().getFirstString()
      }
      
      textFieldsIter.advance()
    }
    
    resultSections.append(.documentInfo(documentFields))
    
    // Forensic
    var forensicFields: [(String, String, SEIdCheckStatus, [String: String])] = []
    let forensicFieldsIter = result.forensicCheckFieldsBegin()
    let forensicFieldsEnd = result.forensicCheckFieldsEnd()
    while !forensicFieldsIter.isEqual(toIter: forensicFieldsEnd) {
      guard !checks.contains(forensicFieldsIter.getValue().getName()) else {
        forensicFieldsIter.advance()
        continue
      }
      let status = forensicFieldsIter.getValue().getValue()
      //      let isAccepted = forensicFieldsIter.getValue().getBaseFieldInfo().getIsAccepted()
      //      let confidence = forensicFieldsIter.getValue().getBaseFieldInfo().getConfidence()
      
      var attributes: [String: String] = [:]
      let attrIter = forensicFieldsIter.getValue().getBaseFieldInfo().attributesBegin()
      let attrEnd = forensicFieldsIter.getValue().getBaseFieldInfo().attributesEnd()
      while !attrIter.isEqual(toIter: attrEnd) {
        attributes[attrIter.getKey()] = attrIter.getValue()
        attrIter.advance()
      }
      
      var checkStatus: String = ""
      
      switch status {
      case SEIdCheckStatus.passed:
        checkStatus = "passed"
      case SEIdCheckStatus.failed:
        checkStatus = "failed"
      default:
        checkStatus = "undefined"
      }
      
      forensicFields.append((forensicFieldsIter.getValue().getName(), checkStatus, status, attributes))
      forensicFieldsIter.advance()
    }
    
    if !forensicFields.isEmpty {
      resultSections.append(.forensicCheck(forensicFields))
    }
    
    // Images
    var imageFields: [(String, UIImage, Bool, Double, [String: String])] = []
    let imageFieldsIter = result.imageFieldsBegin()
    let imageFieldsEnd = result.imageFieldsEnd()
    while !imageFieldsIter.isEqual(toIter: imageFieldsEnd) {
      let isAccepted = imageFieldsIter.getValue().getBaseFieldInfo().getIsAccepted()
      let confidence = imageFieldsIter.getValue().getBaseFieldInfo().getConfidence()
      var attributes: [String: String] = [:]
      let attrIter = imageFieldsIter.getValue().getBaseFieldInfo().attributesBegin()
      let attrEnd = imageFieldsIter.getValue().getBaseFieldInfo().attributesEnd()
      while !attrIter.isEqual(toIter: attrEnd) {
        attributes[attrIter.getKey()] = attrIter.getValue()
        attrIter.advance()
      }
      
      imageFields.append(
        (imageFieldsIter.getKey(),
         imageFieldsIter.getValue().getValue().convertToUIImage(),
         isAccepted,
         confidence,
         attributes)
      )
      imageFieldsIter.advance()
    }
    
    if !imageFields.isEmpty {
      resultSections.append(.images(imageFields))
    }
    
    // RFID checking
    updateRFIDStatus(for: result)
    
    // Selfie checking
    updateSelfieButton(for: result)
    
    // MRZ key for RFID reading
    if hasRFID {
      mrzkey = calculateMrzKey(mrzDataDict: mrzDataDict)
    }
    
    resultTableView.reloadData()
  }
  
  private func updateSelfieButton(for result: SEIdResultRef) {
    if let engine = self.engineInstance.engine,
       engine.canCreateFaceSessionSettings() && result.hasImageField(withName: "photo") {
      self.selfieButton.isHidden = false
      self.selfieButton.isEnabled = true
      self.currentPhotoImage = result.getImageField(withName: "photo").getValue().cloneDeep()
    } else {
      self.selfieButton.isHidden = true
      self.selfieButton.isEnabled = false
      self.currentPhotoImage = nil
    }
  }
  
  private func updateRFIDStatus(for result: SEIdResultRef) {
    let docType = result.getDocumentType()
    if !docType.isEmpty {
      let docInfo = smartIDController.sessionSettings().getDocumentInfo(forDocument: docType)
      hasRFID = docInfo.supportedRFID() == 1
      nfcButton.isHidden = !hasRFID
      nfcButton.isEnabled = hasRFID
    } else {
      hasRFID = false
      nfcButton.isHidden = true
      nfcButton.isEnabled = false
    }
  }
  
  let cameraButton: UIButton = {
    let button = UIButton(type: .roundedRect)
    button.autoresizingMask = .flexibleWidth
    button.setTitle("...", for: .normal)
    button.isEnabled = false
    button.layer.borderColor = UIColor.blue.cgColor
    return button
  }()
  
  let galleryButton: UIButton = {
    let button = UIButton(type: .roundedRect)
    button.autoresizingMask = .flexibleWidth
    button.setTitle("initializing ...", for: .normal)
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
  
  let selfieButton : UIButton = {
    let button = UIButton(type: .roundedRect)
    button.autoresizingMask = .flexibleWidth
    button.setTitle("Compare with selfie", for: .normal)
    button.isEnabled = false
    button.isHidden = true
    button.layer.borderColor = UIColor.blue.cgColor
    return button
  }()
  
  // NFC reading (using PassportReader) will start when it tapped
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
    self.galleryButton.setTitle("Gallery", for: .normal)
    self.cameraButton.setTitle("Camera", for: .normal)
    self.documentListButton.setTitle("Select type", for: .normal)
    
    self.galleryButton.isEnabled = true
    self.cameraButton.isEnabled = true
    self.documentListButton.isEnabled = true
    
    self.smartIDController.attach(self.engineInstance)
    self.configureSessionOptions() // calling _after_ attaching engine instance
  }
  
  let smartIDController: SmartIDViewController = {
    let smartIDController = SmartIDViewController(lockedOrientation: true, withTorch: false, withBestDevice: true)
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
    bottomSafeArea = view.safeAreaInsets.bottom
    topSafeArea = view.safeAreaInsets.top
    
    let buttonHeight: CGFloat = 50
    
    cameraButton.frame = CGRect(x: 0,
                                y: view.bounds.size.height - bottomSafeArea - buttonHeight,
                                width: view.bounds.size.width/3,
                                height: buttonHeight)
    
    galleryButton.frame = CGRect(x: view.bounds.size.width/3,
                                 y: view.bounds.size.height - bottomSafeArea - buttonHeight,
                                 width: view.bounds.size.width/3,
                                 height: buttonHeight)
    
    documentListButton.frame = CGRect(x: view.bounds.size.width*2/3,
                                      y: view.bounds.size.height - bottomSafeArea - buttonHeight,
                                      width: view.bounds.size.width/3,
                                      height: buttonHeight)
    
    selfieButton.frame = CGRect(x: view.bounds.size.width/2,
                                y: topSafeArea,
                                width: view.bounds.size.width/2,
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
    
///   Enable sample
//    smartIDController.sessionSettings().enableForensics()
    
///   Setting curent date
//    let formatter = DateFormatter()
//    formatter.dateFormat = "dd.MM.yyyy"
//    smartIDController.sessionSettings().setOptionWithName("common.currentDate", to: formatter.string(from: Date()))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    smartIDController.smartIDDelegate = self
    
    self.view.backgroundColor = .systemBackground
    
    view.addSubview(resultTableView)
    setTableViewAnchors()
    resultTableView.delegate = self
    resultTableView.dataSource = self
    
    resultTableView.register(TextFieldCell.self, forCellReuseIdentifier: "TextCell")
    resultTableView.register(ForensicTextFieldCell.self, forCellReuseIdentifier: "ForensicTextCell")
    resultTableView.register(ImageViewCell.self, forCellReuseIdentifier: "ImageCell")
    resultTableView.register(ForensicTextFieldCell.self, forCellReuseIdentifier: "RfidTextCell")
    
    view.addSubview(cameraButton)
    view.addSubview(galleryButton)
    view.addSubview(documentListButton)
    view.addSubview(selfieButton)
    view.addSubview(nfcButton)
    
    cameraButton.addTarget(
      self, action:#selector(showSmartIdViewController), for: .touchUpInside)
    galleryButton.addTarget(
      self, action: #selector(showGalleryImagePickerToProcessImage), for: .touchUpInside)
    documentListButton.addTarget(
      self, action: #selector(showDocumenttypeList), for: .touchUpInside)
    selfieButton.addTarget(
      self, action: #selector(showSelfiePicker), for: .touchUpInside)
    nfcButton.addTarget(
      self, action: #selector(readPassport), for: .touchUpInside)
    
    setupImagePickerActivityBackground()
    
    self.engineInstance.setInitializationDelegate(self)
    
    DispatchQueue.main.async {
      
      let bundlePaths = Bundle.main.paths(forResourcesOfType: "se", inDirectory: "data")
      
      if bundlePaths.count == 1 {
        
        self.engineInstance.initializeEngine(bundlePaths[0])
        self.smartIDController.sessionSettings().setCurrentModeTo("default")
        
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
        self.setMessage("One bundle is required in the data folder")
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
	  request.addValue("close", forHTTPHeaderField: "Connection") 

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
  
  @objc func showGalleryImagePickerToProcessImage() {
    if currentDocumenttypeMask != nil {
      galleryModeFlag = true
      self.photoLibraryImagePicker.delegate = self
      DispatchQueue.main.async {
        self.pickerIAIContainerBackground.isHidden = true
        self.pickerImageActivityIndicatorContainer.isHidden = true
      }
      
      self.present(self.photoLibraryImagePicker, animated: true, completion: nil)
    } else {
      showAlert(msg: "Select document type")
    }
    self.reinitSelfieButton()
  }
  
  @objc func showSmartIdViewController() {
    if currentDocumenttypeMask != nil {
      galleryModeFlag = false
      switchFromSingleshotToDefaultMode()
      present(smartIDController, animated: true, completion: {
        print("sample: smartIDViewController presented")
      })
    } else {
      showAlert(msg: "Select document type")
    }
    self.reinitSelfieButton()
  }
  
  @objc func showDocumenttypeList() {
    present(docTypeListViewController, animated: true, completion: nil)
  }
  
  @objc func showSelfiePicker() {
    if self.currentPhotoImage == nil {
      return
    }
    self.selfieImagePicker.delegate = self
    self.present(self.selfieImagePicker, animated: true, completion: nil)
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
        // @skipCA (true/false) - skip DG14 checking. DG14 needs for "check_4000000000003"
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
    guard let passport = passport else { return }
    
    let dataGroupDict = [
      "COM": "rfid_com",
      "SOD": "rfid_sod",
      "DG1": "rfid_dg1",
      "DG2": "rfid_dg2",
      "DG7": "rfid_dg7",
      "DG11": "rfid_dg11",
      "DG12": "rfid_dg12",
      "DG14": "rfid_dg14",
      "DG15": "rfid_dg15"
    ]
    let hashDict = passport.dumpPassportData(selectedDataGroups: DataGroupId.allCases, includeActiveAuthenticationData: true)
    //Check that doctype from recogized document and photo from NFC scanning are exist
    var rfidCheckFields: [(String, String, SEIdCheckStatus, [String: String])] = []
    if self.doctyperaw != nil && passport.passportImage != nil {
      //Creating JSON-structure for ProcessData
      var NFCData: [String: Any] = [
        "doc_type": self.doctyperaw!,
        "physical_fields": [
          "rfid_mrz": [
            "value": passport.passportMRZ, //MRZ from NFC-scanning
            "type": "String"
          ],
          "rfid_photo": [
            "value": passport.passportImage!.toJpegString(compressionQuality: 1), //Photo as string from NFC-scanning
            "type": "Image"
          ]
        ]
      ]
      guard var physicalFields = NFCData["physical_fields"] as? [String: Any] else { return }
      for (dataGroup, value) in hashDict {
        if let mappedKey = dataGroupDict[dataGroup] {
          physicalFields[mappedKey] = [
            "value": value,
            "type": "String"
          ]
        }
      }
      NFCData["physical_fields"] = physicalFields
      do {
        let jsonString = try JSONSerialization.data(withJSONObject: NFCData, options: [])
        //Creating JSON-string
        let jsonStr = String(data: jsonString, encoding: .utf8)!
        
        //Call ProcessData from the same session where the document was recognized
        let r = self.engineInstance.processData(jsonStr)
        
        if r.getRef().getForensicCheckFieldsCount() > 0 {
          let fr_i = r.getRef().forensicCheckFieldsBegin()
          while !fr_i.isEqual(toIter: r.getRef().forensicCheckFieldsEnd()) {
            let fieldName = fr_i.getKey()
            let status = fr_i.getValue().getValue()
            let isAccepted = fr_i.getValue().getBaseFieldInfo().getIsAccepted()
            let confidence = fr_i.getValue().getBaseFieldInfo().getConfidence()
            var attributes: [String: String] = [:]
            let attrIter = fr_i.getValue().getBaseFieldInfo().attributesBegin()
                    let attrEnd = fr_i.getValue().getBaseFieldInfo().attributesEnd()
            while !attrIter.isEqual(toIter: attrEnd) {
              attributes[attrIter.getKey()] = attrIter.getValue()
              attrIter.advance()
            }
            
            if checks.contains(fieldName) {
              var value = "none"
              
              switch status {
              case SEIdCheckStatus.passed:
                value = "passed"
              case SEIdCheckStatus.failed:
                value = "failed"
              case SEIdCheckStatus.undefined:
                value = "undefined"
              }

              rfidCheckFields.append((fieldName, value, status, attributes))
            }
            fr_i.advance()
          }
        }
      } catch {
        print(error)
      }
    }
    
    resultSections.removeAll { section in
      if case .nfcData = section { return true }
      return false
    }
    var nfcFields: [(String, String)] = []
    
    nfcFields.append(("Document Type", passport.documentType))
    nfcFields.append(("Document Number", passport.documentNumber))
    nfcFields.append(("First Name", passport.firstName))
    nfcFields.append(("Last Name", passport.lastName))
    nfcFields.append(("Date of Birth", passport.dateOfBirth))
    nfcFields.append(("Nationality", passport.nationality))
    nfcFields.append(("Gender", passport.gender))
    nfcFields.append(("Expiry Date", passport.documentExpiryDate))
    nfcFields.append(("Issuing Authority", passport.issuingAuthority))
    nfcFields.append(("MRZ", passport.passportMRZ))
    nfcFields.append(("Certificate Verified", passport.documentSigningCertificateVerified ? "YES" : "NO"))
    nfcFields.append(("Correctly Signed", passport.passportCorrectlySigned ? "YES" : "NO"))
    nfcFields.append(("Data Not Tampered", passport.passportDataNotTampered ? "YES" : "NO"))
    
    resultSections.insert(.nfcData(nfcFields), at: 0)
    resultSections.insert(.rfidCheck(rfidCheckFields), at: 0)
    
    if let passportImage = passport.passportImage {
      resultSections.removeAll { section in
        if case .images(let images) = section {
          return images.contains { $0.fieldName.contains("rfid") }
        }
        return false
      }
      
      if let imageSectionIndex = resultSections.firstIndex(where: {
        if case .images = $0 { return true }
        return false
      }) {
        if case .images(var existingImages) = resultSections[imageSectionIndex] {
          existingImages.append(("RFID Photo", passportImage, true, -1.0, [:]))
          resultSections[imageSectionIndex] = .images(existingImages)
        }
      } else {
        resultSections.append(.images([("RFID Photo", passportImage, true, -1.0, [:])]))
      }
    }
    
    nfcButton.isEnabled = false
    resultTableView.reloadData()
  }
}

extension UIImage {
  func toJpegString(compressionQuality cq: CGFloat) -> String? {
    if let data = self.jpegData(compressionQuality: cq) {
      return data.base64EncodedString(options: .endLineWithLineFeed)
    }
    return nil
  }
}

// MARK: SEResultTableView
extension SampleViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return resultSections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch resultSections[section] {
    case .documentInfo(let fields): return fields.count
    case .nfcData(let fields): return fields.count
    case .rfidCheck(let fields): return fields.count
    case .selfieCheck(let fields): return fields.count
    case .forensicCheck(let fields): return fields.count
    case .images(let images): return images.count
    case .message: return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch resultSections[indexPath.section] {
    case .documentInfo(let fields):
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextFieldCell
      let field = fields[indexPath.row]
      cell.configure(with: field.fieldName, value: field.value, isAccepted: field.isAccepted, confidence: field.confidence, attributes: field.attributes)
      return cell
      
    case .nfcData(let fields):
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextFieldCell
      let field = fields[indexPath.row]
      cell.configure(with: field.fieldName, value: field.value, isAccepted: true, confidence: -1.0, attributes: [:])
      return cell
      
    case .rfidCheck(let fields):
      let cell = tableView.dequeueReusableCell(withIdentifier: "RfidTextCell", for: indexPath) as! ForensicTextFieldCell
      let field = fields[indexPath.row]
      cell.configure(with: field.fieldName, value: field.value, status: field.status, attributes: field.attributes)
      return cell
      
    case .selfieCheck(let fields):
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextFieldCell
      let field = fields[indexPath.row]
      cell.configure(with: field.fieldName, value: field.value, isAccepted: true, confidence: -1.0, attributes: [:])
      return cell
      
    case .forensicCheck(let fields):
      let cell = tableView.dequeueReusableCell(withIdentifier: "ForensicTextCell", for: indexPath) as! ForensicTextFieldCell
      let field = fields[indexPath.row]
      cell.configure(with: field.fieldName, value: field.value, status: field.status, attributes: field.attributes)
      return cell
      
    case .images(let images):
      let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageViewCell
      let image = images[indexPath.row]
      cell.configure(with: image.fieldName, image: image.value, isAccepted: image.isAccepted, confidence: image.confidence, attributes: image.attributes)
      return cell
    
    case .message(let message):
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextFieldCell
      cell.configure(with: "Message", value: message, isAccepted: true, confidence: -1.0, attributes: [:])
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .systemBlue
    
    switch resultSections[section] {
    case .documentInfo: label.text = "DOCUMENT INFORMATION"
    case .nfcData: label.text = "NFC DATA"
    case .rfidCheck: label.text = "RFID CHECKS"
    case .selfieCheck: label.text = "SELFIE VERIFICATION"
    case .forensicCheck: label.text = "FORENSIC CHECKS"
    case .images: label.text = "IMAGES"
    case .message: label.text = "RESULT"
    }
    
    header.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
      label.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
      label.topAnchor.constraint(equalTo: header.topAnchor, constant: 8),
      label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8)
    ])
    
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

@available(iOS 13.0.0, *)
extension SampleViewController {
    
  func pickImageByUIImage(image: UIImage) {
    self.setupImagePickerActivity()
    self.pickerImageActivityIndicator.startAnimating()
    DispatchQueue.main.async { [weak self] in
      self?.switchFromDefaultToSingleshotMode()
      self?.engineInstance.processSingleImageAsync(image, withCompletionHandler: nil)
      self?.pickerImageActivityIndicator.stopAnimating()
    }
  }
  
  func pickSelfie(image: UIImage) {
    
    guard let photoImage = self.currentPhotoImage else {
      return
    }
    // Sync way
    //let similarityResult = self.engineInstance.compareFaces(fromDocument: photoImage.getRef(), andSelfie: selfieImage.getRef())
    
    DispatchQueue.main.async { [weak self] in
      
      let selfieImage = SECommonImage(from: image)
      
      self?.engineInstance
        .compareFacesAsync(
          fromDocument: photoImage,
          andSelfie: selfieImage,
          withCompletionHandler: self?.selfieCallback
        )
      
      self?.pickerImageActivityIndicator.stopAnimating()
    }
  }
  
  func selfieCallback(similarityResult: SEIdFaceSimilarityResult) {
    let similarityEstimation = similarityResult.getRef().getSimilarityEstimation()
    let similarity = similarityResult.getRef().getSimilarity()
    
    var similarityText = ""
    switch similarity {
    case SEDifferent: similarityText = "Different"
    case SEUncertain: similarityText = "Uncertain"
    case SESame: similarityText = "Same"
    default: similarityText = "Unknown status"
    }
    
    resultSections.removeAll { section in
      if case .selfieCheck = section { return true }
      return false
    }
    
    let selfieFields = [
      ("Similarity Score", "\(similarityEstimation)"),
      ("Verification Result", similarityText)
    ]
    
    resultSections.append(.selfieCheck(selfieFields))
    resultTableView.reloadData()
    dismiss(animated: true, completion: nil)
  }
    
  func initImagePickerActivityContainer() -> UIView {
    let activityWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)/5
    let activityContainer = UIView()
    activityContainer.backgroundColor = .black
    activityContainer.alpha = 0.8
    activityContainer.layer.cornerRadius = 10
    
    self.photoLibraryImagePicker.view.addSubview(activityContainer)
    
    activityContainer.translatesAutoresizingMaskIntoConstraints = false
    activityContainer.centerXAnchor.constraint(equalTo: self.photoLibraryImagePicker.view.centerXAnchor).isActive = true
    activityContainer.centerYAnchor.constraint(equalTo: self.photoLibraryImagePicker.view.centerYAnchor).isActive = true
    activityContainer.widthAnchor.constraint(equalToConstant: activityWidth).isActive = true
    activityContainer.heightAnchor.constraint(equalToConstant: activityWidth).isActive = true
    activityContainer.isHidden = true
    
    return activityContainer
  }
  
  func initImagePickerContainerBackground() {
    self.pickerIAIContainerBackground = UIView()
    self.pickerIAIContainerBackground.alpha = 0.2
    self.pickerIAIContainerBackground.backgroundColor = .gray
    self.pickerIAIContainerBackground.isUserInteractionEnabled = false
    self.pickerIAIContainerBackground.isHidden = true
    
    self.photoLibraryImagePicker.view.addSubview(self.pickerIAIContainerBackground)
    
    self.pickerIAIContainerBackground.translatesAutoresizingMaskIntoConstraints = false
    self.pickerIAIContainerBackground.centerXAnchor.constraint(equalTo: self.photoLibraryImagePicker.view.centerXAnchor).isActive = true
    self.pickerIAIContainerBackground.centerYAnchor.constraint(equalTo: self.photoLibraryImagePicker.view.centerYAnchor).isActive = true
    
    self.pickerIAIContainerBackground.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    self.pickerIAIContainerBackground.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
  }
  
  func addImagePickerActivityToContainer() {
    self.pickerImageActivityIndicator = UIActivityIndicatorView()
    self.pickerImageActivityIndicator.style = UIActivityIndicatorView.Style.large
    self.pickerImageActivityIndicator.color = .red
    self.pickerImageActivityIndicatorContainer.addSubview(self.pickerImageActivityIndicator)
    self.pickerImageActivityIndicatorContainer.center  = self.pickerImageActivityIndicator.center
    self.pickerImageActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.pickerImageActivityIndicator.centerXAnchor.constraint(equalTo: self.pickerImageActivityIndicatorContainer.centerXAnchor).isActive = true
    self.pickerImageActivityIndicator.centerYAnchor.constraint(equalTo: self.pickerImageActivityIndicatorContainer.centerYAnchor).isActive = true
  }
  
  func setupImagePickerActivityBackground() {
    initImagePickerContainerBackground()
    self.pickerImageActivityIndicatorContainer = initImagePickerActivityContainer()
    self.addImagePickerActivityToContainer()
  }
  
  func setupImagePickerActivity() {
    self.pickerIAIContainerBackground.isHidden = false
    self.pickerImageActivityIndicatorContainer.isHidden = false
    self.pickerImageActivityIndicator.isHidden = false
  }
    
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if picker == self.photoLibraryImagePicker {
      pickImageByUIImage(image: info[.originalImage] as! UIImage)
    } else if picker == self.selfieImagePicker {
      pickSelfie(image: info[.originalImage] as! UIImage)
    } else {
      // noop
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.resultTextView.text = "Recognition cancelled by user!"
    self.resultImageView.image = nil
    self.dismiss(animated: true, completion: nil)
  }
}

@available(iOS 13.0.0, *)
extension SampleViewController: SmartIDViewControllerDelegate {
  func smartIDViewControllerDidRecognize(_ result: SEIdResult, from buffer: CMSampleBuffer?) {
    let resultRef = result.getRef()
    if resultRef.getIsTerminal() {
      self.setResult(result: resultRef)
      resultTableView.reloadData()
      dismiss(animated: true, completion: nil)
    }
  }
  
  func smartIDViewControllerDidRecognizeSingleImage(_ result: SEIdResult) {
    self.setResult(result: result.getRef())
    resultTableView.reloadData()
    dismiss(animated: true, completion: nil)
  }
  
  func smartIDViewControllerDidCancel() {
    resultTextView.text = "Recognition cancelled by user!"
    resultImageView.image = nil
    dismiss(animated: true, completion: nil)
  }
  
  func smartIDViewControllerDidStop(_ result: SEIdResult) {
    self.setResult(result: result.getRef())
    resultTableView.reloadData()
    dismiss(animated: true, completion: nil)
  }
  
  func smartIDEngineDidSetProcessTime(_ processTime : TimeInterval ) {
    print("processTime:", processTime);
  }
}
