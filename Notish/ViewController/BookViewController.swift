//
//  BookViewController.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/20.
//

import UIKit

class BookViewController: UIViewController {

    var list: [String] = [
        "リンゴ",
        "バナナ",
        "スイカ",
        "イチゴ",
    ]
    
    private let cellId = "cellId"
    
    @IBOutlet weak var vocabularyTableView: UITableView!
    @IBOutlet weak var addButtonView: UIButton!
    @IBAction func tappedAddButton(_ sender: Any) {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            list.remove(at: indexPath.row)
            vocabularyTableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            print(list)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = vocabularyTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
}
