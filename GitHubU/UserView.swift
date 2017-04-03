//
//  UserView.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

struct UserView {
    let name:String
    let avatarUrl:String
    let followersCount:String
    let followingCount:String
    let companyAndLocation:String
}

extension User {
    var companyAndLocation:String {
        var companyAndLocation = ""
        if let company = self.company {
            companyAndLocation += company
        }
        
        if let location = self.location {
            if (!companyAndLocation.isEmpty) {
                companyAndLocation += ",\n"
            }
            
            companyAndLocation += location
        }
        
        return companyAndLocation
    }
    
    func toUserView() -> UserView {
        return UserView(
            name: self.name ?? self.login,
            avatarUrl: self.avatarUrl,
            followersCount: String(self.followers),
            followingCount: String(self.following),
            companyAndLocation: self.companyAndLocation
        )
    }
}

