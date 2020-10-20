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
        let word = wordTextField.text ?? ""
        let meaning = meaningTextField.text ?? ""
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
            
            // データを変更する処理
            
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
}
