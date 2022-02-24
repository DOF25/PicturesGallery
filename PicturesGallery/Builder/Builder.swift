//
//  Builder.swift
//  PicturesGallery
//
//  Created by Крылов Данила  on 18.02.2022.
//

import UIKit

final class Builder {

    static func createPictureController() -> UINavigationController {
        let vc = PicturesController()
        let navVC = UINavigationController(rootViewController: vc)
        return navVC
    }
}
