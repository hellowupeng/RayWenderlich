// Copyright (c) 2017 Razeware LLC
// See Copyright Notice page for details about the license.

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
  var strokeWidth: CGFloat
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
    context.setLineWidth(strokeWidth)
    context.strokePath()
  }
}

////////////////////////////////////////////////////////////////////////////////

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

struct Line: Drawable {
  var position1: CGPoint
  var position2: CGPoint
  var color: UIColor
  var lineWidth: CGFloat

  func draw(on context: CGContext) {
    context.move(to: position1)
    context.addLine(to: position2)
    context.setLineWidth(lineWidth)
    context.setStrokeColor(color.cgColor)
    context.strokePath()
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

    // Bounce the point off the boundary, flip the velocity if needed
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

  mutating func update(velocity1: CGPoint, velocity2: CGPoint,
                       within boundary: CGRect)
    -> (newVelocity1: CGPoint, newVelocity2: CGPoint) {
      let result1 = update(position: position1, velocity: velocity1, within: boundary)
      let result2 = update(position: position2, velocity: velocity2, within: boundary)
      position1 = result1.newPosition
      position2 = result2.newPosition

      return (newVelocity1: result1.newVelocity, newVelocity2: result2.newVelocity)
  }
}

////////////////////////////////////////////////////////////////////////////////

func bounceLine(numberOfLines: Int, iterations: Int) {
  let renderView = RenderView(frame: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))

  var line = Line(position1: CGPoint(x: 50, y: 50),
                  position2: CGPoint(x: 300, y: 300),
                  color: UIColor.cyan, lineWidth: 4)

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

