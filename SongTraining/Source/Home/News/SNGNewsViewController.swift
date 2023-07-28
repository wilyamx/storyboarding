//
//  SNGNewsViewController.swift
//  SongTraining
//
//  Created by William Rena on 7/6/23.
//

import UIKit

class SNGNewsViewController: SNGViewController, WSRStoryboarded {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SNGNewsViewModel()
    
    private var selectedCell: Int = -1
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .reachabilityChanged,
            object: nil)
        
        self.removeNetworkObserver()
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        
        NotificationCenter.default.addObserver(
            forName: .reachabilityChanged,
            object: nil,
            queue: nil) { notification in
            self.reachabilityConnectionHandler(notification)
        }
        try! self.addNetworkObserver()
        
        self.setupBinders()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        self.title = "News"
        
        self.tableView.register(UINib(nibName: "SNGNewsTableViewCell",
                                         bundle: Bundle.main),
                                forCellReuseIdentifier: String(describing: SNGNewsTableViewCell.self))
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 10
        self.tableView.allowsMultipleSelection = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SNGNewsDetailViewController {
            let data = self.viewModel.postList[self.selectedCell]
            vc.attributes = data.attributes
        }
    }
    
    // MARK: - View Model
    
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
                if self?.errorAlert == nil, type != .badRequest {
                    DispatchQueue.main.async {
                        self?.errorAlert = SNGErrorAlertContainerView()
                        self?.errorAlert?.showAlert(with: type, on: self!, withDelegate: nil)
                    }
                }
            }
        }
        
        self.viewModel.postData.bind { [weak self] value in
            if value.data.count > 0 {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        
    }
    
    // MARK: - Handlers
    
    private func reachabilityConnectionHandler(_ notification: Notification) {
        if let object = notification.object as? Bool {
            if object {
                Task {
                    await self.viewModel.getPosts()
                }
            }
        }
    
    }
}

extension SNGNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.postList.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.viewModel.postList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
                   withIdentifier: String(describing: SNGNewsTableViewCell.self),
                   for: indexPath) as! SNGNewsTableViewCell
        cell.selectionStyle = .none
        cell.updateDisplay(model: data)
        return cell
    }
}

extension SNGNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SNGNewsTableViewCell.CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = indexPath.row
        self.performSegue(withIdentifier: SNGSegue.newsDetail.rawValue, sender: nil)
    }
    
}

