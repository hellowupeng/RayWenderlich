// Copyright (c) 2017 Razeware LLC
// See Copyright Notice page for details about the license.

import UIKit
import PlaygroundSupport

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

    context.setFillColor(UIColor.random.cgColor)
    context.fill(rect)

    for shape in shapes {
      shape.draw(on: context)
    }
  }
}



////////////////////////////////////////////////////////////////////////////////


 func testRender(_ count: Int) {
 let renderView = RenderView(frame: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))

 var shapes: [Drawable] = []

 for _ in 1 ... count {

 let center = CGPoint(x: (0...renderView.frame.size.width).random,
 y: (0...renderView.frame.size.height).random)
 let radius = (CGFloat(50)...CGFloat(80)).random/2
 let color = UIColor.random
 let fillColor = UIColor.random
 let lineWidth = (CGFloat(5)...CGFloat(15)).random


 let shape = Circle(center: center, radius: radius, lineWidth: lineWidth, color: color, fillColor: fillColor)
 shapes.append(shape)
 }

 renderView.shapes = shapes
 PlaygroundPage.current.liveView = renderView
 }
 testRender(10)
