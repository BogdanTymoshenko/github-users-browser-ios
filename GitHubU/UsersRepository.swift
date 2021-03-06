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

fileprivate extension String {
    func buildUsersSearchQuery() -> String {
        return "\(self)+in:login,fullname"
    }
}
