//
//  PhotosController.swift
//  PhotoApp
//
//  Created by Данил Швец on 05.04.2022.
//

import UIKit

final class PhotosPickerController: UIViewController {
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return image
    }()
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapChangeProfileImage), for: .touchUpInside)
        return button
    }()
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    private var imageWasChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        profileImageView.backgroundColor = .gray
        changePhotoButton.backgroundColor = .blue
        let stack = UIStackView(arrangedSubviews: [profileImageView, changePhotoButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 400).isActive = true
        stack.widthAnchor.constraint(equalToConstant: view.bounds.width/1.2).isActive = true
        
        
    }
    
    
 
}

extension PhotosPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        profileImageView.image = image
        imageWasChanged = true
//        dismiss(animated: true, completion: nil)
        if imageWasChanged == true {
            dismiss(animated: true, completion: nil)
            let vc = ViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}

extension PhotosPickerController {
    @objc private func didTapChangeProfileImage() {
        present(imagePickerController, animated: true, completion: nil)
    }
}
