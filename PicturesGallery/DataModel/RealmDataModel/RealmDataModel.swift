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

    convenience init(id: String, image: Data) {
        self.init()
        
        self.id = id
        self.image = image
    }
}
