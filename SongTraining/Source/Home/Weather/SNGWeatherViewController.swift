//
//  SNGWeatherViewController.swift
//  SongTraining
//
//  Created by William Rena on 7/4/23.
//

import UIKit

class SNGWeatherViewController: SNGViewController {

    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var imgvWeather: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var viewWeather: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(hexString: "#718899").cgColor,
            UIColor(hexString: "#BAB6AB").cgColor,
            UIColor(hexString: "#CCB99C").cgColor,
            UIColor(hexString: "#E0923C").cgColor
        ]
        gradient.locations = [0, 0.5, 0.65, 1]
        return gradient
    }()
    
    lazy var noResultsView: SNGNoResultsView = {
        let view = SNGNoResultsView.viewFromNib()
        view?.lblDescription.text = "Sorry, there is no data available for this city. Please try again later."
        return view!
    }()
    
    let viewModel = SNGWeatherViewModel()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        self.setupBinders()
        self.initializeData()
    }
    
    // MARK: - Private Methods

    private func setupView() {
        self.view.backgroundColor = .clear
        self.stackView.backgroundColor = .clear
        
        self.viewWeather.backgroundColor = .clear
        
        self.lblTemperature.textColor = .white
        self.lblTemperature.font = UIFont.boldSystemFont(ofSize: 34.0)
        
        self.lblDate.textColor = .white
        self.lblDate.font = UIFont.preferredFont(forTextStyle: .body)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM d, yyyy"
        
        self.lblDate.text = dateFormatter.string(from: Date())
        
        self.lblWeather.textColor = .white
        self.lblWeather.font = UIFont.preferredFont(forTextStyle: .headline)
        
        self.btnCity.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.btnCity.imageView?.centerYAnchor.constraint(equalTo: self.btnCity.centerYAnchor, constant: 0).isActive = true
        self.btnCity.imageView?.trailingAnchor.constraint(equalTo: self.btnCity.leadingAnchor, constant: self.btnCity.frame.size.width - 10.0).isActive = true
        self.btnCity.tintColor = .lightGray.withAlphaComponent(0.5)
        self.btnCity.menu = citiesMenuItems()
        self.updateSelectedCity(city: viewModel.defaultCity)
        
        //----
        
        gradientLayer.frame = self.viewBox.bounds
        self.viewBox.layer.insertSublayer(gradientLayer, at: 0)
        
        self.viewBox.layer.cornerRadius = 10.0
        self.viewBox.clipsToBounds = true
        
        //---
        
        noResultsView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        noResultsView.frame = self.viewBox.bounds
        noResultsView.isHidden = true
        
        self.viewBox.addSubview(noResultsView)
        self.viewBox.addSubview(self.btnCity)
    }
    
    private func updateSelectedCity(city: String) {
        self.btnCity.setTitle(city.uppercased(), for: .normal)
        self.btnCity.setTitle(city.uppercased(), for: .selected)
    }
    
    private func citiesMenuItems() -> UIMenu {
        var menuActions = [UIAction]()
        viewModel.cities.map({ $0.uppercased() }).sorted().forEach { city in
            let action = UIAction(title: city, handler: { action in
                let city = action.title
                self.updateSelectedCity(city: city)
                Task {
                    await self.viewModel.getWeather(from: city)
                }
            })
            menuActions.append(action)
        }
        
        let menuItems = UIMenu(
            title: "",
            options: .displayInline,
            children: menuActions)
        return menuItems
    }
    
    // MARK: - View Models
    
    private func setupBinders() {
        self.viewModel.isLoading.bind { [weak self] value in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = true
                
                if value {
                    self?.btnCity.isEnabled = false
                }
                else {
                    self?.btnCity.isEnabled = true
                }
            }
        }
        
        self.viewModel.error.bind { [weak self] value in
            DispatchQueue.main.async {
                if value.count == 0 {
                    self?.noResultsView.isHidden = true
                }
                else {
                    self?.noResultsView.isHidden = false
                    
                    if let type = SNGErrorAlertType(rawValue: value),
                       type != .badRequest {
                        self?.noResultsView.errorReason(reason: type.getMessage())
                    }
                            
                }
            }
        }
        
        self.viewModel.weatherDetails.bind { [weak self] value in
            guard let description = value.description,
                  let temperature = value.temperature,
                  let image = value.image else { return }
                    
            DispatchQueue.main.async {
                self?.lblTemperature.text = "\(temperature)°C"
                self?.lblWeather.text = "\(description.capitalized)"
                
                if let icon = UIImage(named: image) {
                    self?.imgvWeather.image = icon
                }
            }
        }
    }
    
    private func initializeData() {
        Task {
            await self.viewModel.getWeather(from: self.viewModel.defaultCity)
        }
    }
    
    // MARK: - Public Methods
    
    public func refresh() {
        let selectedCity = self.btnCity.titleLabel?.text ?? viewModel.defaultCity
        
        self.updateSelectedCity(city: selectedCity.uppercased())
        Task {
            await self.viewModel.getWeather(from: selectedCity)
        }
    }
}
