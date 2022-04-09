//
//  PhotosController.swift
//  PhotoApp
//
//  Created by Данил Швец on 06.04.2022.
//

import UIKit
import Photos

final class PhotosController: UIViewController {
    
    private struct UIConstants {
        static let buttonFontSize: CGFloat = 20
        static let buttonTopPadding: CGFloat = 5
        static let padding: CGFloat = 10
        static let collectionTopPadding: CGFloat = 25
    }
    
    private lazy var images = [PHAsset]()
    private var accountImage: UIImage!
    private lazy var skipButtton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tag = 0
        return button
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    private let iconLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "photo")
        image.contentMode = .scaleAspectFit
        return image
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        let sizeCell = CGSize(width: view.bounds.width/3.5, height: view.bounds.width/3.5)
        layout.itemSize = sizeCell
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.register(PhotosCell.self, forCellWithReuseIdentifier: "PhotosCell")
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        accessToPhotos()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadImage()
    }
    
    private func configureUI() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        iconImage.isUserInteractionEnabled = true
        iconImage.addGestureRecognizer(tapGestureRecognizer)
        
        view.backgroundColor = UIColor(red: 0.97, green: 0.96, blue: 0.95, alpha: 1.00)
        loadImage()
        [skipButtton, saveButton].forEach { button in
            view.addSubview(button)
            button.titleLabel?.font =  UIFont.systemFont(ofSize: UIConstants.buttonFontSize)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.buttonTopPadding).isActive = true
            button.heightAnchor.constraint(equalToConstant: view.bounds.width/8).isActive = true
            button.layer.cornerRadius = view.bounds.width/16
        }
        skipButtton.setTitle("Выйти", for: .normal)
        skipButtton.tintColor = .lightGray
        skipButtton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        skipButtton.widthAnchor.constraint(equalToConstant: view.bounds.width/4).isActive = true
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.tintColor = UIColor.AppColors.mainColor
        saveButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width/3).isActive = true
        saveButton.isHidden = true
        
        view.addSubview(iconLabel)
        iconLabel.textAlignment = .left
        iconLabel.text = "Выберите аватар"
        iconLabel.textColor = UIColor.AppColors.mainColor
        iconLabel.font = UIFont.boldSystemFont(ofSize: view.frame.size.width/12)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconLabel.topAnchor.constraint(equalTo: skipButtton.bottomAnchor, constant: UIConstants.padding).isActive = true
        iconLabel.heightAnchor.constraint(equalToConstant: view.frame.size.width/10).isActive = true
        
        view.addSubview(iconImage)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.backgroundColor = .lightGray
        iconImage.tintColor = .white
        iconImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconImage.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: UIConstants.padding).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        iconImage.heightAnchor.constraint(equalTo: iconImage.widthAnchor).isActive = true
        iconImage.layer.cornerRadius = view.bounds.width / 4
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.AppColors.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        collectionView.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: UIConstants.collectionTopPadding).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.padding).isActive = true
    }
    
    private func accessToPhotos() {
        PHPhotoLibrary.requestAuthorization  { [weak self] status in
            if status == .authorized {
                let asset = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                asset.enumerateObjects { (object, _, _) in
                    self?.images.append(object)
                }
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func presentFeed() {
        let feedController = FeedController()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.pushViewController(feedController, animated: true)
    }
    
    private func saveImage() {
        guard let data = iconImage.image?.jpegData(compressionQuality: 1.0) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        UserDefaults.standard.set(encoded, forKey: "accountImage")
    }
    
    private func loadImage() {
        guard let data = UserDefaults.standard.data(forKey: "accountImage") else { return }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        accountImage = UIImage(data: decoded) ?? UIImage(named: "")!
        iconImage.image = accountImage
        iconImage.contentMode = .scaleAspectFill
        iconImage.clipsToBounds = true
    }
    
    private func feedIsShown() -> Bool {
        return UserDefaults.standard.bool(forKey: "feedIsShown")
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        if sender.tag == 0 && feedIsShown() {
            goBack()
        } else if sender.tag == 1 && feedIsShown() {
            saveImage()
            goBack()
        } else if sender.tag == 1 {
            saveImage()
            presentFeed()
        } else {
            presentFeed()
        }
    }
    
    @objc private func imageTapped(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(dismissFullScreenImage))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        newImageView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissFullScreenImage))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        newImageView.addGestureRecognizer(swipeDown)
        
        UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: { self.view.addSubview(newImageView) }, completion: nil)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func dismissFullScreenImage(_ sender: UISwipeGestureRecognizer) {
        let swipeGesture = sender
        switch swipeGesture.direction {
        case .down:
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
            UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: {sender.view?.removeFromSuperview() }, completion: nil)
        case .up:
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
            UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: {sender.view?.removeFromSuperview() }, completion: nil)
        default:
            break
        }
    }
}

extension PhotosController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as? PhotosCell else { return .init() }
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: view.bounds.width, height: view.bounds.width), contentMode: .aspectFill, options: nil) {
            image, _ in
            DispatchQueue.main.async {
                cell.fillPhotosData(images: image ?? UIImage(named: "")!)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        saveButton.isHidden = false
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: view.bounds.width, height: view.bounds.width), contentMode: .aspectFill, options: nil) {
            image, _ in
            DispatchQueue.main.async {
                self.iconImage.image = image
                self.iconImage.contentMode = .scaleAspectFill
                self.iconImage.clipsToBounds = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


