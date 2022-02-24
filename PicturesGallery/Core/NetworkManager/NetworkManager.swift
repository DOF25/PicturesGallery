//
//  NetworkManager.swift
//  PicturesGallery
//
//  Created by Крылов Данила  on 17.02.2022.
//

/// L7hDCfdpdseyXb_iQq8K9eTuo-biZ1bztM-pgINXfgQ ---- token

import Foundation

final class NetworkManager {

    typealias Completion = (Result<[Photo], Error>) -> Void
    //MARK: - Properties
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private let session = URLSession.shared

    //MARK: - Public Methods
    public func getPhotos(_ url: String, completion: @escaping Completion) {

        guard let url = URL(string: url) else {
            completion(.success([]))
            return }
            self.session.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else {
                    completion(.success([]))
                    return
                }
                if let error = error {
                    completion(.failure(error))
                }
                guard let data = data else { return }
                do {
                    let result = try self.decoder.decode([Photo].self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }.resume()
    }
}
