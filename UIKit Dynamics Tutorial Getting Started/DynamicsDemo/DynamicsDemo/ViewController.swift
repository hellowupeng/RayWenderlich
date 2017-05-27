//
//  ViewController.swift
//  DynamicsDemo
//
//  Created by Andy Wu on 5/26/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var animator: UIDynamicAnimator!
	var gravity: UIGravityBehavior!
	var collision: UICollisionBehavior!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
		square.backgroundColor = UIColor.gray
		view.addSubview(square)
		animator = UIDynamicAnimator(referenceView: view)
		gravity = UIGravityBehavior(items: [square])
		animator.addBehavior(gravity)
		
		let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
		barrier.backgroundColor = UIColor.red
		view.addSubview(barrier)
		
		collision = UICollisionBehavior(items: [square, barrier])
		collision.translatesReferenceBoundsIntoBoundary = true
		animator.addBehavior(collision)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

