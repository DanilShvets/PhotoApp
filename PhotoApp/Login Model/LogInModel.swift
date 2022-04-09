//
//  LogInModel.swift
//  PhotoApp
//
//  Created by Данил Швец on 07.04.2022.
//

import Foundation

final class LogInModel {
    
    func logIn(username: String?, password: String?, complitionError: (String) -> ()) {
        guard let username = username, !username.isEmpty else {
            complitionError("Неверное имя пользователя")
            return
        }
        guard let password = password,  password.count >= 6 else {
            complitionError("Неверный пароль")
            return
        }
    }
    
    func signUp(email: String?, username: String?, password: String?, complitionError: (String) -> ()) {
        guard let email = email, isValidEmail(email: email) else {
            complitionError("Неверный адрес электронной почты")
            return
        }
        guard let username = username, isValidUsername(username: username) else {
            complitionError("Имя пользователя должно быть не менее 3 символов и содержать только буквы и цифры")
            return
        }
        guard let password = password, isValidPassword(password: password) else {
            complitionError("Пароль должен быть не менее 6 символов и содержать только буквы, цифры и знаки . или _")
            return
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidUsername(username: String) -> Bool {
        let user = "[A-Z0-9a-z]{3,100}"
        let userPred = NSPredicate(format:"SELF MATCHES %@", user)
        return userPred.evaluate(with: username)
    }
    
    func isValidPassword(password: String) -> Bool {
        let pass = "[A-Z0-9a-z._]{6,100}"
        let passPred = NSPredicate(format:"SELF MATCHES %@", pass)
        return passPred.evaluate(with: password)
    }
    
    func wrongUser(wrongUser: Bool, complitionError: (String) -> ()) {
        if wrongUser == true {
            complitionError("Неправильные имя пользователя или пароль")
        } else {
            
        }
        return
    }
    
    func isUser(exist: Bool, complitionError: (String) -> ()) {
        if exist == true {
            complitionError("Такой пользователь существует")
        } else {
            complitionError("Вы успешно зарегистрированы!")
        }
        return
    }
    
}
