//
//  ViewController.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/15.
//

/*
# ToDo
- AdModの導入
- 1hおきだと19単語以上で通知されないものがでてくる
 -> 18個未満か通知間隔・許可切替または単語追加・編集で通知内容が変わるので実質解決
# userDefaultsのkeyと型
- book: Dic; 単語情報
- willNotice: Bool; 通知の許可
- interval: Int; 30 min/1 hour
*/

import UIKit
import GoogleMobileAds
import UserNotifications

private let userDefaults = UserDefaults.standard

class HomeViewController: UIViewController {
    
    private let cornerRadius: CGFloat = 18
    
    @IBOutlet weak var showBookButton: UIView!
    @IBOutlet weak var notificationSettingView: UIView!
    @IBOutlet weak var toggleNotificationSwitch: UISwitch!
    @IBOutlet weak var intervalSettingView: UIView!
    @IBOutlet weak var toggleIntervalSwitch: UISegmentedControl!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBAction func switchedToggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            userDefaults.setValue(true, forKey: "willNotice")
            noticeVocabulary()
        } else {
            userDefaults.setValue(false, forKey: "willNotice")
            cancelNotification()
        }
    }
    
    @IBAction func tappedIntervalSwitch(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            userDefaults.setValue(1, forKey: "interval")
//            print("intervalを1にセットしました")
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            if (userDefaults.bool(forKey: "willNotice")) {
                noticeVocabulary()
            }
        case 1:
            userDefaults.setValue(30, forKey: "interval")
//            print("intervalを30にセットしました")
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            if (userDefaults.bool(forKey: "willNotice")) {
                noticeVocabulary()
            }
        default:
            print("通知間隔を設定できませんでした")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstTimeSetup()
        self.setupView()
        self.addTapGesture()
        self.setupBannerView()
    }
    
    private func setupBannerView() {
        let debugID = Bundle.main.object(forInfoDictionaryKey: "AdMob Unit ID Debug") as! String
        let releaseID = Bundle.main.object(forInfoDictionaryKey: "AdMob Unit ID Release") as! String
        // デモ広告
//        bannerView.adUnitID = debugID
        // 本番広告
        bannerView.adUnitID = releaseID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func addTapGesture() {
        // タップジェスチャーを作成します。
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        // シングルタップで反応するように設定します。
        singleTapGesture.numberOfTapsRequired = 1
        // ビューにジェスチャーを設定します。
        self.showBookButton.addGestureRecognizer(singleTapGesture)
    }
    
    @objc private func singleTap(_ gesture: UITapGestureRecognizer) {
        // Book画面を表示
        let storyboard = self.storyboard!
        let bookViewController = storyboard.instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
        navigationController?.pushViewController(bookViewController, animated: true)
    }
    
    // 初回起動時にbookとwillNoticeプロパティを作成／通知をオンに
    private func firstTimeSetup() {
        if userDefaults.dictionary(forKey: "book") == nil {
            let dic: [String: String] = [
                "prospect": "可能性・見込み",
                "assume": "〜だと考える",
                "principle": "原理・主義",
                "depend on": "〜次第である",
            ]
            userDefaults.setValue(dic, forKey: "book")
            userDefaults.setValue(true, forKey: "willNotice")
            userDefaults.setValue(30, forKey: "interval")
            
            noticeVocabulary()
        }
    }
    
    // 各種Viewのセットアップ
    private func setupView() {
        // 各カードのセットアップ
        showBookButton.layer.cornerRadius = cornerRadius
        notificationSettingView.layer.cornerRadius = cornerRadius
        intervalSettingView.layer.cornerRadius = cornerRadius
        toggleIntervalSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        // SwitchViewの切り替え
        let willNotice = userDefaults.bool(forKey: "willNotice")
        if willNotice {
            toggleNotificationSwitch.isOn = true
        } else {
            toggleNotificationSwitch.isOn = false
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
    
    let book = userDefaults.dictionary(forKey: "book")!
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
    
    let interval = userDefaults.integer(forKey: "interval")
    if interval == 30 {
        // 6時から24時まで毎日30分おきにbookからランダムに通知する
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
    } else if interval == 1 {
        // 6時から24時まで毎日1時間おきにbookからランダムに通知する
        for hour in 6...23 {
            for minute in [0] {
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
    } else {
        print("通知を登録できませんでした")
    }
    print("通知します")
}

// すべての既存の通知を削除
func cancelNotification() {
    center.removeAllPendingNotificationRequests()
    print("通知しません")
}

// 通知機能確認のための即通知関数
func checkNotification() {
    let content = UNMutableNotificationContent()
    content.title = "テスト通知"
    content.body = "Hoge"
    content.sound = UNNotificationSound.default
    let request = UNNotificationRequest.init(identifier: "testNotification", content: content, trigger: nil)
    center.add(request) { (err) in
        if let err = err {
            print("通知を登録できませんでした\(err)")
        }
    }
}
