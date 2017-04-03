//
//  BaseRepository.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift

class BaseRepository {
    
    open func handleError<R>(_ request:() -> Observable<R>) -> Observable<R> {
        return request().catchError { error in
            if let requestError = error as? RequestError {
                switch (requestError) {
                case .connectionError:
                    throw CommonServiceError.connectionMissing
                case .requestClientError(let statusCode, let response) where statusCode == 403:
                    if let limitRemainingStr = response.allHeaderFields["X-RateLimit-Remaining"] as? String,
                        let limitRemaining = Int(limitRemainingStr),
                        limitRemaining == 0
                    {
                        if let limitResetTsStr = response.allHeaderFields["X-RateLimit-Reset"] as? String,
                            let limitResetTs = Int(limitResetTsStr) {
                            
                            let d = Date(timeIntervalSince1970: TimeInterval(limitResetTs))
                            throw CommonServiceError.limitExceeded(until: d)
                        }
                        
                        throw CommonServiceError.limitExceeded(until: nil)
                    }
                default:
                    break
                }
            }
            
            throw error
        }
    }
}

enum CommonServiceError: Error {
    case limitExceeded(until:Date?)
    case connectionMissing
}

