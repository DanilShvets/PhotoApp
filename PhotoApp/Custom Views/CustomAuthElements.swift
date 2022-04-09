//
//  CustomAuthElements.swift
//  PhotoApp
//
//  Created by Данил Швец on 04.04.2022.
//

import UIKit

final class InputField: UIView {

    private struct UIConstants {
        static let height = 50.0
        static let width = 200.0
        
        static let iconWidth = 20.0
        static let iconHeight = 20.0
        
        static let paddingLeft = 28.0
        static let paddingRight = -28.0
        static let paddingBottom = -8.0
        
        static let space = 8.0
        
        static let dividerWidth = 1.0
    }
    
    public lazy var textField = UITextField()
    
    private var icon: UIImageView?
    private let dividerView = UIView()
    
    init(labelImage: UIImage? = nil, keyboardType: UIKeyboardType = .default, placeholderText: String?) {
        super.init(frame: .zero)
        
        heightAnchor.constraint(equalToConstant: UIConstants.height).isActive = true
        if labelImage != nil {
            icon = UIImageView()
        }
        addIcon(labelImage: labelImage)
        addTextfield(placeholderText: placeholderText)
        addDivider()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addIcon(labelImage: UIImage? = nil) {
        guard let icon = icon else {
            return
        }
        addSubview(icon)
        icon.image = labelImage
        icon.tintColor = .black
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: UIConstants.iconWidth).isActive = true
        icon.heightAnchor.constraint(equalToConstant: UIConstants.iconHeight).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: UIConstants.paddingLeft).isActive = true
        icon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIConstants.paddingBottom).isActive = true
    }
    
    private func addTextfield(placeholderText: String?) {
        addSubview(textField)
        textField.autocorrectionType = .no
        textField.placeholder = placeholderText
        textField.translatesAutoresizingMaskIntoConstraints = false

        if let icon = icon {
            textField.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: UIConstants.space).isActive = true
        } else {
            textField.leftAnchor.constraint(equalTo: leftAnchor, constant: UIConstants.paddingLeft).isActive = true
        }
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: UIConstants.paddingRight).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIConstants.paddingBottom).isActive = true
    }

    private func addDivider() {
        addSubview(dividerView)
        dividerView.backgroundColor = .gray
        dividerView.translatesAutoresizingMaskIntoConstraints = false

        dividerView.heightAnchor.constraint(equalToConstant: UIConstants.dividerWidth).isActive = true
        dividerView.leftAnchor.constraint(equalTo: leftAnchor, constant: UIConstants.paddingLeft).isActive = true
        dividerView.rightAnchor.constraint(equalTo: rightAnchor, constant: UIConstants.paddingRight).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

final class CustomRoundedButton: UIView {
//    private struct UIConstants {
//        static let height = 50.0
//        static let width = 200.0
//    }
    
    init(image: UIImage? = nil, title: String? = nil, target: Any? = nil, action: Selector? = nil, tag: Int = 0, width: CGFloat? = nil, height: CGFloat? = nil, color: UIColor = .blue, toRight: Bool = false, textColor: UIColor = .white) {

        super.init(frame: .zero)

//        heightAnchor.constraint(equalToConstant: height ?? UIConstants.height).isActive = true

        let button = UIButton(type: .system)
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }

        button.tag = tag
//        button.layer.cornerRadius = UIConstants.height / 2;
        button.backgroundColor = color
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = textColor

        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
//        toRight ? (button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true) : (button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true)
//        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        button.widthAnchor.constraint(equalToConstant: width ?? UIConstants.width).isActive = true
//        button.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class AttributedCustomButton: UIButton {
    private struct UIConstants {
        static let fontSize = 16.0
    }
    init(firstPart: String, secondPart: String) {
        super.init(frame: .zero)
        let attributedTitle = NSMutableAttributedString(
            string: firstPart,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIConstants.fontSize)
            ]
        )
        attributedTitle.append(NSAttributedString(
            string: secondPart,
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIConstants.fontSize),
                NSAttributedString.Key.foregroundColor: UIColor.red
            ]
        ))
        setAttributedTitle(attributedTitle, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


