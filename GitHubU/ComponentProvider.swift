//
//  ComponentProvider.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift

protocol ComponentProvider {
    var usersRepository:UsersRepository { get }
    var reposRepository:ReposRepository { get }
    
    var mainScheduler:SchedulerType { get }
}
