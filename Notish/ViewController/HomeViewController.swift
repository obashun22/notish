//
//  ViewController.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/15.
//

/*
ToDo
AdModの導入
UserDefaults.standard
- book: Dic; 単語情報
- willNotice: Bool; 通知の許可
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
        firstTimeSetup()
        setupView()
    }
    
    // 初回起動時にbookとwillNoticeプロパティを作成／通知をオンに
    private func firstTimeSetup() {
        if UserDefaults.standard.dictionary(forKey: "book") == nil {
            let dic: [String: String] = [
                "prospect": "可能性・見込み",
                "assume": "〜だと考える",
                "principle": "原理・主義",
                "depend on": "〜次第である",
            ]
            UserDefaults.standard.setValue(dic, forKey: "book")
            UserDefaults.standard.setValue(true, forKey: "willNotice")
            
            noticeVocabulary()
        }
    }
    
    // 各種Viewのセットアップ
    private func setupView() {
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
        
        // SwitchViewの切り替え
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

// MARK: 通知処理

// アプリの通知を管理するNotificationCenterをインスタンス化
let center = UNUserNotificationCenter.current()

// 既存の通知を削除して新しく通知をセットする関数
func noticeVocabulary() {
    // 既存の通知の削除
    center.removeAllPendingNotificationRequests()
    
    let book = UserDefaults.standard.dictionary(forKey: "book")!
    let bookWords = book.keys.shuffled()
//    print("以下の順番で通知します\n", bookWords)
    
    // 通知登録回数を数える変数
    var count = 0
    
    // bookに単語が登録されていなかったら催促のメッセージを19時に通知
    if bookWords.count <= 0 {
        let identifier = "promotion"
        let content = UNMutableNotificationContent()
        content.title = "通知で覚える英単語"
        content.body = "単語帳に新しい英単語を追加しましょう！"
        content.sound = UNNotificationSound.default
        let date = DateComponents(hour: 19)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { (err) in
            if let err = err {
                print("通知を登録できませんでした\(err)")
            }
        }
        return
    }
    
    // 朝6時から夜12時まで毎日30分おきにbookからランダムに通知する
    for hour in 6...23 {
        for minute in [0, 30] {
            // bookをまわりきったらまたはじめから通知
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

// すべての既存の通知を削除
func cancelNotification() {
    center.removeAllPendingNotificationRequests()
    print("通知しません")
}
