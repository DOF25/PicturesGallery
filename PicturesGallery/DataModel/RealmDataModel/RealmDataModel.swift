//
//  RealmDataModel.swift
//  PicturesGallery
//
//  Created by Крылов Данила  on 23.02.2022.
//

import Foundation
import RealmSwift

class RealmPhoto: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var image: Data = Data()
    @objc dynamic var creationDate = Date()
    @objc dynamic var authorsName = ""

    convenience init(id: String,
                     image: Data,
                     creationDate: Date,
                     authorsName: String) {
        self.init()

        self.id = id
        self.image = image
        self.creationDate = creationDate
        self.authorsName = authorsName
    }
}
