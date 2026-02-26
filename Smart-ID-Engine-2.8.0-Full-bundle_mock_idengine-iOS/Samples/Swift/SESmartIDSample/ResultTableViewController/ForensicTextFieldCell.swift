/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

class ForensicTextFieldCell: UITableViewCell {
  private let stackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = 8
    stack.alignment = .top
    return stack
  }()
  
  private let contentStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 4
    return stack
  }()
  
  let fieldNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .systemGray
    return label
  }()
  
  let valueLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    return label
  }()
  
  let metadataLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = .systemGray
    label.numberOfLines = 0
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.addSubview(stackView)
    stackView.addArrangedSubview(contentStack)
    contentStack.addArrangedSubview(fieldNameLabel)
    contentStack.addArrangedSubview(valueLabel)
    contentStack.addArrangedSubview(metadataLabel)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
  
  func configure(with fieldName: String, value: String, status: SEIdCheckStatus, attributes: [String: String]) {
    fieldNameLabel.text = fieldName.uppercased()
    valueLabel.text = value
    
    switch status {
    case SEIdCheckStatus.passed:
      valueLabel.textColor = .systemGreen
    case SEIdCheckStatus.failed:
      valueLabel.textColor = .systemRed
    default:
      valueLabel.textColor = .systemOrange
    }
    
    var metadataText = ""
    
    if !attributes.isEmpty {
      metadataText += "attributes:\n"
      for (key, value) in attributes.sorted(by: { $0.key < $1.key }) {
        metadataText += "  \(key): \(value)\n"
      }
    }
    
    metadataLabel.text = metadataText.isEmpty ? nil : metadataText
    backgroundColor = .clear
  }
}
