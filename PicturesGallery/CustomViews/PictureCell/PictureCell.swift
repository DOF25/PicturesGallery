//
//  PictureCell.swift
//  PicturesGallery
//
//  Created by Крылов Данила  on 17.02.2022.
//

import UIKit

final class PictureCell: UICollectionViewCell {

    //MARK: - Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    private let authorsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Authors Name"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.clipsToBounds = true
        label.adjustsFontSizeToFitWidth = true
        label.setContentCompressionResistancePriority(UILayoutPriority(751),
                                                      for: .vertical)
        return label
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        self.authorsLabel.text = nil
        self.imageView.image = nil
    }
    //MARK: - Private Methods
    private func setupConstraints() {
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(authorsLabel)
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.authorsLabel.topAnchor, constant: -8),
            self.authorsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            self.authorsLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.authorsLabel.widthAnchor.constraint(equalToConstant: self.contentView.bounds.width - 4)
        ])
    }

    private func downloadPicture(with urlString: String, completion: @escaping(Data) -> Void) {
        ImageDownloader.shared.downloadImage(with: urlString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                let image = UIImage(data: data, scale: 1.0)
                completion(data)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    private func configurePhotoForCell(photo: Photo) {
        let imageData = RealmManager.shared.extractPhotoFromRealm(for: photo)
        if imageData == nil {
            downloadPicture(with: photo.urls.regular) { data in
                RealmManager.shared.safePhotoToRealm(for: photo.id, data)
            }
        } else {
            guard let imageData = imageData else { return }
            self.imageView.image = UIImage(data: imageData, scale: 1.0)
        }
    }
    //MARK: - Public methods
    public func configure(photo: Photo) {
        configurePhotoForCell(photo: photo)
        self.authorsLabel.text = "Автор: \(photo.authorsName.name)"
    }
}
