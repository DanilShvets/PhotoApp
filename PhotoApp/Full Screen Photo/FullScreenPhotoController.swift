//
//  FullScreenPhotoController.swift
//  PhotoApp
//
//  Created by Данил Швец on 09.04.2022.
//

import UIKit

final class FullScreenPhotoController: UIViewController {
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray
        
        return button
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let navItem = UINavigationItem(title: "SomeTitle")
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(buttonPressed))
        view.addSubview(navBar)
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        view.backgroundColor = .purple
//        navigationController?.setNavigationBarHidden(false, animated: true)
//        navigationController?.navigationBar.backgroundColor = .green
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(buttonPressed))
    }
    
    private func configureUI() {
        
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
