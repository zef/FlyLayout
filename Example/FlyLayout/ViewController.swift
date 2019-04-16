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

        let a = UIView()
        a.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)

        let b = UIView()
        b.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)

        let c = UIView()
        c.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)

        let d = UIView()
        d.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)

        let e = UIView()
        e.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)

        view.addSubview(a, layout: .center, .width(100), .height(100))
        view.addSubview(b, layout: .pin(top: 10, leading: 10, safe: true), .width(100), .height(100))
        view.addSubview(c, layout: .pin(top: 10, trailing: 10, safe: true), .width(100), .height(100))
        view.addSubview(d, layout: .pin(bottom: 10, leading: 10, safe: true), .width(100), .height(100))
        view.addSubview(e, layout: .pin(bottom: 10, trailing: 10, safe: true), .width(100), .height(100))

        let labelA = UILabel()
        labelA.text = "Test"
        labelA.textColor = .white

        view.addSubview(labelA, layout: .align(.leading, to: a), .centerY)
    }
}
