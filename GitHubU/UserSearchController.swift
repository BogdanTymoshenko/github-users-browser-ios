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

class UserSearchController: UITableViewController, UserSearchView {
    @IBOutlet weak var searchBarView: UISearchBar!
    
    var presenter:UserSearchPresenter!
    var users = [UserShort]()
    var loadingView:MBProgressHUD? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = UserSearchPresenter(view: self, cp:UIApplication.componentProvider)
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
    // MARK: UIScrollViewDelegate
    //
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarView.resignFirstResponder()
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
        self.users.removeAll()
        self.users.append(contentsOf: users)
        tableView.reloadData()
    }
    
    func showUserRepos(user:UserShort) {
        // TODO
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
        if let serviceError = error as? CommonServiceError {
            switch serviceError {
            case .connectionMissing:
                UIAlertController.showError(in: self, message: "common__error__connection_problem")
            case .limitExceeded(let until):
                if let until = until {
                    let timeFormatter = DateFormatter()
                    timeFormatter.timeStyle = DateFormatter.Style.short
                    let untilDate = timeFormatter.string(from: until)
                    let message = String(format:NSLocalizedString("common__error__limit_exceeded__try_after", comment: ""), untilDate)
                    UIAlertController.showError(
                        in: self,
                        localizedTitle: NSLocalizedString("common__title__error", comment: ""),
                        localizedMessage: message
                    )
                }
                else {
                    UIAlertController.showError(in: self, message: "common__error__limit_exceeded__try_later")
                }
            }
        }
        else {
            UIAlertController.showError(in: self, message: "common__error__unexpected")
        }
    }
}
