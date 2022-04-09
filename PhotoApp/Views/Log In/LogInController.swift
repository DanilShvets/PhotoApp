//
//  SignInController.swift
//  PhotoApp
//
//  Created by Данил Швец on 04.04.2022.
//

import UIKit

final class LogInController: UIViewController, UITextFieldDelegate {
    
    private struct UIConstants {
        static let spacing = 10.0
        static let borderWidth = 0.5
        static let cornerRadius: CGFloat = 10
        static let iconPadding: CGFloat = -30
        static let padding: CGFloat = 20
    }
    
    private lazy var userDict = [String:Any]()
    private lazy var userArray = [Any]()
    private lazy var isWrongUser: Bool = true
    private let logInModel = LogInModel()
    private let alert = UIAlertController(title: "Внимание", message: "", preferredStyle: .alert)
    private let userIcon: UIImageView = UIImageView(image: UIImage(systemName: "person")!)
    private let passwordIcon: UIImageView = UIImageView(image: UIImage(systemName: "lock")!)
    private let loginLabel = UILabel()
    private lazy var usernameInputView = UITextField()
    private lazy var passwordInputView = UITextField()
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        return button
    }()
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentLogIn()
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        hideKeyboard()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
    }
    
    private func configureView() {
        self.usernameInputView.delegate = self
        self.passwordInputView.delegate = self
        configureUIView()
    }
    
    private func presentLogIn() {
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        UserDefaults.standard.set(false, forKey: "feedIsShown")
    }
    
    private func reloadView() {
        presentLogIn()
        if userSignedUp() {
            self.logInModel.isUser(exist: !userSignedUp()) { error in
                alert.message = error
                self.present(alert, animated: true, completion: nil)
            }
            UserDefaults.standard.set(false, forKey: "userSignedUp")
            UserDefaults.standard.synchronize()
        }
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func configureUIView() {
        view.backgroundColor = UIColor.AppColors.backgroundColor
        
        let userStack = UIStackView(arrangedSubviews: [userIcon, usernameInputView])
        view.addSubview(userStack)
        usernameInputView.textColor = UIColor.AppColors.textColor
        usernameInputView.attributedPlaceholder = NSAttributedString(string: "Имя пользователя",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let passwordStack = UIStackView(arrangedSubviews: [passwordIcon, passwordInputView])
        view.addSubview(passwordStack)
        passwordInputView.textColor = UIColor.AppColors.textColor
        passwordInputView.isSecureTextEntry = true
        passwordInputView.textContentType = .oneTimeCode
        passwordInputView.attributedPlaceholder = NSAttributedString(string: "Пароль",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        [userIcon, passwordIcon].forEach {icon in
            icon.tintColor = .gray
            icon.heightAnchor.constraint(equalTo: userStack.heightAnchor, constant: UIConstants.iconPadding).isActive = true
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        }
        
        [userStack, passwordStack].forEach { stack in
            stack.axis = .horizontal
            stack.spacing = UIConstants.spacing
            stack.alignment = .center
            stack.layer.borderColor = UIColor.AppColors.borderColor
            stack.layer.borderWidth = UIConstants.borderWidth
            stack.layer.cornerRadius = UIConstants.cornerRadius
            stack.isLayoutMarginsRelativeArrangement = true
            stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        }
       
        let stack = UIStackView(arrangedSubviews: [userStack, passwordStack])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = UIConstants.spacing
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 120).isActive = true
        stack.widthAnchor.constraint(equalToConstant: view.bounds.width/1.2).isActive = true
        
        view.addSubview(logInButton)
        logInButton.setTitle("Вход", for: .normal)
        logInButton.backgroundColor = UIColor.AppColors.mainColor
        logInButton.tintColor = .white
        logInButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: view.frame.size.width/20)
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: UIConstants.padding).isActive = true
        logInButton.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
        logInButton.widthAnchor.constraint(equalToConstant: view.bounds.width/3).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: view.bounds.width/8).isActive = true
        logInButton.layer.cornerRadius = view.bounds.width/20
        
        view.addSubview(loginLabel)
        loginLabel.textAlignment = .left
        loginLabel.text = "Вход"
        loginLabel.textColor = UIColor.AppColors.textColor
        loginLabel.font = UIFont.boldSystemFont(ofSize: view.frame.size.width/12)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -UIConstants.padding).isActive = true
        loginLabel.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: view.frame.size.width/10).isActive = true
        
        let mySelectedAttributedTitle = NSMutableAttributedString(string: "Нет аккаунта?  ",
                                                                  attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        signUpButton.setAttributedTitle(mySelectedAttributedTitle, for: .selected)

        mySelectedAttributedTitle.append(NSAttributedString(string: "Зарегистрироваться",
                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.35, green: 0.66, blue: 0.59, alpha: 1.00)]))
        signUpButton.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.padding).isActive = true
        
    }
    
    private func presentSignUp() {
        let signUpController = SignUpController()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.AppColors.mainColor
        navigationItem.backBarButtonItem = backItem
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.pushViewController(signUpController, animated: true)
    }
    
    private func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func presentPhotos() {
        UserDefaults.standard.set(true, forKey: "userLoggedIn")
        let photosController = PhotosController()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.pushViewController(photosController, animated: true)
    }
    
    private func userSignedUp() -> Bool {
        return UserDefaults.standard.bool(forKey: "userSignedUp")
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func clearTextfields() {
        usernameInputView.text?.removeAll()
        passwordInputView.text?.removeAll()
    }
    
    @objc private func logInButtonPressed() {
        var userDict = [String:Any]()
        
        if let arr =  UserDefaults.standard.dictionary(forKey: "usersArray") {
            UserDefaults.standard.array(forKey: "usersIdArray")?.forEach { index in
                userDict.updateValue((arr[index as! String] as! [String:String])["password"] ?? "", forKey: "\((arr[index as! String] as! [String:String])["username"] ?? "")")
            }
        }
        for (key, value) in userDict {
            if usernameInputView.text == key && passwordInputView.text == value as? String && logInModel.isValidUsername(username: usernameInputView.text ?? "") && logInModel.isValidPassword(password: passwordInputView.text ?? "") {
                isWrongUser = false
                presentPhotos()
                clearTextfields()
            }
        }
        
        self.logInModel.wrongUser(wrongUser: isWrongUser) { error in
            alert.message = error
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func signUpButtonPressed() {
        clearTextfields()
        presentSignUp()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

