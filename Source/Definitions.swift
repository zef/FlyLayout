//
//  Definitions.swift
//  FlyLayout
//
//  Created by Zef Houssney on 3/26/19.
//  Copyright © 2019 Zef Houssney. All rights reserved.
//

import Foundation

// Here we define the public interface for Layouts that are available.
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

