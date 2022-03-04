//
//  URLs.swift
//  PicturesGallery
//
//  Created by Крылов Данила  on 21.02.2022.
//

import Foundation

public enum URLs {
    static let startUrl: String = "https://api.unsplash.com/photos/?client_id=L7hDCfdpdseyXb_iQq8K9eTuo-biZ1bztM-pgINXfgQ&page=1&per_page=100"
    static let prefetchUrl: String = "https://api.unsplash.com/photos/?client_id=L7hDCfdpdseyXb_iQq8K9eTuo-biZ1bztM-pgINXfgQ&page=\(Session.shared.pageParam())&per_page=30"
}
