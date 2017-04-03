//
//  UsersApi.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift

protocol UsersApi {
    func user(by login:String) -> Observable<User>
}

class UsersApiImpl: UsersApi {
    let client:RestApiClient
    
    init(client:RestApiClient) {
        self.client = client
    }
    
    func user(by login:String) -> Observable<User> {
        return client.request(
            method: .get,
            path: "users/\(login)"
        )
    }
}
