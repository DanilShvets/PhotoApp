//
//  SignUpController.swift
//  PhotoApp
//
//  Created by Данил Швец on 05.04.2022.
//

import UIKit

final class SignUpController: UIViewController, UITextFieldDelegate {
    
    private struct UIConstants {
        static let spacing = 10.0
        static let borderWidth = 0.5
        static let cornerRadius: CGFloat = 10
        static let iconPadding: CGFloat = -30
        static let padding: CGFloat = 10
    }
    
    private let logInModel = LogInModel()
    private let alert = UIAlertController(title: "Внимание", message: "", preferredStyle: .alert)
    private let mailIcon: UIImageView = UIImageView(image: UIImage(systemName: "mail")!)
    private let userIcon: UIImageView = UIImageView(image: UIImage(systemName: "person")!)
    private let passwordIcon: UIImageView = UIImageView(image: UIImage(systemName: "lock")!)
    private let signUpLabel = UILabel()
    private lazy var mailInputView = UITextField()
    private lazy var usernameInputView = UITextField()
    private lazy var passwordInputView = UITextField()
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        configureView()
    }
    
    private func configureView() {
        self.mailInputView.delegate = self
        self.usernameInputView.delegate = self
        self.passwordInputView.delegate = self
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        configureUIView()
    }
    
    private func configureUIView() {
        view.backgroundColor = UIColor.AppColors.backgroundColor
        
        view.addSubview(signUpLabel)
        signUpLabel.textAlignment = .left
        signUpLabel.text = "Регистрация"
        signUpLabel.textColor = UIColor.AppColors.mainColor
        signUpLabel.font = UIFont.boldSystemFont(ofSize: view.frame.size.width/12)
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpLabel.widthAnchor.constraint(equalToConstant: view.bounds.width/1.2).isActive = true
        signUpLabel.heightAnchor.constraint(equalToConstant: view.frame.size.width/10).isActive = true
        
        let mailStack = UIStackView(arrangedSubviews: [mailIcon, mailInputView])
        mailInputView.textColor = UIColor.AppColors.textColor
        mailInputView.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let userStack = UIStackView(arrangedSubviews: [userIcon, usernameInputView])
        usernameInputView.textColor = UIColor.AppColors.textColor
        usernameInputView.attributedPlaceholder = NSAttributedString(string: "Имя пользователя",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let passwordStack = UIStackView(arrangedSubviews: [passwordIcon, passwordInputView])
        passwordInputView.textColor = UIColor.AppColors.textColor
        passwordInputView.isSecureTextEntry = true
        passwordInputView.textContentType = .oneTimeCode
        passwordInputView.attributedPlaceholder = NSAttributedString(string: "Пароль",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        [mailStack, userStack, passwordStack].forEach {stack in
            stack.axis = .horizontal
            stack.spacing = UIConstants.spacing
            stack.alignment = .center
            view.addSubview(stack)
            stack.layer.borderColor = UIColor.AppColors.borderColor
            stack.layer.borderWidth = UIConstants.borderWidth
            stack.layer.cornerRadius = UIConstants.cornerRadius
            stack.isLayoutMarginsRelativeArrangement = true
            stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        }
        
        [mailIcon, userIcon, passwordIcon].forEach {icon in
            icon.tintColor = .gray
            icon.heightAnchor.constraint(equalTo: mailStack.heightAnchor, constant: UIConstants.iconPadding).isActive = true
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        }
        
        let stack = UIStackView(arrangedSubviews: [mailStack, userStack, passwordStack])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = UIConstants.spacing
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: UIConstants.padding).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 180).isActive = true
        stack.widthAnchor.constraint(equalToConstant: view.bounds.width/1.2).isActive = true
        
        view.addSubview(signUpButton)
        signUpButton.setTitle("Регистрация", for: .normal)
        signUpButton.backgroundColor = UIColor.AppColors.mainColor
        signUpButton.tintColor = .white
        signUpButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: view.frame.size.width/20)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: UIConstants.padding).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: view.bounds.width/3).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: view.bounds.width/8).isActive = true
        signUpButton.layer.cornerRadius = view.bounds.width/20
    }
    
    private func userSignedUp() {
        UserDefaults.standard.set(true, forKey: "userSignedUp")
        UserDefaults.standard.synchronize()
    }
    
    private func presentPhotos() {
        let photosController = PhotosController()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.pushViewController(photosController, animated: true)
    }
    
    private func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc private func signUpButtonPressed(_ sender: UIButton) {
        let userId = UUID().uuidString
        var allUsers = [String]()
        var allEmails = [String]()
        var userDict = [String:Any]()
        var userArray: [String:Any] = UserDefaults.standard.dictionary(forKey: "usersArray") ?? [:]
        var usersIdArray: [Any] = UserDefaults.standard.array(forKey: "usersIdArray") ?? []
        userDict = [:]
        
        self.logInModel.signUp(email: mailInputView.text, username: usernameInputView.text, password: passwordInputView.text) { error in
            alert.message = error
        }
        
        userArray.keys.forEach { index in
            allUsers.append((userArray[index] as! [String:String])["username"]?.lowercased() ?? "")
            allEmails.append((userArray[index] as! [String:String])["email"]?.lowercased() ?? "")
        }
        
        if logInModel.isValidEmail(email: mailInputView.text ?? "") && logInModel.isValidUsername(username: usernameInputView.text ?? "") && logInModel.isValidPassword(password: passwordInputView.text ?? "") {
            if allUsers.contains(where: { $0 == usernameInputView.text?.lowercased()}) || allEmails.contains(where: { $0 == mailInputView.text?.lowercased()}) {
                self.logInModel.isUser(exist: true) { error in
                    alert.message = error
                }
            } else {
                userDict.updateValue(usernameInputView.text ?? "", forKey: "username")
                userDict.updateValue(mailInputView.text ?? "", forKey: "email")
                userDict.updateValue(passwordInputView.text ?? "", forKey: "password")
                userArray.updateValue(userDict, forKey: "\(userId)")
                usersIdArray.append(userId)
                UserDefaults.standard.set(usersIdArray, forKey: "usersIdArray")
                UserDefaults.standard.set(userArray, forKey: "usersArray")
                userSignedUp()
                navigationController?.popViewController(animated: true)
                return
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
