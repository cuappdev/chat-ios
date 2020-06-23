//
//  FeedbackView.swift
//  SupportClient
//
//  Created by Cameron Russell on 4/22/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Photos
import UIKit

/**
 An  enum signaling whether the feedback form contains enough information to be
 considered "complete" and reasy to send to the admin
 */
enum Status {
    case complete
    case incomplete
}

/**
 A custom Feedback view that displays all the necessary components of a standard
 feedback form
 */
class FeedbackView: UIView {
    
    weak var delegate: FeedbackViewDelegate?
    
    private let addFileButton = UIButton()
    private var attachedFiles = [PHAsset]()
    private var attachmentsCollectionView: UICollectionView!
    private let attachmentsLabel = UILabel()
    private let messageLabel = UILabel()
    private let messageTextView = UITextView()
    private let overviewLabel = UILabel()
    private var typeData = [String]()
    private let typeLabel = UILabel()
    private let typePickerView = UIPickerView()
    private let typeTextField = UITextField()
    
    public var status = Status.incomplete {
        didSet {
            delegate?.checkStatus(with: status)
        }
    }
    
    private let padding: CGFloat = 15
    private let imageHeight: CGFloat = 150
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupData()
        setupAddFileButton()
        setupAttachmentsLabel()
        setupAttachmentsCollectionView()
        setupMessageLabel()
        setupMessageTextView()
        setupOverviewLabel()
        setupTypeLabel()
        setupTypePickerView()
        setupTypeTextField()
        setupGestureRecognizer()
        setupConstraints()
    }
    
    convenience init(frame: CGRect, with delegate: FeedbackViewDelegate) {
        self.init(frame: frame)
        self.delegate = delegate
    }
    
    func setupData() {
        typeData = ["", "Hello", "World"]  // TODO: Connect with actual data
    }
    
    func setupAddFileButton() {
        addFileButton.translatesAutoresizingMaskIntoConstraints = false
        addFileButton.layer.cornerRadius = 8
        addFileButton.layer.borderWidth = 0.75
        addFileButton.layer.borderColor = UIColor._darkGray.cgColor
        let image = UIImage(named: "plus", in: PatchKitImages.resourceBundle, compatibleWith: nil)?.withTintColor(._darkGray)
        addFileButton.setImage(image, for: .normal)
        addFileButton.addTarget(self, action: #selector(addFiles(_:)), for: .touchUpInside)
        addSubview(addFileButton)
    }
    
    func setupAttachmentsLabel() {
        attachmentsLabel.translatesAutoresizingMaskIntoConstraints = false
        attachmentsLabel.text = "Attachments:"
        attachmentsLabel.font = UIFont.systemFont(ofSize: 18)
        attachmentsLabel.textColor = .black
        let border = drawTopBorder(width: frame.size.width - 2 * padding)
        attachmentsLabel.layer.addSublayer(border)
        addSubview(attachmentsLabel)
    }
    
    func setupAttachmentsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        attachmentsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        attachmentsCollectionView.backgroundColor = ._lightGray
        attachmentsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        attachmentsCollectionView.delegate = self
        attachmentsCollectionView.dataSource = self
        attachmentsCollectionView.showsHorizontalScrollIndicator = false
        attachmentsCollectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: FileCollectionViewCell.reuseID)
        addSubview(attachmentsCollectionView)
    }
    
    func setupMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(
            string: "Message*",
            attributes: [
                NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)
            ]
        )
        attributedText.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.red,
            range: NSRange(location: 7, length: 1)
        )
        messageLabel.attributedText = attributedText
        let border = drawTopBorder(width: frame.size.width - 2 * padding)
        messageLabel.layer.addSublayer(border)
        addSubview(messageLabel)
    }
    
    func setupMessageTextView() {
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.backgroundColor = ._lightGray
        messageTextView.text = "Let us know what happened."
        messageTextView.textColor = .lightGray
        messageTextView.delegate = self
        messageTextView.font = UIFont.systemFont(ofSize: 14)
        messageTextView.textAlignment = .left
        messageTextView.isUserInteractionEnabled = true
        messageTextView.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        addSubview(messageTextView)
    }
    
    func setupOverviewLabel() {
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.numberOfLines = 0
        overviewLabel.lineBreakMode = .byWordWrapping
        overviewLabel.text = "We read all of your feedback and will respond in the inbox if necessary."
        overviewLabel.font = UIFont.systemFont(ofSize: 14)
        overviewLabel.textColor = ._textGray
        addSubview(overviewLabel)
    }
    
    func setupTypeLabel() {
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(
            string: "Type*",
            attributes: [
                NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)
            ]
        )
        attributedText.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.red,
            range: NSRange(location: 4, length: 1)
        )
        typeLabel.attributedText = attributedText
        let border = drawTopBorder(width: frame.size.width - 2 * padding)
        typeLabel.layer.addSublayer(border)
        addSubview(typeLabel)
    }
    
    func setupTypePickerView() {
        typePickerView.translatesAutoresizingMaskIntoConstraints = false
        typePickerView.dataSource = self
        typePickerView.delegate = self
        typePickerView.backgroundColor = .white
        // Set up toolbar for PickerView
        let toolbar = UIToolbar()
        toolbar.barTintColor = .white
        toolbar.isTranslucent = false
        toolbar.layer.cornerRadius = 20
        toolbar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        toolbar.layer.masksToBounds = true
        toolbar.sizeToFit()
        toolbar.isUserInteractionEnabled = true
        toolbar.tintColor = .black
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(didTapDone)
        )
        let space = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        // Set up horizontal line to distinguish between UIPickerView and ToolBar
        let border = drawTopBorder(width: frame.size.width, spacing: false)
        typePickerView.layer.addSublayer(border)
        typeTextField.inputAccessoryView = toolbar
        typePickerView.reloadAllComponents()
    }
    
    func setupTypeTextField() {
        typeTextField.translatesAutoresizingMaskIntoConstraints = false
        typeTextField.placeholder = "Choose type"
        typeTextField.font = UIFont.systemFont(ofSize: 14)
        typeTextField.inputView = typePickerView
        typeTextField.delegate = self
        addSubview(typeTextField)
    }
    
    func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            overviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2 * padding),
            overviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2 * padding),
            overviewLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding)
        ])
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            typeLabel.widthAnchor.constraint(equalToConstant: 50),
            typeLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 2 * padding)
        ])
        NSLayoutConstraint.activate([
            typeTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            typeTextField.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: padding),
            typeTextField.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor, constant: 2),
            typeTextField.heightAnchor.constraint(equalToConstant: 32)
        ])
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            messageLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 2 * padding)
        ])
        NSLayoutConstraint.activate([
            messageTextView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: padding / 2),
            messageTextView.heightAnchor.constraint(equalToConstant: 120),
            messageTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            messageTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
        NSLayoutConstraint.activate([
            attachmentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            attachmentsLabel.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 2 * padding)
        ])
        NSLayoutConstraint.activate([
            addFileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            addFileButton.topAnchor.constraint(equalTo: attachmentsLabel.bottomAnchor, constant: padding),
            addFileButton.widthAnchor.constraint(equalToConstant: 90),
            addFileButton.heightAnchor.constraint(equalToConstant: imageHeight)
        ])
        NSLayoutConstraint.activate([
            attachmentsCollectionView.heightAnchor.constraint(equalTo: addFileButton.heightAnchor),
            attachmentsCollectionView.leadingAnchor.constraint(equalTo: addFileButton.trailingAnchor, constant: padding),
            attachmentsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            attachmentsCollectionView.topAnchor.constraint(equalTo: addFileButton.topAnchor)
        ])
    }
    
    /**
     Checks to see whether the user has made a valid selection.
     Requires the first element in the component to be an invalid choice.
     */
    func checkStatus() {
        if typePickerView.selectedRow(inComponent: 0) != -1 {
            if messageTextView.textColor != .lightGray || attachedFiles.count > 0 {
                status = .complete
            } else {
                status = .incomplete
            }
        }
    }
    
    func configureFiles(for selectedFiles: [PHAsset]) {
        attachedFiles = Array(Set(attachedFiles + selectedFiles))
        attachmentsCollectionView.reloadData()
        checkStatus()
    }
    
    func drawTopBorder(width: CGFloat, spacing: Bool = true, height: CGFloat = 1.5) -> CALayer {
        let border = CALayer()
        let yPos = spacing ? -padding : 0
        border.frame = CGRect(x: -5, y: yPos, width: width + 2 * 5, height: 1.5)
        border.backgroundColor = UIColor._mediumGray.cgColor
        return border
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    @objc func addFiles(_ sender: UIButton) {
        delegate?.selectFiles()
    }
    
    @objc func didTapDone() {
        let row = typePickerView.selectedRow(inComponent: 0)
        typePickerView.selectRow(row, inComponent: 0, animated: true)
        typeTextField.text = typeData[row]
        typeTextField.resignFirstResponder()
    }
    
    @objc func didTapCancel() {
        typeTextField.resignFirstResponder()
        typeTextField.text = nil
        typeTextField.placeholder = "Choose type"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - UICollectionView DataSource
extension FeedbackView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachedFiles.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.reuseID, for: indexPath) as! FileCollectionViewCell
        let file = attachedFiles[indexPath.item]
        cell.configure(for: file, with: self)
        return cell
    }
    
}

