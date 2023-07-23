//
//  SNGProfileViewController.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit

class SNGProfileViewController: SNGViewController, SNGTabBarContent {

    @IBOutlet weak var tableView: UITableView!
    
    let HEADER_HEIGHT = 80.0
    
    let viewModel = SNGProfileViewModel()
    
    var coordinator: SNGProfileCoordinator?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBinders()
        self.sngNavigationBarWithLogo(withLineSeparator: false)
        self.setupViews()
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 10
        self.tableView.allowsMultipleSelection = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.tableView.sectionHeaderTopPadding = 0
        
        //---
        
        if let navigationVC = self.navigationController {
            coordinator = SNGProfileCoordinator(navigationController: navigationVC)
            coordinator?.start()
        }
    }
    
    // MARK: - View Models
    
    private func setupBinders() {
        self.viewModel.isLoading.bind { [weak self] value in
            DispatchQueue.main.async {
                if value {
                    self?.showActivityIndicator()
                }
                else {
                    self?.hideActivityIndicator()
                }
            }
        }
        
        self.viewModel.error.bind { [weak self] value in
            if let type = SNGErrorAlertType(rawValue: value) {
                DispatchQueue.main.async {
                    let errorAlert = SNGErrorAlertContainerView()
                    errorAlert.showAlert(with: type, on: self!, withDelegate: nil)
                }
            }
        }
        
        self.viewModel.isLoggedOut.bind { [weak self] value in
            if value {
                DispatchQueue.main.async {
                    self?.coordinator?.switchToSignIn()
                }
            }
        }
        
    }
}

extension SNGProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getMenuList().count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.viewModel.getMenuList()[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
                   withIdentifier: "cell",
                   for: indexPath)
        
        cell.selectionStyle = .none
        cell.textLabel?.text = data.label
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
        if let imageName = data.image,
           let image = UIImage(named: imageName) {
            cell.imageView?.image = image
        }
        else {
            cell.imageView?.image = nil
        }
        
        return cell
    }
}

extension SNGProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel.getMenuList()[indexPath.row]
        
        if data.label == "Logout" {
            self.viewModel.logout()
        }
        else if data.label == "Sign in" {
            self.coordinator?.switchToSignIn()
        }
        else if data.label == "Sign up" {
            coordinator?.signUp()
        }
        else if data.label == "Support" {
            coordinator?.support()
        }
        else if data.label == "View Profile" {
            coordinator?.profileDetails()
        }
        else if data.label == "Settings" {
            coordinator?.settings()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SNGProfileHeaderView.viewFromNib()
        view?.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: HEADER_HEIGHT)
        view?.addLineSeparator()
        view?.backgroundColor = UIColor.white
        
        if let fullname = self.viewModel.getFullname(),
           let username = self.viewModel.getUsername() {
            view?.updateUserDisplay(headline: fullname,
                                    subheadline: "@\(username)")
        }
        else {
            view?.updateUserDisplay()
        }
        
        return view
    }
}
