//
//  Layout.swift
//  FlyLayout
//
//  Created by Zef Houssney on 3/26/19.
//  Copyright © 2019 Zef Houssney. All rights reserved.
//

import UIKit

protocol ConstraintProvider {
    func constraints(for view: UIView, referencing secondView: UIView) -> [NSLayoutConstraint]
    var customViewReference: UIView? { get }
}
extension ConstraintProvider {
    var customViewReference: UIView? { return nil }
}

struct Pin: ConstraintProvider {
    let top: CGFloat?
    let bottom: CGFloat?
    let leading: CGFloat?
    let trailing: CGFloat?
    let safe: Bool

    init(top: CGFloat? = nil, bottom: CGFloat? = nil, leading: CGFloat? = nil, trailing: CGFloat? = nil, safe: Bool) {
        self.top = top
        if let bottom = bottom {
            self.bottom = -bottom
        } else {
            self.bottom = nil
        }
        self.leading = leading
        if let trailing = trailing {
            self.trailing = -trailing
        } else {
            self.trailing = nil
        }
        self.safe = safe
    }

    init(x: CGFloat? = nil, y: CGFloat? = nil, safe: Bool = Layout.useSafeAreas) {
        self.init(top: y, bottom: y, leading: x, trailing: x, safe: safe)
    }

    func constraints(for view: UIView, referencing secondView: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if let constant = top {
            let second = safe ? secondView.safeAreaLayoutGuide.topAnchor : secondView.topAnchor
            constraints.append(view.topAnchor.constraint(equalTo: second, constant: constant))
        }
        if let constant = bottom {
            let second = safe ? secondView.safeAreaLayoutGuide.bottomAnchor : secondView.bottomAnchor
            constraints.append(view.bottomAnchor.constraint(equalTo: second, constant: constant))
        }
        if let constant = leading {
            let second = safe ? secondView.safeAreaLayoutGuide.leadingAnchor : secondView.leadingAnchor
            constraints.append(view.leadingAnchor.constraint(equalTo: second, constant: constant))
        }
        if let constant = trailing {
            let second = safe ? secondView.safeAreaLayoutGuide.trailingAnchor : secondView.trailingAnchor
            constraints.append(view.trailingAnchor.constraint(equalTo: second, constant: constant))
        }
        return constraints
    }
}

struct Center: ConstraintProvider {
    let x: CGFloat?
    let y: CGFloat?

    init(x: CGFloat? = nil, y: CGFloat? = nil) {
        self.x = x
        self.y = y
    }

    func constraints(for view: UIView, referencing secondView: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if let x = x {
            constraints.append(view.centerXAnchor.constraint(equalTo: secondView.centerXAnchor, constant: x))
        }
        if let y = y {
            constraints.append(view.centerYAnchor.constraint(equalTo: secondView.centerYAnchor, constant: y))
        }
        return constraints
    }
}

struct Height: ConstraintProvider {
    let constant: CGFloat

    let dimension: NSLayoutDimension?
    let multiplier: CGFloat

    init(_ height: CGFloat) {
        self.constant = height
        self.dimension = nil
        self.multiplier = 1
    }

    init(equalTo dimension: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.dimension = dimension
        self.multiplier = multiplier
        self.constant = constant
    }

    func constraints(for view: UIView, referencing secondView: UIView) -> [NSLayoutConstraint] {
        if let dimension = dimension {
            return [view.heightAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: constant)]
        } else {
            return [view.heightAnchor.constraint(equalToConstant: constant)]
        }
    }
}

struct Width: ConstraintProvider {
    let constant: CGFloat

    let dimension: NSLayoutDimension?
    let multiplier: CGFloat

    init(_ width: CGFloat) {
        self.constant = width
        self.multiplier = 1
        self.dimension = nil
    }

    init(equalTo dimension: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.dimension = dimension
        self.multiplier = multiplier
        self.constant = constant
    }

    func constraints(for view: UIView, referencing secondView: UIView) -> [NSLayoutConstraint] {
        if let dimension = dimension {
            return [view.widthAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: constant)]
        } else {
            return [view.widthAnchor.constraint(equalToConstant: constant)]
        }
    }
}


// provides a constraint that references a different view
struct Connection: ConstraintProvider {
    let anchor: Anchor
    let customViewReference: UIView?
    let constant: CGFloat
    let mode: AnchorMode

    enum AnchorMode {
        case same
        case opposing
    }

    enum Anchor {
        case x(XAnchor)
        case y(YAnchor)
    }

    enum YAnchor {
        case top, bottom

        var reverse: YAnchor {
            return self == .top ? .bottom : .top
        }
        func anchor(for view: UIView) -> NSLayoutYAxisAnchor {
            return self == .top ? view.topAnchor : view.bottomAnchor
        }
    }
    enum XAnchor {
        case leading, trailing

        var reverse: XAnchor {
            return self == .leading ? .trailing : .leading
        }
        func anchor(for view: UIView) -> NSLayoutXAxisAnchor {
            return self == .leading ? view.leadingAnchor : view.trailingAnchor
        }
    }

