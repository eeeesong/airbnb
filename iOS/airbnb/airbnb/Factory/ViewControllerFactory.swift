//
//  ViewControllerFactory.swift
//  airbnb
//
//  Created by Song on 2021/05/20.
//

import UIKit

struct ViewControllerFactory {
    static func create<T: UIViewController & Instantiable>(from storyBoard: UIStoryboard, type: T.Type) -> T {
        let id = type.reuseIdentifier
        return storyBoard.instantiateViewController(withIdentifier: id) as? T ?? T()
    }
}