//
//  Repo.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import SwiftyJSON

struct Repo {
    let id:Int
    let name:String
    let desc:String?
    let lang:String?
    let seen:Int
    let stars:Int
    let forks:Int
    let htmlUrl:String
}

extension Repo: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
    
    static func == (lhs: Repo, rhs: Repo) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.name == rhs.name &&
            lhs.desc == rhs.desc &&
            lhs.lang == rhs.lang &&
            lhs.seen == rhs.seen &&
            lhs.stars == rhs.stars &&
            lhs.forks == rhs.forks &&
            lhs.htmlUrl == rhs.htmlUrl
    }
}


extension Repo: ApiResponseDto {
    init(json: JSON) throws {
        id = json["id"].intValue
        name = json["name"].stringValue
        desc = json["description"].string
        lang = json["language"].string
        seen = json["watchers_count"].intValue
        stars = json["stargazers_count"].intValue
        forks = json["forks_count"].intValue
        htmlUrl = json["html_url"].stringValue
    }
}
