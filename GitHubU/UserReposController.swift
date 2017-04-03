//
//  UserReposController.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit
import RxSwift
import MBProgressHUD

class UserReposController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserReposView {
    
    var userLogin:String!
    var presenter:UserReposPresenter!
    var repos = [Repo]()
    var loadingView:MBProgressHUD? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = UserReposPresenter(view: self, cp: UIApplication.componentProvider)
        presenter.userLogin = userLogin
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }

    //
    // MARK: UICollectionViewDataSource
    //
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let repo = repos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "repo_cell", for: indexPath) as! UserRepoViewCell
        
        cell.nameLabel.text = repo.name
        cell.descLabel.text = repo.desc
        cell.descLabel.isHidden = (repo.desc == nil)
        cell.languageLabel.text = repo.lang
        cell.seenCountLabel.text = String(repo.seen)
        cell.starsCountLabel.text = String(repo.stars)
        cell.forksCountLabel.text = String(repo.forks)
        
        return cell
    }
   
    //
    // MARK: UICollectionViewDelegateFlowLayout
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let repo = repos[indexPath.row]
        return UserRepoViewCell.computeContentSize(collectionViewBounds: collectionView.bounds, repo: repo)
    }
    
    //
    // MARK: UserReposView
    //
    func showRepos(repos:[Repo]) {
        self.repos.removeAll()
        self.repos.append(contentsOf: repos)
        collectionView?.reloadData()
    }
    
    func showReposLoading() {
        loadingView?.hide(animated: false)
        loadingView = MBProgressHUD.show(at: self)
    }
    
    func dismissReposLoading() {
        loadingView?.hide(animated: true)
        loadingView = nil
    }
    
    func showError(error:Error) {
        showErrorCommonDialog(error: error)
    }
}

protocol UserReposView {
    func showRepos(repos:[Repo])
    
    func showReposLoading()
    func dismissReposLoading()
    func showError(error:Error)
}

class UserReposPresenter {
    let view:UserReposView
    let reposRepository:ReposRepository
    var userLogin:String!
    
    var loadedRepos = [Repo]()
    var disposeBag = DisposeBag()
    
    init(view:UserReposView, cp:ComponentProvider) {
        self.view = view
        self.reposRepository = cp.reposRepository
    }
    
    func viewWillAppear() {
        view.showReposLoading()
        reposRepository.repos(forUserLogin: userLogin)
            .map { repos -> [Repo]? in repos }
            .catchError { error in
                self.view.showError(error: error)
                return Observable.just(nil)
            }
            .do(onNext: { _ in
                self.view.dismissReposLoading()
            })
            .filter { $0 != nil }.map { $0! }
            .subscribe(onNext: { repos in
                self.loadedRepos.removeAll()
                self.loadedRepos.append(contentsOf: repos)
                self.view.showRepos(repos: self.loadedRepos)
            }, onError: { error in
                self.view.showError(error: error)
            })
            .addDisposableTo(disposeBag)
    }
    
    func viewWillDisappear() {
        disposeBag = DisposeBag()
    }
}
