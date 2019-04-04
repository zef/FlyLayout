# FlyLayout

A Swift syntax for AutoLayout. Expressive, terse, and clear.

Add a subview, filling it entirely.
```Swift
view.addSubview(label, layout: .fill)
```

## Design Goals

Practical:

- Just AutoLayout. The intention is to make it easy to use AutoLayout without introducing additional concepts.
As part of this goal, the API is designed to avoid the use of internally-defined types that wrap existing AutoLayout types.

- Extensible. Apps can define their own Layouts that suit their own use.


Conceptual:

The `Layout` functions avalable are named in such a way as to be:

- expressive: they should allow powerful behaviors.
- terse: they should be short, so that many `Layout`s can be easily used together on the same line, while remaining readable.
- clear: they should express intent and be easily understandable without special knowledge.

Tradeoffs must be made between these, and I'm open to suggestions for improvement!

