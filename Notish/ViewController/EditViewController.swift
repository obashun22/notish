//
//  EditViewController.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/21.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var wordAlertLabel: UILabel!
    @IBOutlet weak var meaningTextField: UITextField!
    @IBOutlet weak var meaningAlertLabel: UILabel!
    @IBOutlet weak var addButtonView: UIButton!
    
    @IBAction func tappedCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedAddButtonView(_ sender: Any) {
        guard let word = wordTextField.text else { return }
        guard let meaning = meaningTextField.text else { return }
        if word == "" {
            wordAlertLabel.isHidden = false
        } else {
            wordAlertLabel.isHidden = true
        }
        if meaning == ""{
            meaningAlertLabel.isHidden = false
        } else {
            meaningAlertLabel.isHidden = true
        }
        if !word.isEmpty && !meaning.isEmpty {
            var book = UserDefaults.standard.dictionary(forKey: "book")!
            book.updateValue(meaning, forKey: word)
            UserDefaults.standard.setValue(book, forKey: "book")
            if UserDefaults.standard.bool(forKey: "willNotice") {
                noticeVocabulary()
            }
            
            let preNC = self.presentingViewController as! UINavigationController
            let preVC = preNC.viewControllers[preNC.viewControllers.count - 1] as! BookViewController
            preVC.vocabularyTableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordTextField.delegate = self
        meaningTextField.delegate = self
        addButtonView.layer.cornerRadius = 18
    }
    
}

extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        wordTextField.resignFirstResponder()
        meaningTextField.resignFirstResponder()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let trimmedText = textField.text?.trimmingCharacters(in: .whitespaces)
        if trimmedText == "" {
            textField.text = ""
        } else {
            textField.text = trimmedText
        }
        return true
    }
}
