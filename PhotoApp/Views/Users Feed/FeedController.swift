//
//  FeedController.swift
//  PhotoApp
//
//  Created by Данил Швец on 06.04.2022.
//

import UIKit
import Photos

final class FeedController: UIViewController {
    
    private struct UIConstants {
        static let fontSize: CGFloat = 20
        static let topPadding: CGFloat = 5
        static let padding: CGFloat = 20
        static let collectionTopPadding: CGFloat = 25
    }
    
    private lazy var images = [PHAsset]()
    private var accountImage: UIImage!
    private let defaults = UserDefaults.standard
    private lazy var iconChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .lightGray
        button.tag = 0
        return button
    }()
    private let feedLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let safeAreaInsets = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets
        let leftPadding = safeAreaInsets?.left ?? 0
        let rightPadding = safeAreaInsets?.right ?? 0
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        let sizeCell = CGSize(width: view.bounds.width - leftPadding - rightPadding - UIConstants.padding, height: 70)
        layout.itemSize = sizeCell
        layout.scrollDirection = .vertical
        layout.collectionView?.indicatorStyle = .black
        collection.delegate = self
        collection.dataSource = self
        collection.register(FeedCell.self, forCellWithReuseIdentifier: "FeedCell")
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedIsShown()
        loadImage()
        configureUI()
        accessToPhotos()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        feedIsShown()
        loadImage()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.AppColors.backgroundColor
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.addSubview(iconChangeButton)
        iconChangeButton.translatesAutoresizingMaskIntoConstraints = false
        iconChangeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.topPadding).isActive = true
        iconChangeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        iconChangeButton.widthAnchor.constraint(equalToConstant: view.bounds.width/8).isActive = true
        iconChangeButton.heightAnchor.constraint(equalToConstant: view.bounds.width/8).isActive = true
        iconChangeButton.layer.cornerRadius = view.bounds.width/16
        iconChangeButton.clipsToBounds = true
        
        view.addSubview(feedLabel)
        feedLabel.textAlignment = .left
        feedLabel.text = "Пользователи"
        feedLabel.textColor = UIColor.AppColors.mainColor
        feedLabel.font = UIFont.boldSystemFont(ofSize: view.frame.size.width/12)
        feedLabel.translatesAutoresizingMaskIntoConstraints = false
        feedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        feedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.topPadding).isActive = true
        feedLabel.heightAnchor.constraint(equalToConstant: view.bounds.width/8).isActive = true
        
        view.addSubview(logOutButton)
        logOutButton.setImage(UIImage(systemName: "person.crop.circle.badge.xmark"), for: .normal)
        logOutButton.tintColor = UIColor.AppColors.mainColor
        logOutButton.titleLabel?.font =  UIFont.systemFont(ofSize: UIConstants.fontSize)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.topPadding).isActive = true
        logOutButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: view.bounds.width/6).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: view.bounds.width/8).isActive = true
        logOutButton.layer.cornerRadius = view.bounds.width/5
        
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.AppColors.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: iconChangeButton.bottomAnchor, constant: UIConstants.padding).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.padding/2).isActive = true
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
    
    private func loadImage() {
        guard let data = UserDefaults.standard.data(forKey: "accountImage") else { return }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        accountImage = UIImage(data: decoded) ?? UIImage(named: "")!
        iconChangeButton.setImage(accountImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        iconChangeButton.imageView?.contentMode = .scaleAspectFill
        iconChangeButton.imageView?.clipsToBounds = true
    }
    
    private func deletePhotoFromMemory() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "accountImage")
        defaults.synchronize()
    }
    
    private func presentPhotos() {
        let photosController = PhotosController()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.pushViewController(photosController, animated: true)
    }
    
    private func presentLogIn() {
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        UserDefaults.standard.set(false, forKey: "feedIsShown")
        UserDefaults.standard.synchronize()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.pushViewController(LogInController(), animated: true)
    }
    
    private func feedIsShown() {
        UserDefaults.standard.set(true, forKey: "feedIsShown")
        UserDefaults.standard.synchronize()
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            presentPhotos()
        } else {
            deletePhotoFromMemory()
            presentLogIn()
        }
    }
}

extension FeedController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCell else { return .init() }
        let asset = self.images[Int(arc4random_uniform(UInt32(images.count)))]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: view.bounds.width, height: view.bounds.width), contentMode: .aspectFill, options: nil) {
            image, _ in
            DispatchQueue.main.async {
                cell.fillCellData(images: image ?? UIImage(systemName: "photo")!)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor(red: 0.97, green: 0.91, blue: 0.84, alpha: 0.5)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = nil
        }
    }
}
