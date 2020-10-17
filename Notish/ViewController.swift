//
//  ViewController.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/15.
//

/*
*/

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    private var willNotice = true
    private var willNoticeVocabulary: [String: String] = [
        "apple": "リンゴ",
        "banana": "バナナ",
        "pantsu": "パンツ",
        "tanaka": "田中",
        "horita": "堀田",
        "canada": "カナダ",
    ]
    private let center = UNUserNotificationCenter.current()
    
    @IBOutlet weak var notificationHandler: UIButton!
    @IBAction func tappedNotificationHandler(_ sender: Any) {
        if willNotice {
            // 通知をしないように変更
            willNotice = false
            
            // 通知するボタンに変更
            notificationHandler.backgroundColor = UIColor.orange
            notificationHandler.setTitle("通知する", for: .normal)
            center.removeAllPendingNotificationRequests()
            print("通知予約を削除しました")
            
            print("通知をオフにしました")
        } else {
            // 通知するように変更する処理
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
        let keys = [String](willNoticeVocabulary.keys).shuffled()
        let word = keys[0]
        let meaning = willNoticeVocabulary[word]!
        let content = UNMutableNotificationContent()
        content.title = "\(word)"
        content.body = "\(meaning)"
        content.sound = UNNotificationSound.default
        
        let identifier = NSUUID().uuidString
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (err) in
            if let err = err {
                print("通知の登録に失敗しました\(err)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationHandler.layer.cornerRadius = 10
        notificationHandler.backgroundColor = UIColor.gray
        notificationHandler.setTitle("通知しない", for: .normal)
        noticeVocabulary()
    }
    
    private func noticeVocabulary() {
        let keys = [String](willNoticeVocabulary.keys).shuffled()
        var count = 0
        for hour in 6...23 {
            for minute in [0, 30] {
                if count >= keys.count { count = 0 }
                let word = keys[count]
                let meaning = willNoticeVocabulary[word]!
                let content = UNMutableNotificationContent()
                content.title = "\(word)"
                content.body = "\(meaning)"
                content.sound = UNNotificationSound.default
                
                let identifier = NSUUID().uuidString
                let date = DateComponents(hour: hour, minute: minute)
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
                center.add(request) { (err) in
                    if let err = err {
                        print("通知の登録に失敗しました\(err)")
                    }
                }
                print("通知を登録しました\(hour)時\(minute)")
                count += 1
            }
        }
    }
}

