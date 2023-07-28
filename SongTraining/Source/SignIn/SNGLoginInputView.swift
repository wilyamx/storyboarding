//
//  SNGLoginInputView.swift
//  SongTraining
//
//  Created by William Rena on 7/3/23.
//

import UIKit

enum SNGLoginInputState {
    case invalid
    case valid
}

class SNGLoginInputView: UIView, WSRNibloadable {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblFooter: UILabel!
    @IBOutlet weak var btnInput: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var txtInput: UITextField!
    
    let DEFAULT_INPUT_LABEL = "Input label"
    let DEFAULT_ERROR_LABEL = "Message error here"
    
    let DEFAULT_INPUT_RIGHT_DISTANCE: CGFloat = 0
    let DEFAULT_INPUT_BUTTON_RIGHT_DISTANCE: CGFloat = 10.0
    
    let DEFAULT_INPUT_RIGHT_DISTANCE_2: CGFloat = 30.0
    let DEFAULT_INPUT_BUTTON_RIGHT_DISTANCE_2: CGFloat = 40.0
    
    @IBOutlet weak var textInputRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputButtonRightConstraint: NSLayoutConstraint!
    
    public var isActive: Bool = false {
        didSet {
            if isActive {
                if let text = self.txtInput.text {
                    self.updateTextInput(text: text)
                }
            }
            else {
                self.resetUserInput()
            }
        }
    }
    
    public var isValidUserInput: Bool = false
    public var validationErrorMessage: String?
    public var statusErrorMessage: String?
    public var inputLabel: String = "Input label" {
        didSet {
            self.lblHeader.text = inputLabel
        }
    }
    
    public var inputValidation: ((_ inputText: String) -> Bool)? = nil
    public var onStatusChange: (() -> Void)? = nil
    
    @IBAction func passwordAction(_ sender: Any) {
        self.txtInput.isSecureTextEntry.toggle()
        
        let imageName = self.txtInput.isSecureTextEntry ? "eye" : "eye.slash"
        let iconImage = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)

