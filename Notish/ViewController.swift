//
//  ViewController.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/15.
//

/*
英単語の配列を定義
カウントで先頭から見ていく
通知オフでカウントリセット通知全削除
通知オンで配列シャッフル0から数え上げ一定時間おき
万一カウント一周しても0に初期化するようにした

To Do
単語が変わらない
map関数でずっと先まで設定？
*/

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    private var willNotice = true
    private var notificationCount = 0
    
    @IBOutlet weak var notificationHandler: UIButton!
    @IBAction func tappedNotificationHandler(_ sender: Any) {
        if willNotice { // 通知をしないように変更する
            willNotice = false
            // 通知するボタンに変更
            notificationHandler.backgroundColor = UIColor.orange
            notificationHandler.setTitle("通知する", for: .normal)
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            notificationCount = 0
            print("通知をオフにしました")
        } else { // 通知するように変更する処理
            willNotice = true
            // 通知しないボタンに変更
            notificationHandler.backgroundColor = UIColor.gray
            notificationHandler.setTitle("通知しない", for: .normal)
            noticeVocabulary()
            print("通知をオンにしました")
        }
    }
    
    @IBAction func tappedTestButton(_ sender: Any) {
        print("tappedTestButton")
        noticeVocabulary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationHandler.layer.cornerRadius = 10
        notificationHandler.backgroundColor = UIColor.gray
        notificationHandler.setTitle("通知しない", for: .normal)
        
    }
    
    private func noticeVocabulary() {
        let content = UNMutableNotificationContent()
        let identifier = NSUUID().uuidString
        content.sound = UNNotificationSound.default
        
        vocabularyKeys = vocabularyKeys.shuffled()
        if notificationCount >= vocabularyKeys.count { notificationCount = 0 }
        content.title = "\(vocabularyKeys[notificationCount])"
        content.body = "\(vocabulary[vocabularyKeys[notificationCount]] ?? "意味を取得できませんでした")"
        
        let timer = 60
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timer), repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (err) in
            if let err = err {
                print("タイマーをセットできませんでした。", err.localizedDescription)
                return
            }
            print("\(timer)秒後にタイマーをセットしました")
            self.notificationCount += 1
        }
    }
}

