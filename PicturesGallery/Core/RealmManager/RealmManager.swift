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

    public func safePhotoToRealm(photo: Photo, with data: Data) {
        let photo = RealmPhoto(id: photo.id,
                               image: data,
                               creationDate: photo.creationDate,
                               authorsName: photo.authorsName.name)
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
            do {
                let realm = try Realm(configuration: configuration)
                try realm.write {
                    realm.add(photo)
                }
                print(realm.configuration.fileURL)
            } catch {
                print(error)
            }
    }

    public func extractPhotoFromRealm(for photo: Photo) -> RealmPhoto? {
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: configuration)
            let realmPhotos = realm.objects(RealmPhoto.self)
            let neededPhoto = realmPhotos.first { $0.id == photo.id }
            return neededPhoto
        } catch {
            print(error)
        }
        return nil
    }

    public func deleteData() {
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
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
