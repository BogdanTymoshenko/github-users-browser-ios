//
//  RestApiClient.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import Alamofire
import RxSwift
import SwiftyJSON

class RestApiClient {
    let manager:SessionManager
    let baseApiUrl:URL
    var interceptors = [ApiRequestInterceptor]()
    
    init(baseApiUrl:URL, manager:SessionManager) {
        self.manager = manager
        self.baseApiUrl = baseApiUrl
    }
    
    func addApiRequestInterceptor(_ interceptor:@escaping ApiRequestInterceptor) {
        interceptors.append(interceptor)
    }
    
    func request<Response:ApiResponseDto>(method:HTTPMethod, path:String, queryParams:[String:Any]? = nil) -> Observable<Response> {
        return request(method: method, path: path, queryParams: queryParams, body:DummyApiRequestDto())
    }
    
    func request<Request:ApiRequestDto, Response:ApiResponseDto>(method:HTTPMethod, path:String, queryParams:[String:Any]? = nil, body:Request?) -> Observable<Response> {
        do {
            let url = baseApiUrl.appendingPathComponent(path)
            
            let request = ApiRequest(url:url)
            request.method = method
            request.queryParams = queryParams
            request.body = try body?.toBodyData()
            request.interceptors = interceptors
            
            return process(manager.rx.responseString(urlRequestConvertible: request))
        }
        catch {
            return Observable.error(RequestError.requestPrepareError(cause: error))
        }
        
    }
    
    private func process<Response:ApiResponseDto>(_ response:Observable<(HTTPURLResponse, String)>) -> Observable<Response> {
        return response.catchError { error in
            if (error is URLError) {
                throw RequestError.connectionError(cause:error)
            }
            else {
                throw RequestError.unknownError(cause: error)
            }
            }
            .map { (r, body) in
                debugPrint(r)
                print("Body \(body)")
                switch (r.statusCode) {
                case 200..<300:
                    return try Response(json: JSON(parseJSON: body))
                case 400..<500:
                    throw RequestError.requestClientError(statusCode: r.statusCode, response:r)
                case 500..<600:
                    throw RequestError.requestServerError(statusCode: r.statusCode, response:r)
                default:
                    throw RequestError.requestUnknownError(statusCode: r.statusCode, response:r)
                }
        }
    }
}

class ApiRequest: URLRequestConvertible {
    var method:HTTPMethod = .get
    var url:URL!
    var path:String!
    var queryParams:[String:Any]? = nil
    var body:Data? = nil
    
    var interceptors = [ApiRequestInterceptor]()
    
    init(url:URL) {
        self.url = url
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if (queryParams != nil) {
            urlRequest.appendQueryParams(params: queryParams!)
        }
        
        if (body != nil) {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = body
        }
        
        try interceptors.forEach { interceptor in
            if let error = interceptor(&urlRequest) {
                throw error
            }
        }
        
        return urlRequest
    }
}

typealias ApiRequestInterceptor = (_ urlRequest:inout URLRequest) -> Error?


protocol ApiRequestDto {
    func toBodyData() throws -> Data?
}

protocol ApiResponseDto {
    init(json: JSON) throws
}

class ApiResponseDtoArray<Element:ApiResponseDto>: ApiResponseDto, Sequence {
    var items = [Element]()
    
    required init(json: JSON) throws {
        for itemJson in json.array ?? [] {
            let item = try Element(json: itemJson)
            items.append(item)
        }
    }
    
    subscript(idx:Int) -> Element {
        return items[idx]
    }
    
    var count:Int {
        return items.count
    }
    
    func makeIterator() -> IndexingIterator<Array<Element>> {
        return items.makeIterator()
    }
    
    func toArray() -> [Element] {
        return items
    }
}

class DummyApiRequestDto: ApiRequestDto {
    func toBodyData() throws -> Data? {
        return nil
    }
}
