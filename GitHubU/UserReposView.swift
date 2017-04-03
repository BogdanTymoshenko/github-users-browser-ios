//
//  UserReposView.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

protocol UserReposView {
    func showUser(user:UserView)
    func showRepos(repos:[Repo])
    func showRepoView(repo: Repo)
    
    func showReposLoading()
    func dismissReposLoading()
    func showError(error:Error)
}
