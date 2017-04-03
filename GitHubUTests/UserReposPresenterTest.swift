//
//  UserReposPresenterTest.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import XCTest
import Cuckoo
import RxSwift
import RxTest

@testable import GitHubU

class UserReposPresenterTest: XCTestCase {
    
    let userLogin = "octocat"
    let user = User(
        id: 1,
        login: "octocat",
        name: "Octocat",
        avatarUrl: "http://example.com/img/octocat.png",
        company: "GitHub",
        location: "San Francisco",
        bio: "Social coding",
        email: "octocat@github.com",
        blog: "https://github.com/blog",
        following: 2,
        publicRepos: 3,
        followers: 4)
    let repo = Repo(
        id: 10,
        name: "oc-repo",
        desc: "Description",
        lang: "Kotlin",
        seen: 2,
        stars: 3,
        forks: 4,
        htmlUrl: "https://github.com/octocat/oc-repo")
    
    var cp:MockComponentProvider!
    var view:MockUserReposView!
    var usersRepository:MockUsersRepository!
    var reposRepository:MockReposRepository!
    
    var testScheduler:TestScheduler!
    
    var presenter:UserReposPresenter!
    
    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        
        view = MockUserReposView()
        stub(view) { stub in
            when(stub.showReposLoading()).thenDoNothing()
            when(stub.dismissReposLoading()).thenDoNothing()
            when(stub.showUser(user: any())).thenDoNothing()
            when(stub.showRepos(repos: any())).thenDoNothing()
        }
        
        usersRepository = MockUsersRepository()
        reposRepository = MockReposRepository()
        
        cp = MockComponentProvider()
        stub(cp) { stub in
            when(stub.usersRepository.get).thenReturn(usersRepository)
            when(stub.reposRepository.get).thenReturn(reposRepository)
        }
        
        presenter = UserReposPresenter(view: view, cp: cp)
    }
    
    override func tearDown() {
        presenter.viewWillDisappear()
        super.tearDown()
    }
    
    func test_user_loaded() {
        let repos:[Repo] = [repo]
        let userObservable = testScheduler.createHotObservable([next(100, user)])
        let reposObservable = testScheduler.createHotObservable([next(100, repos)])
        
        stub(usersRepository) { stub in
            when(stub.userBy(login: self.userLogin)).thenReturn(userObservable.asObservable())
        }
        stub(reposRepository) { stub in
            when(stub.repos(forUserLogin: self.userLogin)).thenReturn(reposObservable.asObservable())
        }
        
        presenter.userLogin = userLogin
        presenter.viewWillAppear()

        let expectedUserView = UserView(
            name: "Octocat",
            avatarUrl: "http://example.com/img/octocat.png",
            followersCount: "4",
            followingCount: "2",
            companyAndLocation: "GitHub,\nSan Francisco")
        testScheduler.start()
        
        verify(view).showUser(user: equal(to: expectedUserView))
        verify(view).showRepos(repos: equal(to: repos))
    }
}

