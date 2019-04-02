//
//  UIKit+Extensions.swift
//  FlyLayout
//
//  Created by Zef Houssney on 3/26/19.
//  Copyright © 2019 Zef Houssney. All rights reserved.
//

import UIKit

extension UIView {
    func addSubview(_ view: UIView, autolayout: Bool) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = !autolayout
    }

    @discardableResult
    func addSubview(_ view: UIView, layout layouts: Layout...) -> [NSLayoutConstraint] {
        return addSubview(view, layout: layouts)
    }

    @discardableResult
    func addSubview(_ view: UIView, layout layouts: [Layout]) -> [NSLayoutConstraint] {
        addSubview(view, autolayout: true)
        return view.apply(layout: layouts, with: self)
    }

    @discardableResult
    func apply(layout layouts: Layout..., with view: UIView) -> [NSLayoutConstraint] {
        return apply(layout: layouts, with: view)
    }

    @discardableResult
    func apply(layout layouts: [Layout], with view: UIView) -> [NSLayoutConstraint] {
        return layouts.flatMap { layout in
            layout.apply(to: self, with: view)
        }
    }
}

extension Array where Element == NSLayoutConstraint {
    func activate() {
        setActive(true)
    }
    func deactivate() {
        setActive(false)
    }

    func setActive(_ isActive: Bool) {
        if isActive {
            NSLayoutConstraint.activate(self)
        } else {
            NSLayoutConstraint.deactivate(self)
        }
    }
}

