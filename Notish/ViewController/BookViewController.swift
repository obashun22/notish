//
//  BookViewController.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/20.
//

import UIKit

class BookViewController: UIViewController {
    
    private let cellId = "cellId"
    
    @IBOutlet weak var vocabularyTableView: UITableView!
    @IBOutlet weak var addButtonView: UIButton!
    @IBAction func tappedAddButton(_ sender: Any) {
        let wordCount = UserDefaults.standard.dictionary(forKey: "book")!.count
        // 既に36単語登録されていたらアラートを出して単語を削除してもらう
        if wordCount >= 36 {
            let alert = UIAlertController(title: "単語帳がいっぱいです", message: "単語をスワイプして削除してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        // 編集画面に遷移
        performSegue(withIdentifier: "toEditViewController", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vocabularyTableView.delegate = self
        vocabularyTableView.dataSource = self
        
        addButtonView.layer.cornerRadius = addButtonView.frame.width / 2
        vocabularyTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // navigationBarを表示
        navigationController?.navigationBar.isHidden = false
        // navigationBarの文字色変更
        navigationController?.navigationBar.tintColor = UIColor.white
        // navigationBarのタイトル設定
        navigationItem.title = "単語帳"
        // navigationBarのフォント指定
        navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]
    }
}



extension BookViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // SectionTitleを自作して描画（デフォルトだとFontStyleとかいじれないので）
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 18, y: 4, width: self.view.frame.width, height: 20)
        myLabel.font = .systemFont(ofSize: 13.0, weight: UIFont.Weight.regular)
        myLabel.textColor = .rgb(red: 120, green: 120, blue: 120)
        myLabel.text = "最大36単語まで登録可能"

        let headerView = UIView()
        headerView.backgroundColor = .systemGray6
        headerView.addSubview(myLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let book = UserDefaults.standard.dictionary(forKey: "book")
        return book!.keys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "編集") { (_, _, completionHandler) in
            self.editVocabulary(index: indexPath.row)
            print("tapped edit cell")
            completionHandler(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (_, _, completionHandler) in
            print("tapped delete action")
            self.deleteCell(indexPath: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func editVocabulary(index: Int) {
        self.performSegue(withIdentifier: "toEditViewController", sender: index)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditViewController" {
            let nextVC = segue.destination as! EditViewController
            // タップされた行番号を取得
            guard let index = sender as? Int else { return }
            // bookから単語と意味を取得
            let book = UserDefaults.standard.dictionary(forKey: "book")!
            // bookWordsは大文字小文字区別せずにa, z順で並べ替え
            let bookWords = book.keys.sorted { (word1, word2) -> Bool in
                return word1.lowercased() < word2.lowercased()
            }
            let word = bookWords[index]
            let meaning = book[bookWords[index]] as! String
            
            nextVC.setupWord = word
            nextVC.setupMeaning = meaning
        }
    }
    
    func deleteCell(indexPath: IndexPath) {
        // 先にbookから単語と意味を削除
        var book = UserDefaults.standard.dictionary(forKey: "book")!
        // bookWordsは大文字小文字区別せずにa, z順で並べ替え
        let bookWords = book.keys.sorted { (word1, word2) -> Bool in
            return word1.lowercased() < word2.lowercased()
        }
        let word = bookWords[indexPath.row]
        book.removeValue(forKey: word)
        UserDefaults.standard.setValue(book, forKey: "book")
        // TableViewからも削除
        vocabularyTableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        print("\(word)を削除しました")
        // もし通知オン設定だったら削除後のbookで通知するよう再設定
        if UserDefaults.standard.bool(forKey: "willNotice") {
            noticeVocabulary()
        }
    }
//    
//    // 削除されたときの処理
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCell.EditingStyle.delete {
//            // 先にbookから単語と意味を削除
//            var book = UserDefaults.standard.dictionary(forKey: "book")!
//            // bookWordsは大文字小文字区別せずにa, z順で並べ替え
//            let bookWords = book.keys.sorted { (word1, word2) -> Bool in
//                return word1.lowercased() < word2.lowercased()
//            }
//            let word = bookWords[indexPath.row]
//            book.removeValue(forKey: word)
//            UserDefaults.standard.setValue(book, forKey: "book")
//            // TableViewからも削除
//            vocabularyTableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
//            print("\(word)を削除しました")
//            // もじ通知オン設定だったら削除後のbookで通知するよう再設定
//            if UserDefaults.standard.bool(forKey: "willNotice") {
//                noticeVocabulary()
//            }
//        }
//    }
    
    
    // cellを作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = vocabularyTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        // bookWordsは大文字小文字区別せずにa, z順で並べ替え
        let book = UserDefaults.standard.dictionary(forKey: "book")!
        let bookWords = book.keys.sorted { (word1, word2) -> Bool in
            return word1.lowercased() < word2.lowercased()
        }
        let word = bookWords[indexPath.row]
        let meaning = book[word] as! String
        cell.textLabel?.text = word
        cell.detailTextLabel?.text = meaning
        return cell
    }
}
