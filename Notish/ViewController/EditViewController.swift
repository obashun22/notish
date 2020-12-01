//
//  EditViewController.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/21.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var meaningTextField: UITextField!
    @IBOutlet weak var addButtonView: UIButton!
    
    // performSegueは未インスタンスなのでここに値渡し
    // textFieldに入力される／この値が""かどうかで編集から遷移したかどうかを判定
    var setupWord = ""
    var setupMeaning = ""
    
    @IBAction func tappedCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedAddButtonView(_ sender: Any) {
        guard let word = wordTextField.text else { return }
        guard let meaning = meaningTextField.text else { return }
        // どちらも空でなければbookに登録
        if !word.isEmpty && !meaning.isEmpty {
            var book = UserDefaults.standard.dictionary(forKey: "book")!
            // もし編集からsetupWordに単語が渡されていたらその単語を削除
            if setupWord != "" {
                book.removeValue(forKey: setupWord)
            }
            book.updateValue(meaning, forKey: word)
            UserDefaults.standard.setValue(book, forKey: "book")
            // もし通知オン設定だったら通知を更新
            if UserDefaults.standard.bool(forKey: "willNotice") {
                noticeVocabulary()
            }
            
            // BookControllerViewのTableViewのリストを更新
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
        addButtonView.setTitleColor(.init(white: 1, alpha: 0.5), for: .disabled)
        // 編集から遷移して初期値がある場合はisEnableをtrueにする通常はfalse
        if setupWord == "" {
            addButtonView.isEnabled = false
        }
        wordTextField.text = setupWord
        meaningTextField.text = setupMeaning
    }
}

extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // キーボード以外をタップしたら入力状態解除
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        wordTextField.resignFirstResponder()
        meaningTextField.resignFirstResponder()
    }
    
    // テキストの入力が終わったときの処理
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // テキストの両端の余分な空白を取り除いて処理
        let trimmedText = textField.text?.trimmingCharacters(in: .whitespaces)
        // 空文字だったらTextFieldを空にしてあげる
        if trimmedText == "" {
            textField.text = ""
        } else {
            // 余分な空白を削除して表示
            textField.text = trimmedText
        }
        self.checkAddButtonShouldEnable()
        return true
    }
    
    // add-btnを有効にするかチェックして問題ない場合は有効にする
    private func checkAddButtonShouldEnable() {
        let word = wordTextField.text!
        let meaning = meaningTextField.text!
        print("word: '\(word)'")
        print("meaning: '\(meaning)'")
        if word != "" && meaning != "" {
            addButtonView.isEnabled = true
        } else {
            addButtonView.isEnabled = false
        }
    }
    
    // clear-btnが押された時点でadd-btnを無効にする
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        addButtonView.isEnabled = false
        return true
    }
}
