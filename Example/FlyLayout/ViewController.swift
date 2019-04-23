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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //        guard let view = view else { return }

        let a = UIView(background: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
        let b = UIView(background: #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1))
        let c = UIView(background: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
        let d = UIView(background: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
        let e = UIView(background: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))

        view.addSubview(a, layout: .center, .width(180), .height(180))
        view.addSubview(b, layout: .pin(top: 10, leading: 10, safe: true), .width(100), .height(100))
        view.addSubview(c, layout: .pin(top: 10, trailing: 10, safe: true), .width(100), .height(100))
        view.addSubview(d, layout: .pin(bottom: 10, leading: 10, safe: true), .width(100), .height(100))
        view.addSubview(e, layout: .pin(bottom: 10, trailing: 10, safe: true), .width(100), .height(100))

        let amount: CGFloat = 8
        view.addSubview(UILabel(text: "Before"), layout: .before(a, by: amount), .centerY)
        view.addSubview(UILabel(text: "After"), layout: .after(a, by: amount), .centerY)
        view.addSubview(UILabel(text: "Above"), layout: .above(a, by: amount), .centerX)
        view.addSubview(UILabel(text: "Below"), layout: .below(a, by: amount), .centerX)

        view.addSubview(UILabel(text: "Leading"), layout: .align(.leading, to: a, by: amount), .centerY)
        view.addSubview(UILabel(text: "Trailing"), layout: .align(.trailing, to: a, by: amount), .centerY)
        view.addSubview(UILabel(text: "Top"), layout: .align(.top, to: a, by: amount), .centerX)
        view.addSubview(UILabel(text: "Bottom"), layout: .align(.bottom, to: a, by: amount), .centerX)
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
