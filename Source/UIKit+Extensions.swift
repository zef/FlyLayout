//
//  UIKit+Extensions.swift
//  FlyLayout
//
//  Created by Zef Houssney on 3/26/19.
//  Copyright © 2019 Zef Houssney. All rights reserved.
//

import UIKit

public extension UIView {
    var autoLayout: Bool {
        get { return translatesAutoresizingMaskIntoConstraints }
        set { translatesAutoresizingMaskIntoConstraints = !autoLayout }
    }

    func addSubview(_ view: UIView, autoLayout: Bool) {
        view.autoLayout = autoLayout
        addSubview(view)
    }

    func insertSubview(_ view: UIView, at index: Int, autoLayout: Bool) {
        view.autoLayout = autoLayout
        insertSubview(view, at: index)
    }

    func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView, autoLayout: Bool) {
        view.autoLayout = autoLayout
        insertSubview(view, aboveSubview: siblingSubview)
    }

    func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView, autoLayout: Bool) {
        view.autoLayout = autoLayout
        insertSubview(view,  belowSubview: siblingSubview)
    }


    // MARK: Apply layouts after views have been added
    //
    // The following functions in this extension come in pairs:
    //
    // - The `Layout...` variant uses a Variadic Parameter to allow you to pass in
    //   a list of layouts without providing the square brackets for an array.
    //
    // - The `[Layout]` variant allows you to store and pass around an actual Array<Layout>,
    //   enabling more powerful and dynamic usage, if needed.
    //   A good use of this would be to store a commonly used or complex layout configuration
    //   and apply it by passing in an array, instead of duplicating the configuration inline
    //
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

    // MARK: Applying layouts while adding
    //
    // These functions mirror UIView's four functions for adding subviews,
    // allowing you to always apply your layouts at the time of view insertion:
    //
    // - addSubview(myView, layout: .pin(10))
    // - insertSubview(myView, at: 0, layout: .fill)
    // - insertSubview(myView, aboveSubview: otherView, layout: .centerX, .width(60), .height(100))
    // - insertSubview(myView, belowSubview: otherView, layout: .center(y: -40), .fillX)
    //
    @discardableResult
    func addSubview(_ view: UIView, layout layouts: Layout...) -> [NSLayoutConstraint] {
        return addSubview(view, layout: layouts)
    }
    @discardableResult
    func addSubview(_ view: UIView, layout layouts: [Layout]) -> [NSLayoutConstraint] {
        addSubview(view, autoLayout: true)
        return view.apply(layout: layouts, with: self)
    }

    @discardableResult
    func insertSubview(_ view: UIView, at index: Int, layout layouts: Layout...) -> [NSLayoutConstraint] {
        return insertSubview(view, at: index, layout: layouts)
    }
    @discardableResult
    func insertSubview(_ view: UIView, at index: Int, layout layouts: [Layout]) -> [NSLayoutConstraint] {
        insertSubview(view, at: index, autoLayout: true)
        return view.apply(layout: layouts, with: self)
    }

    @discardableResult
    func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView, layout layouts: Layout...) -> [NSLayoutConstraint] {
        return insertSubview(view, aboveSubview: siblingSubview, layout: layouts)
    }
    @discardableResult
    func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView, layout layouts: [Layout]) -> [NSLayoutConstraint] {
        insertSubview(view, aboveSubview: siblingSubview, autoLayout: true)
        return view.apply(layout: layouts, with: self)
    }

    @discardableResult
    func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView, layout layouts: Layout...) -> [NSLayoutConstraint] {
        return insertSubview(view, belowSubview: siblingSubview, layout: layouts)
    }
    @discardableResult
    func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView, layout layouts: [Layout]) -> [NSLayoutConstraint] {
        insertSubview(view, belowSubview: siblingSubview, autoLayout: true)
        return view.apply(layout: layouts, with: self)
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

