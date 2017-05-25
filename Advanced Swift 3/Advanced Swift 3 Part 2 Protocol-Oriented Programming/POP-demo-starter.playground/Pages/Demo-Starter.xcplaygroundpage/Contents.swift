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

////////////////////////////////////////////////////////////////////////////////

/*
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
*/
