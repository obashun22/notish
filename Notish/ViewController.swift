//
//  ViewController.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/15.
//

import UIKit

class ViewController: UIViewController {
    
    private var willNotice = true
    
    @IBOutlet weak var notificationHandler: UIButton!
    @IBAction func tappedNotificationHandler(_ sender: Any) {
        if willNotice {
            willNotice = false
            // 次回ここから
            // notificationHandler.backgroundColor = UIColor
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationHandler.layer.cornerRadius = 10
    }

    
    
}

