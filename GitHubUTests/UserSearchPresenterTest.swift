//
//  GitHubUTests.swift
//  GitHubUTests
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import XCTest
import Cuckoo
import RxSwift
import RxTest

@testable import GitHubU

class UserSearchPresenterTest: XCTestCase {
    
    let query = "octocat"
    
    var cp:MockComponentProvider!
    var view:MockUserSearchView!
    var repository:MockUsersRepository!
    
    var testScheduler:TestScheduler!
    
    var presenter:UserSearchPresenter!
    
    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        
        let queryTextChange = testScheduler.createHotObservable([next(100, SearchQueryEvent(query: query))])
        
        view = MockUserSearchView()
        stub(view) { stub in
            when(stub.queryTextChangeEvents.get).thenReturn(queryTextChange.asObservable())
            when(stub.showLoading()).thenDoNothing()
            when(stub.dismissLoading()).thenDoNothing()
            when(stub.showUsers(users: any())).thenDoNothing()
        }
        
        repository = MockUsersRepository()
        
        cp = MockComponentProvider()
        stub(cp) { stub in
            when(stub.usersRepository.get).thenReturn(repository)
            when(stub.mainScheduler.get).thenReturn(testScheduler)
        }
        
        presenter = UserSearchPresenter(view: view, cp: cp)
    }
    
    override func tearDown() {
        presenter.viewWillDisappear()
        super.tearDown()
    }
    
    func test_searchUsers_empty() {
        stub(repository) { stub in
            when(stub.search(query: self.query)).thenReturn(Observable.just([UserShort]()))
        }
        
        presenter.viewWillAppear()
        testScheduler.start()
        verify(view).showUsers(users: emptyList())
    }
    
    func test_searchUsers_found() {
        let user = UserShort(id:1, login:"octocat", avatarUrl:"http://example.com/img/octocat.png")
        let users:[UserShort] = [user]
        stub(repository) { stub in
            when(stub.search(query: self.query)).thenReturn(Observable.just([user]))
        }
        
        presenter.viewWillAppear()
        testScheduler.start()
        verify(view).showUsers(users: equal(to: users))
    }
}
