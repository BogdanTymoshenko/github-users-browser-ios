//
//  ReposRepository.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import RxSwift

protocol ReposRepository {
    func repos(forUserLogin login:String) -> Observable<[Repo]>
}
