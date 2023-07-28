//
//  SNGSignInViewController.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit

class SNGSignInViewController: SNGViewController, WSRStoryboarded {

    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblSignIn: UILabel!
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var lblForgotPassword: UILabel!
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var viewPassword: SNGLoginInputView!
    @IBOutlet weak var viewEmail: SNGLoginInputView!
    
    @IBAction func actnSignIn(_ sender: UIButton) {
        self.inactiveUserInputs()
        
        Task {
            await self.viewModel.login(email: self.viewEmail.getInputText(),
                                       password: self.viewPassword.getInputText())
        }
    }
    
    @IBAction func actnSkip(_ sender: UIButton) {
        self.viewModel.loginAsGuest()
        self.coordinator?.switchToLandingPage()
    }
    
    weak var coordinator: SNGSignInCoordinator?
    let viewModel = SNGSignInViewModel()
    
    deinit {
        self.removeNetworkObserver()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        // background tap
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackgroundTap(_:)))
        backgroundTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(backgroundTap)
        self.view.isUserInteractionEnabled = true
        
        try! self.addNetworkObserver()
        self.setupBinders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.viewEmail.txtInput.becomeFirstResponder()
    }
    
    // MARK: - User Interface
    
    private func setupView() {
        self.viewContainer.backgroundColor = .clear
        
        //---
        
        self.lblSignIn.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        //---
        
        let signUpTap = UITapGestureRecognizer(target: self,
                                                    action: #selector(self.signUpTapped(_:)))
        signUpTap.numberOfTapsRequired = 1
        self.lblSignUp.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.lblSignUp.isUserInteractionEnabled = true
        self.lblSignUp.addGestureRecognizer(signUpTap)
        
        let signUpText = "Don't have an account? Sign up"
        let signUpBoldText = "Sign up"
       
        if let signUpRange = self.lblSignUp.text?.range(of: signUpBoldText)?.nsRange {
            let boldAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            
            let signUpAttributedString = NSMutableAttributedString(string: signUpText)
            signUpAttributedString.addAttributes(boldAttributes, range: signUpRange)
            
            self.lblSignUp.attributedText = signUpAttributedString
        }
        
        //---
        
        let forgotPasswordTap = UITapGestureRecognizer(target: self,
                                                    action: #selector(self.forgotPasswordTapped(_:)))
        forgotPasswordTap.numberOfTapsRequired = 1
        self.lblForgotPassword.font = UIFont.boldSystemFont(ofSize: 13)
        self.lblForgotPassword.isUserInteractionEnabled = true
        self.lblForgotPassword.addGestureRecognizer(forgotPasswordTap)
        
        //---
        
        let signInText = "Sign in"
        let signInFontAttribute = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.sngSecondaryColor
        ]
        
        let signInTextRange = NSRange(location: 0, length: signInText.count)
        let signInAttributedString = NSMutableAttributedString(string: signInText)
        signInAttributedString.addAttributes(signInFontAttribute, range: signInTextRange)
        
        self.btnSignIn.setAttributedTitle(signInAttributedString, for: .normal)
        self.btnSignIn.setAttributedTitle(signInAttributedString, for: .selected)
        
        self.btnSignIn.tintColor = UIColor.sngDisabledColor
        self.btnSignIn.isEnabled = false
        
        //---
        
        let skipToHomepageText = "Skip to Home page"
        let skipFontAttribute = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ]
        
        let allRange = NSRange(location: 0, length: skipToHomepageText.count)
        
        let skipAttributedString = NSMutableAttributedString(string: skipToHomepageText)
        skipAttributedString.addAttribute(.underlineStyle, value: 1, range: allRange)
        skipAttributedString.addAttributes(skipFontAttribute, range: allRange)
        
        self.btnSkip.setAttributedTitle(skipAttributedString, for: .normal)
        self.btnSkip.setAttributedTitle(skipAttributedString, for: .selected)
        
        //---
        
        viewEmail.inputLabel = "Email Address"
        viewEmail.validationErrorMessage = "Please enter a valid email address"
        viewEmail.statusErrorMessage = "Your sign-in details were incorrect. Please try again."
        viewEmail.inputValidation = { (inputText) -> Bool in
            self.updateSignInButtonStatus()
            return inputText.isValidEmail()
        }
        viewEmail.onStatusChange = { () -> Void in
            self.updateSignInButtonStatus()
        }
        
        viewPassword.inputLabel = "Password"
        viewPassword.validationErrorMessage = "Please enter a valid password"
        viewPassword.statusErrorMessage = "Your sign-in details were incorrect. Please try again."
        viewPassword.isPasswordField = true
        viewPassword.inputValidation = { (inputText) -> Bool in
            return !inputText.contains(" ") && inputText.count >= 2
        }
        viewPassword.onStatusChange = { () -> Void in
            self.updateSignInButtonStatus()
        }
    }
    
    private func updateSignInButtonStatus() {
        let signInText = "Sign in"
      
        if viewEmail.isValidUserInput && viewPassword.isValidUserInput {
            let signInFontAttribute = [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
            
            let signInTextRange = NSRange(location: 0, length: signInText.count)
            let signInAttributedString = NSMutableAttributedString(string: signInText)
            signInAttributedString.addAttributes(signInFontAttribute, range: signInTextRange)
            
            self.btnSignIn.setAttributedTitle(signInAttributedString, for: .normal)
            self.btnSignIn.setAttributedTitle(signInAttributedString, for: .selected)
            
            self.btnSignIn.tintColor = UIColor.sngBrandColor
            self.btnSignIn.isEnabled = true
        }
        else {
            let signInFontAttribute = [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor: UIColor.sngSecondaryColor
            ]
            
            let signInTextRange = NSRange(location: 0, length: signInText.count)
            let signInAttributedString = NSMutableAttributedString(string: signInText)
            signInAttributedString.addAttributes(signInFontAttribute, range: signInTextRange)
            
            self.btnSignIn.setAttributedTitle(signInAttributedString, for: .normal)
            self.btnSignIn.setAttributedTitle(signInAttributedString, for: .selected)
            
            self.btnSignIn.tintColor = UIColor.sngDisabledColor
            self.btnSignIn.isEnabled = false
        }
    }
    
    private func inactiveUserInputs() {
        if self.viewEmail.isActive {
            self.viewEmail.isActive = false
        }
        
        if self.viewPassword.isActive {
            self.viewPassword.isActive = false
        }
    }
    
    private func showUserInputStatusErrorMessage() {
        self.viewEmail.showStatusErrorMessage()
        self.viewPassword.showStatusErrorMessage()
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
            DispatchQueue.main.async {
                if let type = SNGErrorAlertType(rawValue: value) {
                    if self?.errorAlert == nil, type != .badRequest {
                        self?.errorAlert = SNGErrorAlertContainerView()
                        self?.errorAlert?.showAlert(with: type,
                                                    on: self!,
                                                    withDelegate: self)
                    }
                    else {
                        self?.showUserInputStatusErrorMessage()
                    }
                }
            
            }
        }
        
        self.viewModel.isLoggedIn.bind { value in
            if value {
                DispatchQueue.main.async {
                    self.coordinator?.switchToLandingPage(forAuthenticatedUser: true)
                }
            }
        }
        
    }
    
    // MARK: - Actions
    
    @objc func forgotPasswordTapped(_ sender: UITapGestureRecognizer) {
        logger.info(message: "Forgot password")
    }
    
    @objc func signUpTapped(_ sender: UITapGestureRecognizer) {
        guard let range = self.lblSignUp.text?.range(of: "Sign up")?.nsRange else {
            return
        }
        
        if sender.didTapAttributedTextInLabel(label: self.lblSignUp, inRange: range) {
            self.coordinator?.signUp()
        }
    }
    
    @objc func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        //logger.info(message: "Bacground tap!")
        self.inactiveUserInputs()
    }
}
