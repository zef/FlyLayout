# FlyLayout

A Swift API for Auto Layout. Expressive, terse, and clear.

## Demo

Here's a quick example of the power and expressiveness that FlyLayout can provide.

This entire complex layout is expressed in only 30 lines of code, yet it remains readable, understandable, and flexible.

![Code example and screenshot](/FlyLayoutDemo.png?raw=true)

You can try this out by opening `Example/FlyLayout.xcworkspace` yourself.


## Usage

Add a subview, filling it entirely.
```Swift
view.addSubview(label, layout: .fill)
```
Add a subview, filling in one dimension.
```Swift
view.addSubview(label, layout: .fillX)
view.addSubview(label, layout: .fillY)

// respecting safe areas are also configurable through functions like this:
view.addSubview(label, layout: .fillY(safe: false))
```

To provide some spacing around the subview, use `.pin`.
```Swift
// all sides
view.addSubview(label, layout: .pin(10))

// x and/or y (either can be omitted).
view.addSubview(label, layout: .pin(x: 10, y: 20))

// top/bottom/leading/trailing
view.addSubview(label, layout: .pin(top: 10, leading: 20, trailing: 40))
```

Centering subviews:
```Swift
.center, .centerX, .centerY

// or to define an offset from the center:
.center(x: 10)
.center(y: -40)
.center(x: 10, y: -40)
```

Defining dimensions:
```Swift
// simple dimensions
.width(10), .height(10)

// or a convenience to define width and height together
.square(10)

// you can also use `width` and `height` referencing another view's anchor values:
.width(equalTo: someView.widthAnchor)
```

## Advanced Usage

### Safe Areas

When filling and pinning to edges, Safe Areas can be respected or ignored in the following ways.

Pass `safe: Bool` to layouts that support safe areas:
```Swift
view.addSubview(label, layout: .fill(safe: true))
view.addSubview(label, layout: .pin(10, safe: true))
```

Perform your layout inside blocks using either `Layout.toSafeAreas` or `Layout.ignoringSafeAreas`:
```Swift
Layout.toSafeAreas {
    view.addSubview(label, layout: .pin(10))
}
```

Or, explicitly control the value of the `useSafeAreas` global, which defines your preference for the default behavior:
```Swift
Layout.useSafeAreas = true
view.addSubview(label, layout: .fillY)
```

### Assigning outside of `addSubview`

So far, we've only been assigning constraints during the `addSubview` call. However, it's also possible to add constraints at a later time:
```Swift
// if `someView` is already in the view heirarchy, this would apply the constraints referencing `otherView`, where appropriate.
someView.layout(.pin(10), .width(20), with: otherView)
```
Layouts can also be added through all of `UIKit`s standard `insertSubview` calls.

### Extending with your own custom layouts

You can create your own custom layouts that can be passed into the layout calls. To do this:

1. Implement a struct that conforms to `ConstraintProvider`, as in `Layout.swift`
2. Add an extension to  `Layout` that wraps your `ConstraintProvider`, as in `Definitions.swift` 


## Installation

Nothing here yet... I've been sitting on this project for a while because I don't have this setup and documented properly, but I'm deciding to push it anyway and I would love to get this ready soon! 

## Design Goals

### Practical:

- Just Auto Layout. The intention is to make it easy to use Auto Layout without introducing additional concepts.
  As part of this goal, the API is designed to avoid (minimize) the use of internally-defined types that wrap existing Auto Layout types.

- Extensible. Apps can define their own Layouts that suit their own use.

- 90% The base functionality here is intended to cover the majority of my needs in every day Auto Layout with a simple API.
  I find that adding new definitions of Layout implementations to fill out more advanced use-cases inflicts some minor damage
  on the overall experience of using the library. The more exhaustive the API, the more available completions,
  the more unused completion arguments that need to be deleted with each use. I'm trying to find a balance between
  extensive functionality and API simplicity.

  One good thing is that the extensibility allows us to implement a subset of full functionality for core needs,
  while allowing an extension to expand the possibilities. I may consider and investigate being able to selectively import
  a more full-featured set of Layout definitions in just the files where they're needed, avoiding unwanted completion spam.

  I hesitate to add things like constraint priorities as arguments, and think that in the case that priority customization is needed,
  it's easy enough to apply the constraint separately and then modify its priority. Feedback is invited here.

### Conceptual:

The `Layout` functions available are named in such a way as to be:

- expressive: they should allow powerful behaviors.
- terse: they should be short, so that many `Layout`s can be easily used together on the same line, while remaining readable.
- clear: they should express intent and be easily understandable without special knowledge.

Tradeoffs must be made between these, and I'm open to suggestions for improvement!

### Known Tradeoffs:

- The `width` and `height` layouts are awkward when applied independently:
```Swift
view.layout(.height(30), with: view)
```

In these cases, no second view reference is needed, so the `with` parameter does not make sense and is ignored.
However, since other constraints do require a second view reference, I do not want to make that parameter an optional.

Maybe I can work around it by making another Layout function that takes types that do not require a second view?

- Layouts that return an array of constraints, with a single item. Inconvenient when needing to reference a single constraint.



## Ideas/TODO


- I have some unexplored ideas for defining constraint priority
- The `when` conditions from [EasyPeasy](https://github.com/nakiostudio/EasyPeasy) look very cool and would probably work well here.
