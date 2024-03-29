//
//  Protocols.swift
//  FlyLayout
//
//  Created by Zef Houssney on 3/26/19.
//  Copyright © 2019 Zef Houssney. All rights reserved.
//

import UIKit

// This is the basic building block of Layout implementations.
// You can conform to this to provide your own Layout types.
public protocol ConstraintProvider {
    func constraints(for view: UIView, with secondView: UIView) -> [NSLayoutConstraint]

    // This is implemented when used in views that refer to
    // a view other than the superview, which is used by default.
    var customViewReference: UIView? { get }
}
extension ConstraintProvider {
    var customViewReference: UIView? { return nil }
}

// Layout is a concrete wrapper type that connects the implementation of
// a ConstraintProvider to a public definition of Layouts that are used by
public struct Layout {
    public static var useSafeAreas = false

    public let implementation: ConstraintProvider
    public init(_ implementation: ConstraintProvider) {
        self.implementation = implementation
    }

    @discardableResult
    public func apply(to view: UIView, with secondView: UIView) -> [NSLayoutConstraint] {
        let referenceView = implementation.customViewReference ?? secondView
        let constraints = implementation.constraints(for: view, with: referenceView)
        constraints.forEach { $0.priority = priority }
        constraints.activate()
        return constraints
    }

    public static func toSafeAreas(_ block: () -> Void) {
        let originalValue = useSafeAreas
        useSafeAreas = true
        block()
        useSafeAreas = originalValue
    }

    public static func ignoringSafeAreas(_ block: () -> Void) {
        let originalValue = useSafeAreas
        useSafeAreas = false
        block()
        useSafeAreas = originalValue
    }

    public var priority: UILayoutPriority = .required
//    public func at(_ priority: UILayoutPriority) -> Layout {
//        var layout = self
//        layout.priority = priority
//        return layout
//    }
}

//infix operator |
//func |(lhs: Layout, rhs: UILayoutPriority) -> Layout {
//    var layout = lhs
//    layout.priority = rhs
//    return layout
//}
