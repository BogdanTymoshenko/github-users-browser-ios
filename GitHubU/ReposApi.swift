//
//  ReposApi.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift

protocol ReposApi {
    func repos(ofUserWith login:String) -> Observable<ApiResponseDtoArray<Repo>>
}

class ReposApiImpl: ReposApi {
    let client:RestApiClient
    
    init(client:RestApiClient) {
        self.client = client
    }
    
    func repos(ofUserWith login:String) -> Observable<ApiResponseDtoArray<Repo>> {
        return client.request(
            method: .get,
            path: "users/\(login)/repos"
        )
    }
}
