//
//  ImageDownloader.swift
//  PicturesGallery
//
//  Created by Крылов Данила  on 18.02.2022.
//

import UIKit

final class ImageDownloader {
    //Singleton
    static let shared = ImageDownloader()
    
    private init() {}

    public func downloadImage(with urlString: String, completion: @escaping(Result<Data, Error>) -> Void) {

        guard let url = URL(string: urlString) else { return }

        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else { return }
            completion(.success(data))

        }.resume()
    }
}
