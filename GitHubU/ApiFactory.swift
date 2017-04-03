//
//  ApiFactory.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

protocol ApiFactory {
    var searchApi:SearchApi { get }
    var usersApi:UsersApi { get }
    var reposApi:ReposApi { get }
}
