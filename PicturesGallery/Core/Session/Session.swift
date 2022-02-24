//
//  Session.swift
//  PicturesGallery
//
//  Created by Крылов Данила  on 21.02.2022.
//

import Foundation

final class Session {

    static let shared = Session()

    var page = 1
    
    private init() {}

    public func pageParam() -> String {
        return String(page)
    }
}