// MARK: - UICollectionView Delegate
extension FeedbackView: UICollectionViewDelegate {
        
    // TODO: Open up image editor with image tapped on
    
}

// MARK: - UICollectionView DelegateFlowLayout
extension FeedbackView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let file = attachedFiles[indexPath.item]
        let width: CGFloat = CGFloat(Int(imageHeight) * file.pixelWidth / file.pixelHeight)
        return CGSize(width: width, height: imageHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
        
}

// MARK: - UITextView Delegate
extension FeedbackView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Once user begins editing, change color to text for pseudo-placeholder effect
        if textView == messageTextView, textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // If user did not add message, replace with default text
        if textView == messageTextView, textView.text.isEmpty {
            textView.text = "Let us know what happened."
            textView.textColor = .lightGray
        }
        checkStatus()
    }
    
}

// MARK: - UIPickerView Datasource
extension FeedbackView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        typePickerView.subviews.forEach { $0.isHidden = $0.frame.height < 1.0 }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeData.count
    }
    
}

// MARK: - UIPickerView Delegate
extension FeedbackView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Reload components to remove the checkmark from previous selection
        pickerView.reloadAllComponents()
        
        // Update the typeTextField and recheck whether the message is ready to send
        typeTextField.text = typeData[row]
        checkStatus()
    }
        
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pvr = PickerViewRow()
        pvr.setup(withText: typeData[row], withView: view)
        return pvr
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
}

// MARK: - RemoveFile Delegate
extension FeedbackView: RemoveFileDelegate {
    
    func removeFile(_ file: PHAsset) {
        attachedFiles.remove(at: attachedFiles.firstIndex(of: file)!)
        attachmentsCollectionView.reloadData()
        attachmentsCollectionView.collectionViewLayout.invalidateLayout()
        checkStatus()
    }
    
}

// MARK: - TextField Delegate
extension FeedbackView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == typeTextField {
            setupTypePickerView()
        }
    }
    
}
