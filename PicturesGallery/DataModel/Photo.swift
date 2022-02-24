//
//  Photo.swift
//  PicturesGallery
//
//  Created by Крылов Данила  on 18.02.2022.
//

import Foundation

struct Photo: Decodable {
    let creationDate: Date
    let description: String?
    let height: Int
    let width: Int
    let id: String
    let urls: PhotoURL
    let authorsName: userName

    enum CodingKeys: String, CodingKey {
        case creationDate = "created_at"
        case description = "description"
        case height = "height"
        case width = "width"
        case id = "id"
        case urls = "urls"
        case authorsName = "user"
    }
}

struct PhotoURL: Decodable {
    let regular: String

    enum CodingKeys: String, CodingKey {
        case regular = "regular"
    }
}

struct userName: Decodable {
    let name: String
}

