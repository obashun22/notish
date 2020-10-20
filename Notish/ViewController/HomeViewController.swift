//
//  ViewController.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/15.
//

/*
ToDo
Notification機能
データ保存
編集機能実装
アイコンの再編集
AdModの導入
*/

import UIKit
import UserNotifications

class HomeViewController: UIViewController {
    
    private let cornerRadius: CGFloat = 18
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var bellImageView: UIImageView!
    @IBOutlet weak var openBookButtonView: UIButton!
    @IBOutlet weak var notificationToggleView: UIView!
    @IBOutlet weak var notificationToggleSwitch: UISwitch!
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // nagivationBarを削除
        navigationController?.navigationBar.isHidden = true
    }
    
}

