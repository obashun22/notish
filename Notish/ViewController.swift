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
    
    @IBOutlet weak var bellImageView: UIImageView!
    @IBOutlet weak var addButtonView: UIButton!
    @IBOutlet weak var notificationToggleView: UIView!
    @IBOutlet weak var notificationToggleSwitch: UISwitch!
    @IBAction func tappedAddButton(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // bellImageViewのセットアップ
        let angle = 8.69 * CGFloat.pi / 180
        let transRotate = CGAffineTransform(rotationAngle: CGFloat(angle))
        bellImageView.transform = transRotate
        
        // addButtonViewのセットアップ
        addButtonView.layer.cornerRadius = 18
        
        // notificationToggleViewのセットアップ
        notificationToggleView.layer.cornerRadius = 18
        
        
    }
}

