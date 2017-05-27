//
//  RangeSliderTrackLayer.swift
//  CustomSliderExample
//
//  Created by Andy Wu on 5/28/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSliderTrackLayer: CALayer {
	weak var rangeSlider: RangeSlider?
	
	override func draw(in ctx: CGContext) {
		if let slider = rangeSlider {
			// Clip
			let cornerRadius = bounds.height * slider.curvaceousness / 2.0
			let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
			
			// Fill the track
			ctx.setFillColor(slider.trackTintColor.cgColor)
			ctx.addPath(path.cgPath)
			ctx.fillPath()
			
			// Fill the highlighted range
			ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
			let lowerValuePosition = CGFloat(slider.positionForValue(value: slider.lowerValue))
			let upperValuePosition = CGFloat(slider.positionForValue(value: slider.upperValue))
			let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
			ctx.fill(rect)
		}
	}
}