    func constraints(for view: UIView, referencing secondView: UIView) -> [NSLayoutConstraint] {
        switch anchor {
        case .x(let x):
            let viewAnchor = x.anchor(for: view)
            let target = mode == .same ? x : x.reverse
            let referenceAnchor = target.anchor(for: secondView)
            return [viewAnchor.constraint(equalTo: referenceAnchor, constant: constant)]
        case .y(let y):
            let viewAnchor = y.anchor(for: view)
            let target = mode == .same ? y : y.reverse
            let referenceAnchor = target.anchor(for: secondView)
            return [viewAnchor.constraint(equalTo: referenceAnchor, constant: constant)]
        }
    }
}

struct Layout {
    static var useSafeAreas = false

    let implementation: ConstraintProvider
    init(_ implementation: ConstraintProvider) {
        self.implementation = implementation
    }

    @discardableResult
    func apply(to view: UIView, referencing secondView: UIView) -> [NSLayoutConstraint] {
        let referenceView = implementation.customViewReference ?? secondView
        let constraints = implementation.constraints(for: view, referencing: referenceView)
        constraints.activate()
        return constraints
    }
}

extension Layout {
    // MARK: Dimensions
    static func height(_ height: CGFloat) -> Layout { return Layout(Height(height)) }
    static func height(equalTo dimension: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0) -> Layout {
        return Layout(Height(equalTo: dimension, multiplier: multiplier, constant: constant))
    }
    static func width(_ width: CGFloat) -> Layout { return Layout(Width(width)) }
    static func width(equalTo dimension: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0) -> Layout {
        return Layout(Width(equalTo: dimension, multiplier: multiplier, constant: constant))
    }

    // MARK: Pinning
    static var fill: Layout { return Layout(Pin(x: 0, y: 0)) }
    static var fillX: Layout { return Layout(Pin(x: 0)) }
    static var fillY: Layout { return Layout(Pin(y: 0)) }
    static func fill(safe: Bool) -> Layout { return Layout(Pin(x: 0, y: 0, safe: safe)) }
    static func fillX(safe: Bool) -> Layout { return Layout(Pin(x: 0, safe: safe)) }
    static func fillY(safe: Bool) -> Layout { return Layout(Pin(y: 0, safe: safe)) }

    static func pin(_ all: CGFloat, safe: Bool = Layout.useSafeAreas) -> Layout {
        return Layout(Pin(x: all, y: all, safe: safe))
    }
    static func pin(x: CGFloat? = nil, y: CGFloat? = nil, safe: Bool = Layout.useSafeAreas) -> Layout {
        return Layout(Pin(x: x, y: y, safe: safe))
    }
    static func pin(top: CGFloat? = nil, bottom: CGFloat? = nil, leading: CGFloat? = nil, trailing: CGFloat? = nil, safe: Bool = Layout.useSafeAreas) -> Layout {
        return Layout(Pin(top: top, bottom: bottom, leading: leading, trailing: trailing, safe: safe))
    }

    // MARK: Positioning
    static var center: Layout { return Layout(Center(x: 0, y: 0)) }
    static var centerX: Layout { return Layout(Center(x: 0)) }
    static var centerY: Layout { return Layout(Center(y: 0)) }
    static func center(x: CGFloat? = nil, y: CGFloat? = nil) -> Layout {
        return Layout(Center(x: x, y: y))
    }

    // MARK: Connecting to other views

    // the .join layouts will setup views in a cascading manner
    // where .top of one view will be anchored to the .bottom of the other view
    // and .leading will be anchored to .trailing
    static func join(_ anchor: Connection.XAnchor, to view: UIView, by constant: CGFloat = 0) -> Layout {
        return Layout(Connection(anchor: .x(anchor), customViewReference: view, constant: constant, mode: .opposing))
    }
    static func join(_ anchor: Connection.YAnchor, to view: UIView, by constant: CGFloat = 0) -> Layout {
        return Layout(Connection(anchor: .y(anchor), customViewReference: view, constant: constant, mode: .opposing))
    }

    // the .align layouts constrain views with anchors on the same side
    // .top to .top, .leading to .leading
    static func align(_ anchor: Connection.XAnchor, to view: UIView, by constant: CGFloat = 0) -> Layout {
        return Layout(Connection(anchor: .x(anchor), customViewReference: view, constant: constant, mode: .same))
    }
    static func align(_ anchor: Connection.YAnchor, to view: UIView, by constant: CGFloat = 0) -> Layout {
        return Layout(Connection(anchor: .y(anchor), customViewReference: view, constant: constant, mode: .same))
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
        return view.apply(layout: layouts, referencing: self)
    }

    @discardableResult
    func apply(layout layouts: Layout..., referencing view: UIView) -> [NSLayoutConstraint] {
        return apply(layout: layouts, referencing: view)
    }

    @discardableResult
    func apply(layout layouts: [Layout], referencing view: UIView) -> [NSLayoutConstraint] {
        return layouts.flatMap { layout in
            layout.apply(to: self, referencing: view)
        }
    }
}

