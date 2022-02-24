//
//  PicturesController.swift
//  PicturesGallery
//
//  Created by Крылов Данила  on 17.02.2022.
//

import UIKit

class PicturesController: UIViewController {

    //MARK: - Properties
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    private let cellId = "CellId"

    private let networkManager = NetworkManager()
    private var photos = [Photo]()

    private var isLoading = false

    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Галерея"
        setupConstraints()
        setupCollectionView()
        RealmManager.shared.deleteData()
        fetchPhotos()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.alpha = 1
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animateCollectionViewDissapearing()
    }

    //MARK: - Private methods
    private func animateCollectionViewDissapearing() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.collectionView.alpha = 0
        }
    }
    private func setupCollectionView() {
        self.collectionView.register(PictureCell.self, forCellWithReuseIdentifier: self.cellId)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.prefetchDataSource = self

        self.collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.collectionView.contentInsetAdjustmentBehavior = .automatic
    }
    private func setupConstraints() {
        self.view.addSubview(collectionView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    private func fetchPhotos() {
        networkManager.getPhotos(URLs.startUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let photos):
                self.photos = photos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension PicturesController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as?
                PictureCell else { return UICollectionViewCell() }
        cell.configure(photo: photos[indexPath.row])
        return cell
    }


}
//MARK: - UICollectionViewDelegateFlowLayout
extension PicturesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: view.bounds.height/4.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
//MARK: - UICollectionViewDelegate
extension PicturesController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let pictureDetailController = PictureDetailController(photo: photo)
        navigationController?.pushViewController(pictureDetailController, animated: true)
    }
}
//MARK: - UICollectionViewDataSourcePrefetching
extension PicturesController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({ $0.row }).max() else { return }
        var indexPathArray = [IndexPath]()
        if maxRow > photos.count - 20,
           !isLoading {
            isLoading = true
            Session.shared.page += 1
            networkManager.getPhotos(URLs.prefetchUrl) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let photos):
                    for index in 0..<photos.count {
                        let newIndexPath = IndexPath(row: (index + 1) + (self.photos.count - 1), section: 0)
                        indexPathArray.append(newIndexPath)
                    }
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: photos)
                        self.collectionView.insertItems(at: indexPathArray)
                        self .isLoading = false
                    }
                }
            }
        }
    }


}

