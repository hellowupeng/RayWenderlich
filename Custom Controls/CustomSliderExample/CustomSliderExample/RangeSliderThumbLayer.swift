//
//  RangeSliderThumbLayer.swift
//  CustomSliderExample
//
//  Created by Andy Wu on 5/27/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSliderThumbLayer: CALayer {
	
	/// 指出thumb是否是hilighted
	var hilighted: Bool = false {
		didSet {
			setNeedsDisplay()
		}
	}
	
	weak var rangeSlider: RangeSlider?
	
	override func draw(in ctx: CGContext) {
		if let slider = rangeSlider {
			let thumbFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
			let cornerRadius = thumbFrame.height * slider.curvaceousness / 2.0
			let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
			
			// Fill - with a subtle shadow
			let shadowColor = UIColor.gray
			ctx.setShadow(offset: CGSize(width: 0.0, height: 1.0), blur: 1.0, color: shadowColor.cgColor)
			ctx.setFillColor(slider.thumbTintColor.cgColor)
			ctx.addPath(thumbPath.cgPath)
			ctx.fillPath()
			
			// Outline
			ctx.setStrokeColor(shadowColor.cgColor)
			ctx.setLineWidth(0.5)
			ctx.addPath(thumbPath.cgPath)
			ctx.strokePath()
			
			if hilighted {
				ctx.setFillColor(UIColor(white: 0.0, alpha: 0.1).cgColor)
				ctx.addPath(thumbPath.cgPath)
				ctx.fillPath()
			}
		}
	}
}
