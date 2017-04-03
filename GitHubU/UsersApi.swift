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
    init(client:RestApiClient) {
        
    }
    
    func user(by login:String) -> Observable<User> {
        return Observable.empty()
    }
}
