//
//  ViewController.swift
//  FlyLayout
//
//  Created by Zef Houssney on 04/15/2019.
//  Copyright (c) 2019 Zef Houssney. All rights reserved.
//

import UIKit
import FlyLayout

class ViewController: UIViewController {
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
//        #colorLiteral(red: 0.10980392156862745, green: 0.23921568627450981, blue: 0.35294117647058826, alpha: 1)
//        #colorLiteral(red: 0.8705882352941177, green: 0.4588235294117647, blue: 0.12156862745098039, alpha: 1)
//        #colorLiteral(red: 0.2196078431372549, green: 0.6588235294117647, blue: 0.615686274509804, alpha: 1)
//        #colorLiteral(red: 0.33725490196078434, green: 0.3803921568627451, blue: 0.7019607843137254, alpha: 1)
//        #colorLiteral(red: 0.9215686274509803, green: 0.3215686274509804, blue: 0.5254901960784314, alpha: 1)
//        #colorLiteral(red: 0.1843137254901961, green: 0.5254901960784314, blue: 0.5882352941176471, alpha: 1)


        let a = UIView(background: #colorLiteral(red: 0.8, green: 0.12156862745098039, blue: 0.10196078431372549, alpha: 1))
        let b = UIView(background: #colorLiteral(red: 0.12156862745098039, green: 0.615686274509804, blue: 0.3333333333333333, alpha: 1))
        let c = UIView(background: #colorLiteral(red: 0.4745098039215686, green: 0.2901960784313726, blue: 0.8117647058823529, alpha: 1))
        let d = UIView(background: #colorLiteral(red: 0.15294117647058825, green: 0.4745098039215686, blue: 0.7411764705882353, alpha: 1))
        let e = UIView(background: #colorLiteral(red: 0.9490196078431372, green: 0.8156862745098039, blue: 0.1411764705882353, alpha: 1))

        Layout.toSafeAreas {
            view.addSubview(a, layout: .center, .width(180), .height(180))
            view.addSubview(b, layout: .pin(top: 10, leading: 10), .width(100), .height(100))
            view.addSubview(c, layout: .pin(top: 10, trailing: 10), .width(100), .height(100))
            view.addSubview(d, layout: .pin(bottom: 10, leading: 10), .width(100), .height(100))
            view.addSubview(e, layout: .pin(bottom: 10, trailing: 10), .width(100), .height(100))
        }
        e.addSubview(UIView(background: #colorLiteral(red: 0.07058823529411765, green: 0.1568627450980392, blue: 0.22745098039215686, alpha: 1)), layout: .pin(10))

        let amount: CGFloat = 8
        view.addSubview(UILabel(text: "Before"), layout: .centerY, .before(a, by: amount))
        view.addSubview(UILabel(text: "After"), layout: .centerY, .after(a, by: amount))
        view.addSubview(UILabel(text: "Above"), layout: .centerX, .above(a, by: amount))
        view.addSubview(UILabel(text: "Below"), layout: .centerX, .below(a, by: amount))

        // might change these to an API that passes the anchor directly like this:
//        view.addSubview(UILabel(text: "Leading"), layout: .align(to: a.leadingAnchor, by: amount), .centerY)
        view.addSubview(UILabel(text: "Leading"), layout: .centerY, .align(.leading, to: a, by: amount))
        view.addSubview(UILabel(text: "Trailing"), layout: .centerY, .align(.trailing, to: a, by: amount))
        view.addSubview(UILabel(text: "Top"), layout: .centerX, .align(.top, to: a, by: amount))
        view.addSubview(UILabel(text: "Bottom"), layout: .centerX, .align(.bottom, to: a, by: amount))
    }
}

extension UIView {
    convenience init(background: UIColor) {
        self.init()
        self.backgroundColor = background
    }
}

extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
        textColor = .black
    }
}
