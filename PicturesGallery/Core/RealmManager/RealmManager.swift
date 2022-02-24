//
//  RealmManager.swift
//  PicturesGallery
//
//  Created by Крылов Данила  on 24.02.2022.
//

import Foundation
import RealmSwift

//Использую Рилм, чтобы обеспечить приложение базой данной картинок, которые уже были загружены, чтобы единожды
//загруженные фото хранились в базе и не требовали обращения к классу ImageDownloader

final class RealmManager {
    static let shared = RealmManager()
    private init() {}

    public func safePhotoToRealm(for id: String, _ image: Data) {
        let photo = RealmPhoto(id: id, image: image)
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: false)
        do {
            let realm = try Realm(configuration: configuration)
            try realm.write {
                realm.add(photo)
            }
        } catch {
            print(error)
        }
    }

    public func extractPhotoFromRealm(for photo: Photo) -> Data? {
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: false)
        do {
            let realm = try Realm(configuration: configuration)
            let realmPhotos = realm.objects(RealmPhoto.self)
            let neededPhoto = realmPhotos.first { $0.id == photo.id }?.image
            return neededPhoto
        } catch {
            print(error)
        }
        return nil
    }

    public func deleteData() {
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: false)
        do {
            let realm = try Realm(configuration: configuration)
            let photos = realm.objects(RealmPhoto.self)
            try realm.write {
                realm.delete(photos)
            }
        } catch {
            print(error)
        }
    }
}
