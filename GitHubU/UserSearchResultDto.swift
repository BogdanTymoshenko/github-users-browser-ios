//
//  UserSearchResultDto.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import SwiftyJSON

struct UserSearchResultDto {
    let users:[UserShort]
}

extension UserSearchResultDto: ApiResponseDto {
    init(json: JSON) throws {
        if let itemsJson = json["items"].array {
            users = try itemsJson.map { itemJson in
                try UserShort(json: itemJson)
            }
        }
        else {
            users = []
        }
    }
}
