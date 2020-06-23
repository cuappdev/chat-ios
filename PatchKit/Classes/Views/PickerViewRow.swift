//
//  PickerViewRow.swift
//  PatchKit
//
//  Created by Cameron Russell on 6/23/20.
//

import UIKit

class PickerViewRow: UIView {
    
    public let checkMarkImageView = UIImageView()
    private var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func setup(withText text: String, withView view: UIView?) {
        if let v = view as? UILabel {
            label = v
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = text
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
            checkMarkImageView.image = UIImage(named: "checkmark", in: PatchKitImages.resourceBundle, compatibleWith: nil)
            
            addSubview(checkMarkImageView)
            NSLayoutConstraint.activate([
                checkMarkImageView.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width - 25),
                checkMarkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                checkMarkImageView.widthAnchor.constraint(equalToConstant: 15),
                checkMarkImageView.heightAnchor.constraint(equalToConstant: 11)
            ])
        }
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
