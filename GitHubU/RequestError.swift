//
//  RequestError.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case requestPrepareError(cause:Error)
    case requestClientError(statusCode:Int, response:HTTPURLResponse)
    case requestServerError(statusCode:Int, response:HTTPURLResponse)
    case requestUnknownError(statusCode:Int, response:HTTPURLResponse)
    case connectionError(cause:Error)
    case unknownError(cause:Error)
}

