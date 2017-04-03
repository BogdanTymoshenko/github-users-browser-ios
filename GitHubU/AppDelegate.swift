//
//  AppDelegate.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var apiFactory:ApiFactory!
    var componentProvider:ComponentProvider!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        apiFactory = ApiFactoryImpl()
        componentProvider = ComponentProviderImpl(apiFactory:apiFactory)
        return true
    }
}

class ApiFactoryImpl: ApiFactory {
    var searchApi: SearchApi
    var usersApi: UsersApi
    var reposApi: ReposApi
    
    init() {
        let manager = SessionManager.default
        let client = RestApiClient(baseApiUrl: URL(string:"https://api.github.com/")!, manager: manager)
        
        let login = "amicablesoft-test"
        let token = "46f2d64584bb5c36676ef19ed83f2960d61b00ba"
        
        client.addApiRequestInterceptor { request in
            if let basicAuth = Request.authorizationHeader(user: login, password: token) {
                request.setValue(basicAuth.value, forHTTPHeaderField: basicAuth.key)
            }
            
            return nil
        }
        
        searchApi = SearchApiImpl(client: client)
        usersApi = UsersApiImpl(client: client)
        reposApi = ReposApiImpl(client: client)
    }
}

class ComponentProviderImpl: ComponentProvider {
    var usersRepository: UsersRepository
    var reposRepository: ReposRepository
    var mainScheduler: SchedulerType
    
    init(apiFactory:ApiFactory) {
        usersRepository = UsersRepositoryImpl(apiFactory: apiFactory)
        reposRepository = ReposRepositoryImpl(apiFactory: apiFactory)
        mainScheduler = MainScheduler.instance
    }
}

extension UIApplication {
    static var componentProvider:ComponentProvider {
        let app = UIApplication.shared
        return (app.delegate as! AppDelegate).componentProvider
    }
}

extension UIApplication {
    func openUrlIfCan(url:URL) {
        if (canOpenURL(url)) {
            if #available(iOS 10, *) {
                open(url, options: [:], completionHandler: nil)
                
            } else {
                _ = openURL(url)
            }
        }
    }
}
