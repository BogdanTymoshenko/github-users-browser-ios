//
//  URLRequestExtention.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import Alamofire

extension URLRequest {
    mutating func appendQueryParams(params:[String:Any]) {
        if let URLComponents = NSURLComponents(url: self.url!, resolvingAgainstBaseURL: false), !params.isEmpty {
            let percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters: params)
            URLComponents.percentEncodedQuery = percentEncodedQuery
            self.url = URLComponents.url
        }
    }
    
    func query(parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        let encoder = URLEncoding()
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            if let value = value as? UnencodableString {
                components += [(key, value.value)]
            }
            else {
                components += encoder.queryComponents(fromKey: key, value: value)
            }
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
    }
}

struct UnencodableString {
    let value:String
}
