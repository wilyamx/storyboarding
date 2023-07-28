//
//  SNGProfileDetailsViewController.swift
//  SongTraining
//
//  Created by William Rena on 7/5/23.
//

import UIKit

class SNGProfileDetailsViewController: SNGViewController, WSRStoryboarded {

    let PROFILE_SECTION_HEIGHT = 470.0
    let DELETE_ACCOUNT_SECTION_HEIGHT = 170.0
    
    let viewModel = SNGProfileDetailsViewModel()
    
    weak var coordinator: SNGProfileCoordinator?
    
    lazy var myProfileSectionView: SNGProfileDetailsView = {
        let view = SNGProfileDetailsView.viewFromNib()
        view!.backgroundColor = .clear
        return view!
    }()
    
    lazy var deleteAccountSectionView: SNGDeleteAccountView = {
        let view = SNGDeleteAccountView.viewFromNib()
        view!.backgroundColor = .clear
        return view!
    }()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .noResultsModalDidClose,
            object: nil)
        
        self.removeNetworkObserver()
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sngNavigationBarWithLogo(withLineSeparator: false)
        self.setupView()
        
        //---
        
        try! self.addNetworkObserver()
        NotificationCenter.default.addObserver(
            forName: .noResultsModalDidClose,
            object: nil,
            queue: nil) { notification in
            self.noResultsModalHandler(notification)
        }
        
        //---
        
        self.setupBinders()
        Task {
            await self.viewModel.getUserDetails()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        //---
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        stackView.addArrangedSubview(containerView)
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        containerView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: PROFILE_SECTION_HEIGHT).isActive = true
        
        containerView.addSubview(myProfileSectionView)
        myProfileSectionView.translatesAutoresizingMaskIntoConstraints = false
        myProfileSectionView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        myProfileSectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        myProfileSectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        myProfileSectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        //---
        
        let spacer = UIView()
        spacer.backgroundColor = .clear
        stackView.addArrangedSubview(spacer)
        spacer.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        spacer.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        spacer.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let separator = UIView()
        separator.backgroundColor = UIColor.secondarySystemFill
        stackView.addArrangedSubview(separator)
        separator.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        //---
        
        let containerView2 = UIView()
        containerView2.backgroundColor = .clear
        stackView.addArrangedSubview(containerView2)
        containerView2.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        containerView2.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
        containerView2.heightAnchor.constraint(equalToConstant: DELETE_ACCOUNT_SECTION_HEIGHT).isActive = true
        
        containerView2.addSubview(deleteAccountSectionView)
        deleteAccountSectionView.translatesAutoresizingMaskIntoConstraints = false
        deleteAccountSectionView.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: 20).isActive = true
        deleteAccountSectionView.leftAnchor.constraint(equalTo: containerView2.leftAnchor).isActive = true
        deleteAccountSectionView.rightAnchor.constraint(equalTo: containerView2.rightAnchor).isActive = true
        deleteAccountSectionView.bottomAnchor.constraint(equalTo: containerView2.bottomAnchor).isActive = true
    }
    
    // MARK: - Handlers
    
    private func noResultsModalHandler(_ notification: Notification) {
        self.navigationController?.popViewController(animated: true)
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
                if self?.errorAlert == nil, type != .badRequest {
                    DispatchQueue.main.async {
                        self?.errorAlert = SNGErrorAlertContainerView()
                        self?.errorAlert?.showAlert(with: type, on: self!, withDelegate: self)
                    }
                }
            }
        }
        
        self.viewModel.userDetails.bind { [weak self] value in
            DispatchQueue.main.async {
                guard value.id != -1 else { return }
                
                self?.myProfileSectionView.txtFirstName.text = value.firstname
                self?.myProfileSectionView.txtLastName.text = value.lastname
                self?.myProfileSectionView.txtEmail.text = value.email
                self?.myProfileSectionView.txtUsername.text = value.username
                
                self?.myProfileSectionView.allowEditing = false
            }
        }
    }
    
}
