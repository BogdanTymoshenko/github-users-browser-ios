//
//  UserShort.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import SwiftyJSON

struct UserShort {
    let id:Int
    let login:String
    let avatarUrl:String
}

extension UserShort: ApiResponseDto {
    init(json: JSON) throws {
        id = json["id"].intValue
        login = json["login"].stringValue
        avatarUrl = json["avatar_url"].stringValue
    }
}


struct User {
    let id:Int
    let login:String
    let name:String?
    let avatarUrl:String
    let company:String?
    let location:String?
    let bio:String?
    let email:String?
    let blog:String?
    let following:Int
    let publicRepos:Int
    let followers:Int
}

extension User: ApiResponseDto {
    init(json: JSON) throws {
        id = json["id"].intValue
        login = json["login"].stringValue
        name = json["name"].string
        avatarUrl = json["avatar_url"].stringValue
        company = json["company"].string
        location = json["location"].string
        bio = json["bio"].string
        email = json["email"].string
        blog = json["blog"].string
        following = json["following"].intValue
        publicRepos = json["public_repos"].intValue
        followers = json["followers"].intValue
    }
}
