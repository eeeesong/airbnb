//
//  SearchConditionHandleModel.swift
//  airbnb
//
//  Created by Song on 2021/05/30.
//

import Foundation

protocol SearchConditionHandleModel {
    associatedtype DataToPresent
    typealias DataHandler = (DataToPresent) -> Void
    typealias ConditionHandler = ([String]) -> Void
    var conditionManager: ConditionManager { get }
    func bind(dataHandler: @escaping DataHandler, conditionHandler: @escaping ConditionHandler)
}
