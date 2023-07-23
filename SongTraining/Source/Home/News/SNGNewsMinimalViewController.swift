//
//  SNGNewsMinimalViewController.swift
//  SongTraining
//
//  Created by William Rena on 7/10/23.
//

import UIKit

class SNGNewsMinimalViewController: SNGViewController {

    let viewModel = SNGNewsViewModel()
    
    let item1  = SNGNewsTableViewCell.viewFromNib()
    let item2  = SNGNewsTableViewCell.viewFromNib()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        
        self.setupBinders()
        Task {
            await self.viewModel.getPosts()
        }
    }
    
    // MARK: - View Model
    
    private func setupBinders() {
        self.viewModel.isLoading.bind { value in
            
        }
        
        self.viewModel.error.bind { value in
            
        }
        
        self.viewModel.postData.bind { [weak self] value in
            if value.data.count > 0 {
                DispatchQueue.main.async {
                    self?.item1?.updateDisplay(model: value.data[0])
                    self?.item2?.updateDisplay(model: value.data[1])
                }
            }
        }
        
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        self.view.isUserInteractionEnabled = false
        
        let stackView = UIStackView()
        //stackView.backgroundColor = .yellow
        self.view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.isUserInteractionEnabled = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        //---
        
        //item1?.backgroundColor = .purple
        stackView.addArrangedSubview(item1!)
        item1?.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        item1?.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        item1?.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        item1?.heightAnchor.constraint(equalToConstant: SNGNewsTableViewCell.CELL_HEIGHT).isActive = true
       
        let item1Tap = UITapGestureRecognizer(target: self, action: #selector(self.item1Tap(_:)))
        item1Tap.numberOfTapsRequired = 1
        item1?.contentView.addGestureRecognizer(item1Tap)
        item1?.isUserInteractionEnabled = true
        
        //---
        
        //item2?.backgroundColor = .red
        stackView.addArrangedSubview(item2!)
        item2?.topAnchor.constraint(equalTo: item1!.bottomAnchor).isActive = true
        item2?.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        item2?.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        item2?.heightAnchor.constraint(equalToConstant: SNGNewsTableViewCell.CELL_HEIGHT).isActive = true
    }

    // MARK: - Actions
    
    @objc func item1Tap(_ sender: UITapGestureRecognizer) {
        logger.info(message: "Bacground tap!")
        
    }
    
}
