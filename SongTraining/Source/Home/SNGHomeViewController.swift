//
//  SNGHomeViewController.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit

class SNGHomeViewController: UITableViewController, SNGTabBarContent {
    
    @IBOutlet weak var bannerCell: UITableViewCell!
    @IBOutlet weak var weatherCell: UITableViewCell!
    @IBOutlet weak var newsCell: SNGNewsHomeTableViewCell!
    
    let NEWS_HEADER_HEIGHT = 50.0
    
    private var selectedNewsDetail: SNGPostAttributes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    // MARK: - Private Methods
    
    func setupView() {
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        
        bannerCell.backgroundColor = .clear
        bannerCell.selectionStyle = .none
        
        weatherCell.backgroundColor = .clear
        weatherCell.selectionStyle = .none
        
        newsCell.backgroundColor = .clear
        newsCell.selectionStyle = .none
        
        //----
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let bannerVC  = storyboard.instantiateViewController(withIdentifier: "SNGCarouselBannerViewController") as! SNGCarouselBannerViewController
        bannerVC.view.frame = bannerCell.bounds
        bannerVC.view.translatesAutoresizingMaskIntoConstraints = true
        bannerVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        bannerCell.addSubview(bannerVC.view)
        
        //----
        
        let weatherVC  = storyboard.instantiateViewController(withIdentifier: "SNGWeatherViewController") as! SNGWeatherViewController
        weatherVC.view.frame = weatherCell.bounds

        weatherCell.addSubview(weatherVC.view)
        
        //----
        
        newsCell.newsSelectAction = { attribute in
            self.selectedNewsDetail = attribute
            self.performSegue(withIdentifier: SNGSegue.newsDetail.rawValue, sender: nil)
        }
        
        //----
        
        self.sngNavigationBarWithLogo(withLineSeparator: false)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SNGNewsViewController {
            vc.hidesBottomBarWhenPushed = true
        }
        if let vc = segue.destination as? SNGNewsDetailViewController {
            vc.hidesBottomBarWhenPushed = true
            vc.attributes = self.selectedNewsDetail
        }
    }
    
    // MARK: - Delegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        else {
            let view = SNGNewsHeaderView.viewFromNib()
            view!.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: NEWS_HEADER_HEIGHT)
            view!.nextAction = {
                self.performSegue(withIdentifier: SNGSegue.newsList.rawValue, sender: nil)
            }
            
            return view!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else {
            return NEWS_HEADER_HEIGHT
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}
