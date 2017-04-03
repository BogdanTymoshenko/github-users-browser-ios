//
//  UserReposController.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit
import MBProgressHUD
import DZNEmptyDataSet

class UserReposController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UserReposView {
    
    var userLogin:String!
    var presenter:UserReposPresenter!
    var user:UserView? = nil
    var repos = [Repo]()
    var loadingView:MBProgressHUD? = nil
    var isFirstReposUpdate = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = UserReposPresenter(view: self, cp: UIApplication.componentProvider)
        presenter.userLogin = userLogin
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = userLogin
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "user_info_header", for: indexPath) as! UserInfoViewHeader
        
        cell.nameLabel.text = user?.name ?? userLogin
        cell.setAvatarUrl(url: user != nil ? URL(string:user!.avatarUrl) : nil)
        cell.followersCountLabel.text = user?.followersCount ?? "-"
        cell.followingCountLabel.text = user?.followingCount ?? "-"
        cell.companyAndLocationLabel.text = user?.companyAndLocation
        
        return cell
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
    // MARK: UICollectionViewDelegate
    //
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.onRepoSelected(atPosition: indexPath.row)
    }
   
    //
    // MARK: UICollectionViewDelegateFlowLayout
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let repo = repos[indexPath.row]
        return UserRepoViewCell.computeContentSize(collectionViewBounds: collectionView.bounds, repo: repo)
    }
    
    //
    // MARK: DZNEmptyDataSetSource
    //
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = NSMutableAttributedString(string: NSLocalizedString("user_repos__label__no_repos", comment: ""))
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium),
                          NSForegroundColorAttributeName: UIColor.black]
        title.addAttributes(attributes, range: NSRange(location: 0, length: title.length))
        return title
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "img_octocat")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
    
    //
    // MARK: DZNEmptyDataSetDelegate
    //
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !isFirstReposUpdate
    }

    
    //
    // MARK: UserReposView
    //
    func showUser(user:UserView) {
        self.user = user
        collectionView?.reloadData()
    }
    
    func showRepos(repos:[Repo]) {
        isFirstReposUpdate = false
        self.repos.removeAll()
        self.repos.append(contentsOf: repos)
        collectionView?.reloadData()
    }
    
    func showRepoView(repo: Repo) {
        if let repoUrl = URL(string:repo.htmlUrl) {
            UIApplication.shared.openUrlIfCan(url: repoUrl)
        }
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
