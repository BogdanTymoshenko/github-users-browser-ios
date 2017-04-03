//
//  ReposApi.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift

protocol ReposApi {
    func repos(ofUserWith login:String) -> Observable<[Repo]>
}

class ReposApiImpl: ReposApi {
    init(client:RestApiClient) {
        
    }
    
    func repos(ofUserWith login:String) -> Observable<[Repo]> {
        return Observable.empty()
    }
}
