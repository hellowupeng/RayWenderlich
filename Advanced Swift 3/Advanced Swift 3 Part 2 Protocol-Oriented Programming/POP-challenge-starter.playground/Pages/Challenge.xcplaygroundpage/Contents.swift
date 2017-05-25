// Copyright (c) 2017 Razeware LLC
// See Copyright Notice page for details about the license.

// Challenge Protocol Oriented Programming
// Scroll down to Step 1 to get started!

import UIKit

protocol Drawable {
  func draw(on context: CGContext)
}

protocol Geometry {
  var size: CGSize { get }
  func area() -> CGFloat
}

extension Geometry {
  func area() -> CGFloat { return size.width * size.height }
}

struct Circle: Drawable, Geometry {
  var center: CGPoint
  var radius: CGFloat
  var lineWidth: CGFloat
  var color: UIColor
  var fillColor: UIColor

  var diameter: CGFloat {
    return radius * 2
  }

  var size: CGSize {
    return CGSize(width: diameter, height: diameter)
  }

  func area() -> CGFloat {
    return .pi * radius * radius
  }

  func draw(on context: CGContext) {
    context.setFillColor(fillColor.cgColor)
    let rect = CGRect(x: center.x-radius, y: center.y-radius, width: diameter, height: diameter)
    context.addEllipse(in: rect)
    context.fillPath()
    context.setStrokeColor(color.cgColor)
    context.addEllipse(in: rect)
    context.setLineWidth(lineWidth)
    context.strokePath()
  }
}

//////////////////////////////////////////////////////////////////////

final class RenderView: UIView {

  var shapes: [Drawable] = [] {
    didSet {
      setNeedsDisplay()
    }
  }

  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }

    context.setFillColor(UIColor.darkGray.cgColor)
    context.fill(rect)

    for shape in shapes {
      shape.draw(on: context)
    }
  }
}

//////////////////////////////////////////////////////////////////////
// MARK: - Step 1
//         Create a Drawable Line Type

struct Line: Drawable {

  func draw(on context: CGContext) {

  }
}

extension Line {
  private func update(position: CGPoint,
                      velocity: CGPoint,
                      within boundary: CGRect) ->
    (newPosition: CGPoint, newVelocity: CGPoint) {

      var newPosition = position
      var newVelocity = velocity

      newPosition.x += velocity.x
      newPosition.y += velocity.y

      // Bounce the point off the boundary and flip velocity if needed
      if newPosition.x >= boundary.maxX {
        newPosition.x = 2*boundary.maxX - newPosition.x
        newVelocity.x *= -1
      }
      if newPosition.x <= boundary.minX {
        newPosition.x = 2*boundary.minX - newPosition.x
        newVelocity.x *= -1
      }
      if newPosition.y >= boundary.maxY {
        newPosition.y = 2*boundary.maxY - newPosition.y
        newVelocity.y *= -1
      }
      if newPosition.y <= boundary.minY {
        newPosition.y = 2*boundary.minY - newPosition.y
        newVelocity.y *= -1
      }
      return (newPosition: newPosition, newVelocity: newVelocity)
  }

  mutating func update(velocity1: CGPoint,
                       velocity2: CGPoint,
                       within boundary: CGRect)
    -> (newVelocity1: CGPoint, newVelocity2: CGPoint) {

      // MARK: - Step 2
      //
      //         Update start and end of the line position using two
      //         calls to the update(position:velocity:within:) method.
      //         Return the updated velocities.

      return (newVelocity1: velocity1 , newVelocity2: velocity2)
  }
}

////////////////////////////////////////////////////////////////////////////////

func bounceLine(numberOfLines: Int, iterations: Int) {
  let renderView = RenderView(frame: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))

  // MARK: - Step 3
  // Create a good starting line.
  var line = Line()

  var velocity1 = CGPoint(x: 10, y: 8)
  var velocity2 = CGPoint(x: 10, y: -12)

  var lines: [Line] = []
  for _ in 0..<numberOfLines {
    lines.append(line)
    (velocity1, velocity2) =
      line.update(velocity1: velocity1,
                  velocity2: velocity2,
                  within: renderView.frame)
  }

  for _ in 1 ... iterations {
    let lastIndex = lines.count-1
    lines.append(lines[lastIndex])
    (velocity1, velocity2) =
      lines[lastIndex+1].update(velocity1: velocity1,
                                velocity2: velocity2,
                                within: renderView.frame)
    lines.remove(at: 0)
    renderView.shapes = lines
    renderView
  }
}
bounceLine(numberOfLines: 7, iterations: 1000)

