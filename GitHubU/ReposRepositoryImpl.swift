//
//  ReposRepositoryImpl.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift

class ReposRepositoryImpl: BaseRepository, ReposRepository {
    let reposApi:ReposApi
    
    init(apiFactory:ApiFactory) {
        reposApi = apiFactory.reposApi
        super.init()
    }
    
    func repos(forUserLogin login:String) -> Observable<[Repo]> {
        return handleError {
            reposApi.repos(ofUserWith: login)
                .map { dto in
                    dto.toArray()
            }
        }
    }
}

