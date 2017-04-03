//
//  SearchApi.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift
import SwiftyJSON

protocol SearchApi {
    func users(query: String, type: String) -> Observable<UserSearchResultDto>
}

class SearchApiImpl: SearchApi {
    let client:RestApiClient
    
    init(client:RestApiClient) {
        self.client = client
    }
    
    func users(query: String, type: String) -> Observable<UserSearchResultDto> {
        return client.request(
            method: .get,
            path: "search/users",
            queryParams:[
                "q": UnencodableString(value:query),
                "type": type
            ]
        )
    }
}
