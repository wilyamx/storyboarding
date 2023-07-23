//
//  SNGNewsHomeTableViewCell.swift
//  SongTraining
//
//  Created by William Rena on 7/11/23.
//

import UIKit

class SNGNewsHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SNGNewsViewModel()
    
    private var selectedCell: Int = -1
    
    lazy var noResultsView: SNGNoResultsView = {
        let view = SNGNoResultsView.viewFromNib()
        view?.lblDescription.text = "Sorry, there are no news available at this time. Please try again later."
        view?.lighterTheme()
        return view!
    }()
    
    var newsSelectAction: ((SNGPostAttributes?) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupViews()
        self.setupBinders()
        Task {
            await self.viewModel.getPosts()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Private Methods
    
    private func setupViews() {
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
        
        // ---
        
        noResultsView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        noResultsView.frame = self.contentView.bounds
        noResultsView.isHidden = false
        noResultsView.frame = self.contentView.bounds.inset(by: UIEdgeInsets(top: 0,
                                                                             left: 20,
                                                                             bottom: 20,
                                                                             right: 20))
        noResultsView.layer.cornerRadius = 10.0
        noResultsView.isHidden = true
        self.contentView.addSubview(noResultsView)
    }
    
    // MARK: - View Model
    
    private func setupBinders() {
        self.viewModel.isLoading.bind { value in

        }
        
        self.viewModel.error.bind { [weak self] value in
            DispatchQueue.main.async {
                if value.count == 0 {
                    self?.noResultsView.isHidden = true
                }
                else {
                    self?.noResultsView.isHidden = false
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
}

extension SNGNewsHomeTableViewCell: UITableViewDataSource {
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

extension SNGNewsHomeTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SNGNewsTableViewCell.CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = indexPath.row
        
        if let action = newsSelectAction {
            let data = self.viewModel.postList[self.selectedCell]
            action(data.attributes)
        }
    }
    
}
