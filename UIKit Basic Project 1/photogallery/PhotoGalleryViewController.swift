//
//  PhotoGalleryViewController.swift
//  UIKit Basic Project 1
//
//  Created by Asal Macbook 1 on 18/05/2020.
//  Copyright © 2020 Mustafa Birat. All rights reserved.
//

import UIKit

class PhotoGalleryViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var albums: [Int: [Photo]]  = [:] {
        didSet {
            collectionView.reloadData()
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.frame = view.bounds
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        initPhotosRequest()
    }
    
    func initPhotosRequest() {
        let photosRequest = PhotosRequest()
        photosRequest.getPhotos() { [weak self] response in
            switch response {
            case .failure(let error):
                print(error)
            case .success(let albums):
                self?.albums = albums
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}



extension PhotoGalleryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return albums.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums[section + 1]?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell
        guard let album = albums[indexPath.section + 1] else {return UICollectionViewCell()}
        cell?.loadImage(album[indexPath.item].thumbnailUrl)
        return cell ?? UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let albumHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "albumHeader", for: indexPath) as? AlbumHeader
        
        albumHeader?.albumIdText = "\(indexPath.section + 1)"
        return albumHeader ?? AlbumHeader()
    }
    
}

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { 
        let width = floor((self.collectionView.frame.width - 16.0 * 3) / 2)
        return CGSize(width: width, height: width)
    }
}


extension PhotoGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let album = albums[indexPath.section + 1] else {return}
        let vc = storyboard?.instantiateViewController(withIdentifier: "fullScreen") as? FullScreenPhotoViewController
        vc?.imageURL = album[indexPath.item].url
        vc?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        guard let fullScreenViewController = vc else {return}
        self.present(fullScreenViewController, animated: true)
    }
}


