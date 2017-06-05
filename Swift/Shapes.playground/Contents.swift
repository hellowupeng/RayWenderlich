import Foundation

enum CSSColor {
	case named(ColorName)
	case rgb(UInt8, UInt8, UInt8)
}

extension CSSColor {
	enum ColorName: String {
		case black, silver, gray, white, maroon, red, purple, fuchsia, green, lime, olive, yellow, navy, blue, teal, aqua
	}
}

extension CSSColor: CustomStringConvertible {
	var description: String {
		switch self {
		case .named(let colorName):
			return colorName.rawValue
		case .rgb(let red, let green, let blue):
			return String(format: "#%02X%02X%02X", red, green, blue)
		}
	}
	
}

let color1 = CSSColor.named(.red)
let color2 = CSSColor.rgb(0xAA, 0xAA, 0xAA)
print("color1 = \(color1), color2 = \(color2)")

extension CSSColor {
	init(gray: UInt8) {
		self = .rgb(gray, gray, gray)
	}
}

let color3 = CSSColor(gray: 0xaa)
print(color3)

enum Math {
	static let phi = 1.6180339887498948482
}

protocol Drawable {
	func draw(with context: DrawingContext)
}

protocol DrawingContext {
	func draw(_ circle: Circle)
	func draw(_ rectangle: Rectangle)
}

struct Circle: Drawable {
	var strokeWidth = 5
	var strokeColor = CSSColor.named(.red)
	var fillColor = CSSColor.named(.yellow)
	var center = (x: 80.0, y: 160.0)
	var radius = 60.0
	
	// Adopting the Drawable protocol
	
	func draw(with context: DrawingContext) {
		context.draw(self)
	}
}

struct Rectangle: Drawable {
	var strokeWidth = 5
	var strokeColor = CSSColor.named(.teal)
	var fillColor = CSSColor.named(.aqua)
	var origin = (x: 110.0, y: 10.0)
	var size = (width: 100.0, height: 130.0)
	
	func draw(with context: DrawingContext) {
		context.draw(self)
	}
}

final class SVGContext: DrawingContext {
	
	private var commands: [String] = []
	
	var width = 250
	var height = 250
	
	// 1
	func draw(_ circle: Circle) {
		commands.append("<circle cx='\(circle.center.x)' cy='\(circle.center.y)' r='\(circle.radius)' stroke='\(circle.strokeColor)' fill='\(circle.fillColor)' stroke-width='\(circle.strokeWidth)' />")
	}
	
	// 2
	func draw(_ rectangle: Rectangle) {
		commands.append("<rect x='\(rectangle.origin.x)' y='\(rectangle.origin.y)' width='\(rectangle.size.width)' height='\(rectangle.size.height)' stroke='\(rectangle.strokeColor)' fill='\(rectangle.fillColor)' stroke-width='\(rectangle.strokeWidth)' />")
	}
	
	var svgString: String {
		var output = "<svg width='\(width)' height='\(height)'>"
		for command in commands {
			output += command
		}
		output += "</svg>"
		return output
	}
	
	var htmlString: String {
		return "<!DOCTYPE html><html><body>" + svgString + "</bogy></html>"
	}
	
}

struct SVGDocument {
	var drawables: [Drawable] = []
	
	var htmlString: String {
		let context = SVGContext()
		for drawable in drawables {
			drawable.draw(with: context)
		}
		return context.htmlString
	}
	
	mutating func append(_ drawable: Drawable) {
		drawables.append(drawable)
	}
}

var document = SVGDocument()

let rectangle = Rectangle()
document.append(rectangle)

let circle = Circle()
document.append(circle)

let htmlString = document.htmlString
print(htmlString)

import WebKit
import PlaygroundSupport

let view = WKWebView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
		view.loadHTMLString(htmlString, baseURL: nil)
PlaygroundPage.current.liveView = view