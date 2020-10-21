//
//  ViewController.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/15.
//

/*
ToDo
リポジトリ名
初期単語を考える
AdModの導入
リファクタリング
*/

import UIKit
import UserNotifications

class HomeViewController: UIViewController {
    
    private let cornerRadius: CGFloat = 18
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var bellImageView: UIImageView!
    @IBOutlet weak var openBookButtonView: UIButton!
    @IBOutlet weak var notificationToggleView: UIView!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBAction func switchedToggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setValue(true, forKey: "willNotice")
            noticeVocabulary()
        } else {
            UserDefaults.standard.setValue(false, forKey: "willNotice")
            cancelNotification()
        }
    }
    
    @IBAction func tappedAddButton(_ sender: Any) {
        let storyboard = self.storyboard!
        let bookViewController = storyboard.instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
        navigationController?.pushViewController(bookViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // titleViewのセットアップ
        titleView.layer.cornerRadius = 37
        
        // bellImageViewのセットアップ
        let angle = 8.69 * CGFloat.pi / 180
        let transRotate = CGAffineTransform(rotationAngle: CGFloat(angle))
        bellImageView.transform = transRotate
        
        // addButtonViewのセットアップ
        openBookButtonView.layer.cornerRadius = cornerRadius

        // notificationToggleViewのセットアップ
        notificationToggleView.layer.cornerRadius = cornerRadius
        
        if UserDefaults.standard.dictionary(forKey: "book") == nil {
            let dic: [String: String] = ["Apple": "リンゴ"]
            UserDefaults.standard.setValue(dic, forKey: "book")
            UserDefaults.standard.setValue(true, forKey: "willNotice")
            noticeVocabulary()
        }
        
        let willNotice = UserDefaults.standard.bool(forKey: "willNotice")
        if willNotice {
            toggleSwitch.isOn = true
        } else {
            toggleSwitch.isOn = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // nagivationBarを削除
        navigationController?.navigationBar.isHidden = true
    }
}



let center = UNUserNotificationCenter.current()

func noticeVocabulary() {
    // 通知登録の初期化
    center.removeAllPendingNotificationRequests()
    
    let book = UserDefaults.standard.dictionary(forKey: "book")!
    let bookWords = book.keys.shuffled()
//    print("以下の順番で通知します\n", bookWords)
    
    var count = 0
    
    if bookWords.count <= 0 {
        let identifier = "promotion"
        let content = UNMutableNotificationContent()
        content.title = "通知で覚える英単語"
        content.body = "単語帳に新しい英単語を追加しましょう！"
        content.sound = UNNotificationSound.default
//        let date = DateComponents(hour: 19)
//        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { (err) in
            if let err = err {
                print("通知を登録できませんでした\(err)")
            }
        }
        
        return
    }
    
    for hour in [16] {
        for minute in 1...60 {
            if count >= bookWords.count { count = 0 }
            let word = bookWords[count]
            let meaning = book[word] as! String
            
            let identifier = NSUUID().uuidString
            let content = UNMutableNotificationContent()
            content.title = "\(word)"
            content.body = "\(meaning)"
            content.sound = UNNotificationSound.default
            let date = DateComponents(hour: hour, minute: minute)
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)
            
            let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { (err) in
                if let err = err {
                    print("通知を登録できませんでした\(err)")
                }
            }
            
            count += 1
        }
    }
    print("通知します")
}

func cancelNotification() {
    center.removeAllPendingNotificationRequests()
    print("通知しません")
}
