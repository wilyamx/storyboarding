//
//  SNGCarouselBannerViewController.swift
//  SongTraining
//
//  Created by William Rena on 7/4/23.
//

import UIKit

class SNGCarouselBannerViewController: SNGViewController {

    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
        
    var timer = Timer()
    var counter = 0
    var defaultBannerDisplay = false
    
    let viewModel = SNGCarouselBannerViewModel()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        self.setupBinders()
        Task {
            await self.viewModel.getBanners()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        self.sliderCollectionView.register(UINib(nibName: "SNGBannerCollectionViewCell",
                                             bundle: nil),
                                           forCellWithReuseIdentifier: "cell")
        self.sliderCollectionView.isPagingEnabled = true
        self.sliderCollectionView.backgroundColor = .black
        
        self.pageView.numberOfPages = 0
        self.pageView.currentPage = 0
        self.pageView.isUserInteractionEnabled = false
        
        self.pageView.pageIndicatorTintColor = UIColor.sngDisabledColor
        self.pageView.currentPageIndicatorTintColor = UIColor.black
        self.pageView.backgroundColor = .white.withAlphaComponent(0.75)
        self.pageView.clipsToBounds = true
        self.pageView.layer.cornerRadius = self.pageView.frame.size.height / 2.0
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0,
                                              target: self,
                                              selector: #selector(self.changeImage),
                                              userInfo: nil,
                                              repeats: true)
        }
    }
    
    // MARK: - View Models
    
    private func setupBinders() {
        self.viewModel.isLoading.bind { value in
            
        }

        self.viewModel.error.bind { value in
            
        }
        
        self.viewModel.bannerData.bind { [weak self] value in
            if value.data.count == 0 {
                DispatchQueue.main.async {
                    self?.defaultBannerDisplay = true
                    self?.pageView.isHidden = true
                    self?.pageView.numberOfPages = 1
                    
                    self?.sliderCollectionView.dataSource = self
                    self?.sliderCollectionView.delegate = self
                    self?.sliderCollectionView.reloadData()
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.defaultBannerDisplay = false
                    self?.pageView.isHidden = false
                    self?.pageView.numberOfPages = self?.viewModel.banners.count ?? 0
                    
                    self?.sliderCollectionView.dataSource = self
                    self?.sliderCollectionView.delegate = self
                    self?.sliderCollectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Public Methods
    
    public func refresh() {
        Task {
            await self.viewModel.getBanners()
        }
    }
    
    // MARK: - Actions
    
    @objc func changeImage() {
        guard !self.defaultBannerDisplay else { return }
        
        if counter < self.viewModel.banners.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.pageView.currentPage = counter
            counter += 1
        }
        else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            self.pageView.currentPage = counter
            counter = 1
        }
         
     }
}

extension SNGCarouselBannerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let count = self.defaultBannerDisplay ? 1 : self.viewModel.banners.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SNGBannerCollectionViewCell
        
        guard !self.defaultBannerDisplay else {
            cell.updateDisplay(image: self.viewModel.defaultImages[Int.random(in: 0..<3)]!,
                               model: viewModel.defaultBanner)
            return cell
        }
        
        let data = self.viewModel.banners[indexPath.row]
        cell.updateDisplay(image: self.viewModel.defaultImages[Int.random(in: 0..<3)]!,
                           model: data)
        return cell
    }
    
}

extension SNGCarouselBannerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        
        return CGSize(width: size.width, height: 230.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension SNGCarouselBannerViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil( x / w ))
        
        counter = currentPage
        self.pageView.currentPage = currentPage
    }
}
