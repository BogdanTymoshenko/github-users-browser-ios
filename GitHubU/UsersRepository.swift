//
//  UsersRepository.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift

protocol UsersRepository {
    func search(query:String) -> Observable<[UserShort]>
    func userBy(login:String) -> Observable<User>
}

class UsersRepositoryImpl: BaseRepository, UsersRepository {
    let usersApi:UsersApi
    let searchApi:SearchApi
    
    init(apiFactory:ApiFactory) {
        usersApi = apiFactory.usersApi
        searchApi = apiFactory.searchApi
        super.init()
    }
    
    func search(query:String) -> Observable<[UserShort]> {
        return handleError {
            searchApi.users(query: query.buildUsersSearchQuery(), type: "User")
                .map { dto in
                    dto.users
                }
        }
    }
    
    func userBy(login:String) -> Observable<User> {
        return handleError {
            usersApi.user(by: login)
        }
    }
}

fileprivate extension String {
    func buildUsersSearchQuery() -> String {
        return "\(self)+in:login,fullname"
    }
}
