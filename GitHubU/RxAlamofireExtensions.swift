//
//  RxAlamofireExtensions.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import Alamofire
import RxSwift

extension Reactive where Base: SessionManager {
    func responseString(urlRequestConvertible:URLRequestConvertible) -> Observable<(HTTPURLResponse, String)> {
        return request { manager in
            return manager.request(urlRequestConvertible)
        }.flatMap { $0.rx.responseString(encoding: .utf8) }
    }
}

