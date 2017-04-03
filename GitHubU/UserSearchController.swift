//
//  SearchController.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage
import MBProgressHUD
import DZNEmptyDataSet

class UserSearchController: UITableViewController, UserSearchView, DZNEmptyDataSetSource {
    @IBOutlet weak var searchBarView: UISearchBar!
    
    var presenter:UserSearchPresenter!
    var users = [UserShort]()
    var loadingView:MBProgressHUD? = nil
    var isFirstUsersUpdate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = UserSearchPresenter(view: self, cp:UIApplication.componentProvider)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = NSLocalizedString("user_search__title", comment: "")
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = nil
        presenter.viewWillDisappear()
    }
    
    //
    // MARK: UITableViewDataSource
    //
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "user_cell", for: indexPath) as! UserViewCell
        cell.setAvatarUrl(url: URL(string:user.avatarUrl))
        cell.loginLabel.text = user.login
        return cell
    }
    
    //
    // MARK: UITableViewDelegate
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.onUserSelected(atPosition: indexPath.row)
    }
    
    
    //
    // MARK: UIScrollViewDelegate
    //
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarView.resignFirstResponder()
    }
    
    //
    // MARK: DZNEmptyDataSetSource
    //
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let titleKey = isFirstUsersUpdate ? "user_search__label__search_hint" : "user_search__label__nothing_found"
        let title = NSMutableAttributedString(string: NSLocalizedString(titleKey, comment: ""))
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium),
                          NSForegroundColorAttributeName: UIColor.black]
        title.addAttributes(attributes, range: NSRange(location: 0, length: title.length))
        return title
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "img_octocat")
    }
    
    //
    // MARK: SearchView
    //
    var queryTextChangeEvents: Observable<SearchQueryEvent> {
        return searchBarView.rx.text.map { text in
            SearchQueryEvent(query: text ?? "")
        }
    }
    
    func showUsers(users: [UserShort]) {
        isFirstUsersUpdate = false
        self.users.removeAll()
        self.users.append(contentsOf: users)
        tableView.reloadData()
    }
    
    func showUserRepos(user:UserShort) {
        if let userReposController = storyboard?.instantiateViewController(withIdentifier: "user_repos") as? UserReposController {
            userReposController.userLogin = user.login
            navigationController?.pushViewController(userReposController, animated: true)
        }
    }
    
    func showLoading() {
        loadingView?.hide(animated: false)
        loadingView = MBProgressHUD.show(at: self)
    }
    
    func dismissLoading() {
        loadingView?.hide(animated: true)
        loadingView = nil
    }
    
    func showError(error: Error) {
        showErrorCommonDialog(error: error)
    }
}
