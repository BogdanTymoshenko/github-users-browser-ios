//
//  UserReposPresenter.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift

class UserReposPresenter {
    let view:UserReposView
    let usersRepository:UsersRepository
    let reposRepository:ReposRepository
    var userLogin:String!
    
    var loadedRepos = [Repo]()
    var disposeBag = DisposeBag()
    
    init(view:UserReposView, cp:ComponentProvider) {
        self.view = view
        self.usersRepository = cp.usersRepository
        self.reposRepository = cp.reposRepository
    }
    
    func viewWillAppear() {
        usersRepository.userBy(login: userLogin)
            .map { repos -> User? in repos }
            .catchError { error in
                self.view.showError(error: error)
                return Observable.just(nil)
            }
            .filter { $0 != nil }.map { $0! }
            .subscribe(onNext: { user in
                self.view.showUser(user: user.toUserView())
            }, onError: { error in
                self.view.showError(error: error)
            })
            .addDisposableTo(disposeBag)
        
        
        
        view.showReposLoading()
        reposRepository.repos(forUserLogin: userLogin)
            .map { repos -> [Repo]? in repos }
            .catchError { error in
                self.view.showError(error: error)
                return Observable.just(nil)
            }
            .do(onNext: { _ in
                self.view.dismissReposLoading()
            })
            .filter { $0 != nil }.map { $0! }
            .subscribe(onNext: { repos in
                self.loadedRepos.removeAll()
                self.loadedRepos.append(contentsOf: repos)
                self.view.showRepos(repos: self.loadedRepos)
            }, onError: { error in
                self.view.showError(error: error)
            })
            .addDisposableTo(disposeBag)
    }
    
    func viewWillDisappear() {
        disposeBag = DisposeBag()
    }
    
    func onRepoSelected(atPosition pos: Int) {
        view.showRepoView(repo: loadedRepos[pos])
    }
}
