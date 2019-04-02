//
//  Layout.swift
//  FlyLayout
//
//  Created by Zef Houssney on 3/26/19.
//  Copyright © 2019 Zef Houssney. All rights reserved.
//

import UIKit

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
