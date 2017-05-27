//
//  ViewController.swift
//  CustomSliderExample
//
//  Created by Andy Wu on 5/27/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	let rangeSlider = RangeSlider(frame: CGRect.zero)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		rangeSlider.backgroundColor = UIColor.red
		view.addSubview(rangeSlider)
		
		rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: UIControlEvents.valueChanged)
	}
	
	override func viewDidLayoutSubviews() {
		let margin: CGFloat = 20.0
		let width = view.bounds.width - 2.0 * margin
		rangeSlider.frame = CGRect(x: margin, y: margin+topLayoutGuide.length, width: width, height: 31.0)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
		print("Range slider value changed: \(rangeSlider.lowerValue) \(rangeSlider.upperValue)")
	}
	
}

