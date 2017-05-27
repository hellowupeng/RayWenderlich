//
//  RangeSlider.swift
//  CustomSliderExample
//
//  Created by Andy Wu on 5/27/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {
	
	let trackLayer = CALayer()
	
	let lowerThumbLayer = RangeSliderThumbLayer()
	
	let upperThumbLayer = RangeSliderThumbLayer()
	
	var thumbWidth: CGFloat {
		return CGFloat(bounds.height)
	}
	
	// 最小值
	var minimumValue = 0.0
	
	// 最大值
	var maximumValue = 1.0

	var lowerValue = 0.2
	
	var upperValue = 0.8
	
	var previousLocation = CGPoint()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	override var frame: CGRect {
		didSet {
			updateLayerFrames()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		trackLayer.backgroundColor = UIColor.blue.cgColor
		layer.addSublayer(trackLayer)
		
		lowerThumbLayer.backgroundColor = UIColor.green.cgColor
		lowerThumbLayer.rangeSlider = self
		layer.addSublayer(lowerThumbLayer)
		
		upperThumbLayer.backgroundColor = UIColor.green.cgColor
		upperThumbLayer.rangeSlider = self
		layer.addSublayer(upperThumbLayer)
		
		updateLayerFrames()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: Tracking touches event
	
	override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		previousLocation = touch.location(in: self)
		
		// Hit test the thumb layers
		if lowerThumbLayer.frame.contains(previousLocation) {
			lowerThumbLayer.hilighted = true
		} else if upperThumbLayer.frame.contains(previousLocation) {
			upperThumbLayer.hilighted = true
		}
		
		return lowerThumbLayer.hilighted || upperThumbLayer.hilighted
	}
	
	func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
		return min(max(value, lowerValue), upperValue)
	}
	
	override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		let location = touch.location(in: self)
		
		// 1. Determin by how much the user has dragged
		let deltaLocation = Double(location.x - previousLocation.x)
		let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
		
		previousLocation = location
		
		// 2. Update the values
		if lowerThumbLayer.hilighted {
			lowerValue += deltaValue
			lowerValue = boundValue(value: lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
		} else if upperThumbLayer.hilighted {
			upperValue += deltaValue
			upperValue = boundValue(value: upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
		}
		
		// 3. Update the UI
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		updateLayerFrames()
		
		CATransaction.commit()
		
		sendActions(for: UIControlEvents.valueChanged)
		return true
	}
	
	override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		lowerThumbLayer.hilighted = false
		upperThumbLayer.hilighted = false
	}
	
	// MARK: Helpers
	
	/// 更新Layer Frames
	func updateLayerFrames() {
		trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height/3)
		trackLayer.setNeedsDisplay()
		
		let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
		
		lowerThumbLayer.frame = CGRect(x: lowerThumbCenter-thumbWidth/2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
		lowerThumbLayer.setNeedsDisplay()
		
		let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
		upperThumbLayer.frame = CGRect(x: upperThumbCenter-thumbWidth/2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
		upperThumbLayer.setNeedsDisplay()
	}
	
	/// 根据比例在最小、最大范围之间缩放position
	func positionForValue(value: Double) -> Double {
		return Double(bounds.width - thumbWidth) * (value - minimumValue) /
			(maximumValue - minimumValue) + Double(thumbWidth / 2.0)
	}
}