        btnInput.tintColor = .black
        btnInput.setImage(iconImage, for: .normal)
        btnInput.setImage(iconImage, for: .selected)
    }
    
    public var isPasswordField: Bool = false {
        didSet {
            self.txtInput.isSecureTextEntry = isPasswordField
            self.btnInput.isHidden = !isPasswordField
            
            if isPasswordField {
                let iconImage = UIImage(systemName: "eye")?.withRenderingMode(.alwaysTemplate)
                btnInput.tintColor = .black
                btnInput.setImage(iconImage, for: .normal)
                btnInput.setImage(iconImage, for: .selected)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = SNGLoginInputView.viewFromNib2(owner: self)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.frame = bounds
        addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        self.stackView.backgroundColor = .clear
        
        self.lblHeader.text = DEFAULT_INPUT_LABEL
        self.lblHeader.textColor = .secondaryLabel
        
        self.lblFooter.text = DEFAULT_ERROR_LABEL
        self.lblFooter.textColor = UIColor.sngErrorColor
        self.lblFooter.textColor = .clear
        
        self.isPasswordField = false
        
        let iconImage = UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate)
        self.btnInfo.setImage(iconImage, for: .normal)
        self.btnInfo.setImage(iconImage, for: .selected)
        self.btnInfo.setImage(iconImage, for: .highlighted)
        self.btnInfo.tintColor = UIColor.sngErrorColor
        self.btnInfo.isUserInteractionEnabled = false
        
        self.txtInput.delegate = self
        self.txtInput.autocorrectionType = .no
        self.txtInput.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.displayErrorIcon(visible: false)
    }

    private func resetUserInput() {
        self.txtInput.resignFirstResponder()
        
        guard let text = self.txtInput.text, text.count > 0 else {
            self.lblFooter.textColor = .clear
            displayErrorIcon(visible: false)
            return
        }
        
        guard let isValidUserInput = self.inputValidation,
              let text = self.txtInput.text,
              isValidUserInput(text) else { return }
        
        self.txtInput.layer.borderWidth = 0
        self.txtInput.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func displayErrorIcon(visible: Bool) {
        if visible {
            self.textInputRightConstraint.constant = self.DEFAULT_INPUT_RIGHT_DISTANCE_2
            self.inputButtonRightConstraint.constant = self.DEFAULT_INPUT_BUTTON_RIGHT_DISTANCE_2
            self.btnInfo.isHidden = false
        }
        else {
            self.textInputRightConstraint.constant = self.DEFAULT_INPUT_RIGHT_DISTANCE
            self.inputButtonRightConstraint.constant = self.DEFAULT_INPUT_BUTTON_RIGHT_DISTANCE
            self.btnInfo.isHidden = true
        }
    }
    
    private func updateErrorDisplay(isValidInput: Bool) {
        if isValidInput {
            self.lblFooter.textColor = .clear
            self.btnInfo.isHidden = true
            
            self.btnInfo.tintColor = UIColor.sngSuccessColor
            let iconImage = UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate)
            self.btnInfo.setImage(iconImage, for: .normal)
            self.btnInfo.setImage(iconImage, for: .selected)
            self.btnInfo.setImage(iconImage, for: .highlighted)
            
            displayErrorIcon(visible: true)
        }
        else {
            if let text = self.validationErrorMessage {
                self.lblFooter.textColor = UIColor.sngErrorColor
                self.lblFooter.text = text
                
                self.btnInfo.isHidden = false
                self.btnInfo.tintColor = UIColor.sngErrorColor
                let iconImage = UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate)
                self.btnInfo.setImage(iconImage, for: .normal)
                self.btnInfo.setImage(iconImage, for: .selected)
                self.btnInfo.setImage(iconImage, for: .highlighted)
                
                displayErrorIcon(visible: true)
            }
        }
    }
    
    // MARK: - Public Methods
    
    public func updateTextInput(text: String) {
        guard text.count > 0 else { return }
        
        if let isValidUserInput = self.inputValidation {
            let isValid = isValidUserInput(text)
            self.isValidUserInput = isValid
            self.updateErrorDisplay(isValidInput: isValid)
            
            self.txtInput.layer.borderColor = isValid ? UIColor.sngSuccessColor.cgColor : UIColor.sngErrorColor.cgColor
            self.txtInput.layer.borderWidth = 1.0
            self.txtInput.layer.cornerRadius = 5.0
        }
    }
    
    public func getInputText() -> String {
        if let text = self.txtInput.text {
            return text
        }
        return ""
    }
    
    public func showStatusErrorMessage() {
        if let text = self.statusErrorMessage {
            self.lblFooter.text = text
            self.lblFooter.textColor = .sngErrorColor
            
            self.displayErrorIcon(visible: true)
            
            self.txtInput.layer.borderColor = UIColor.sngErrorColor.cgColor
            self.txtInput.layer.borderWidth = 1.0
            self.txtInput.layer.cornerRadius = 5.0
            
            self.lblFooter.textColor = UIColor.sngErrorColor
            self.lblFooter.text = text
            
            self.btnInfo.isHidden = false
            self.btnInfo.tintColor = UIColor.sngErrorColor
            let iconImage = UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate)
            self.btnInfo.setImage(iconImage, for: .normal)
            self.btnInfo.setImage(iconImage, for: .selected)
            self.btnInfo.setImage(iconImage, for: .highlighted)
        }
    }
}

extension SNGLoginInputView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let updatedString = oldText.replacingCharacters(in: Range(range, in: oldText)!, with: string)
        
        // this check whether the backspace key is pressed
        if (range.length == 1) {
            if updatedString.count == 0 {
                DispatchQueue.main.async {
                    textField.layer.borderColor = UIColor.black.cgColor
                    textField.layer.borderWidth = 1
                    textField.layer.cornerRadius = 5.0
                    
                    self.lblFooter.textColor = .clear
                    self.displayErrorIcon(visible: false)
                }
                
                if let statusChange = self.onStatusChange {
                    self.isValidUserInput = false
                    statusChange()
                }
                return true
            }
        }
        
        self.updateTextInput(text: updatedString)
                
        if let statusChange = self.onStatusChange {
            statusChange()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isActive = true
        
        if textField.text?.count == 0  {
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 1.0
            textField.layer.cornerRadius = 5.0
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.isActive = false
        
        if textField.text?.count == 0  {
            textField.layer.borderWidth = 0
            textField.layer.cornerRadius = 5.0
        }
    }
    
}

