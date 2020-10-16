//
//  UIColor.swift
//  Notish
//
//  Created by 大羽俊輔 on 2020/10/15.
//

import UIKit

extension UIColor {

    @available(iOS 11.0, *)
    public /*not inherited*/ convenience init?(named name: String) // load from main bundle

    @available(iOS 11.0, *)
    public /*not inherited*/ convenience init?(named name: String, in bundle: Bundle?, compatibleWith traitCollection: UITraitCollection?)
}
