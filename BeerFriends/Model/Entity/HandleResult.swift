//
//  Result.swift
//  BeerFriends
//
//  Created by Wesley Marra on 23/12/21.
//

import Foundation

struct HandleResult<T> {
    var success: String?
    var error: Error?
    var data: T?
}
