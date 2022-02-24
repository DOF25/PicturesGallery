//
//  PictureDetailController.swift
//  PicturesGallery
//
//  Created by Крылов Данила  on 18.02.2022.
//

import UIKit

final class PictureDetailController: UIViewController {
    //MARK: - Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.clipsToBounds = true
        label.adjustsFontSizeToFitWidth = true
        label.setContentCompressionResistancePriority(UILayoutPriority(751),
                                                      for: .vertical)
        return label
    }()
    private let photo: Photo
    private let dateFormatter = DateFormatter()
    //MARK: - Life Cycle
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setupDataForViews()
    }
    //MARK: - Private Methods
    private func setConstraints() {
        self.view.addSubview(imageView)
        self.view.addSubview(dateLabel)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: safeArea.topAnchor , constant: 35),
            self.imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor , constant: 0),
            self.imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor , constant: 0),
            self.imageView.bottomAnchor.constraint(equalTo: self.dateLabel.topAnchor, constant: -35),
            self.dateLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            self.dateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    private func setupDataForViews() {
        configureDate()
        loadPhotoFromRealm()
    }
    private func configureDate() {
        dateFormatter.dateStyle = .full
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        let date = dateFormatter.string(from: photo.creationDate)
        dateFormatter.setLocalizedDateFormatFromTemplate(date)
        self.dateLabel.text = "Дата публикации: \(date)"
    }
    private func loadPhotoFromRealm() {
        guard let data = RealmManager.shared.extractPhotoFromRealm(for: photo) else { return }
        let image = UIImage(data: data, scale: 1.0)
        self.imageView.image = image
    }
}
