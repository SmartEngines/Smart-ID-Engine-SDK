/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

import UIKit

class ImageViewCell: UITableViewCell {
  private let stackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = 8
    stack.alignment = .top
    return stack
  }()
  
  private let statusLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textAlignment = .center
    label.widthAnchor.constraint(equalToConstant: 30).isActive = true
    return label
  }()
  
  private let contentStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 8
    return stack
  }()
  
  let fieldNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .systemGray
    return label
  }()
  
  let imageFieldView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    view.backgroundColor = .clear
    view.layer.magnificationFilter = .nearest
    view.layer.minificationFilter = .nearest
    view.layer.shouldRasterize = true
    view.heightAnchor.constraint(equalToConstant: 200).isActive = true
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let metadataLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = .systemGray
    label.numberOfLines = 0
    return label
  }()
  
  private func setupUI() {
    contentView.addSubview(stackView)
    stackView.addArrangedSubview(statusLabel)
    stackView.addArrangedSubview(contentStack)
    contentStack.addArrangedSubview(fieldNameLabel)
    contentStack.addArrangedSubview(imageFieldView)
    contentStack.addArrangedSubview(metadataLabel)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
  
  func configure(with fieldName: String, image: UIImage, isAccepted: Bool, confidence: Double, attributes: [String: String]) {
    fieldNameLabel.text = fieldName.uppercased()
    imageFieldView.image = image
    
    statusLabel.text = isAccepted ? "[+]" : "[-]"
    statusLabel.textColor = isAccepted ? .systemGreen : .systemRed
    
    var metadataText = ""
    
    if confidence > 0 {
      metadataText += "confidence: \(String(format: "%.6f", confidence))\n"
    }
    
    if !attributes.isEmpty {
      metadataText += "attributes:\n"
      for (key, value) in attributes.sorted(by: { $0.key < $1.key }) {
        metadataText += "  \(key): \(value)\n"
      }
    }
    
    metadataLabel.text = metadataText.isEmpty ? nil : metadataText
  }
}
