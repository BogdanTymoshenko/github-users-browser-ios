//
//  UserSearchPresenter.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift

class UserSearchPresenter {
    let view:UserSearchView
    let repository:UsersRepository
    var lastQuery:String = ""
    var loadedUsers = [UserShort]()
    
    private var disposeBag = DisposeBag()
    
    init(view:UserSearchView, cp:ComponentProvider) {
        self.view = view
        self.repository = cp.usersRepository
    }
    
    func viewWillAppear() {
        view.queryTextChangeEvents
            .map { event in
                event.query.trim().lowercased()
            }
            .filter { query in
                !query.isEmpty
            }
            .debounce(1.250, scheduler: MainScheduler.instance)
            .filter { query in
                query != self.lastQuery
            }
            .do(onNext: { query in
                self.lastQuery = query
                self.view.showLoading()
            })
            .flatMap { query in
                return self.repository.search(query: query)
                    .map { users -> [UserShort]? in
                        users
                    }
                    .catchError { error in
                        self.view.showError(error: error)
                        return Observable.just(nil)
                }
            }
            .do(onNext: { _ in
                self.view.dismissLoading()
            })
            .filter { $0 != nil }.map { $0! }
            .subscribe(onNext: { users in
                self.loadedUsers.removeAll()
                self.loadedUsers.append(contentsOf: users)
                self.view.showUsers(users: self.loadedUsers)
            }, onError: { error in
                self.view.showError(error: error)
            })
            .addDisposableTo(disposeBag)
    }
    
    func viewWillDisappear() {
        disposeBag = DisposeBag()
    }
    
    func onUserSelected(atPosition pos: Int) {
        view.showUserRepos(user: loadedUsers[pos])
    }
}
