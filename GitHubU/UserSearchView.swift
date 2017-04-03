//
//  UserSearchView.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift

protocol UserSearchView {
    var queryTextChangeEvents: Observable<SearchQueryEvent> { get }
    func showUsers(users: [UserShort])
    
    func showUserRepos(user:UserShort)
    
    func showLoading()
    func dismissLoading()
    func showError(error: Error)
}

struct SearchQueryEvent {
    let query:String
}

