//
//  FlowerView.swift
//  Birthday Card
//
//  Created by Georges Kanaan on 11/10/2018.
//  Copyright © 2018 Georges Kanaan. All rights reserved.
//

import UIKit

class FlowerView: UIView {
	
	public var fillColor: UIColor?
	public var strokeColor: UIColor?
	
	public init(frame: CGRect, strokeColor: UIColor, fillColor: UIColor) {
		super.init(frame: frame)
		
		self.strokeColor = strokeColor
		self.fillColor = fillColor
		
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		
		// Frame & Layer
		self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y,
							width: self.frame.width, height: self.frame.width) // Force Square

		// Colors
		if self.strokeColor == nil {
			self.strokeColor = #colorLiteral(red: 0.9803921569, green: 0.7843137255, blue: 0.2901960784, alpha: 1)
		}
		
		if self.fillColor == nil {
			self.fillColor = #colorLiteral(red: 0.9803921569, green: 0.7843137255, blue: 0.2901960784, alpha: 1)
		}
		
		self.backgroundColor = UIColor.clear
		self.layer.backgroundColor = UIColor.clear.cgColor

		
		// Draw the flower
		drawFlower()
	}
	
	func drawFlower() {
		// Draw a flower (UIBezierPath) using polar coordinates: r = cos (k\theta) + c
		// We chose k = 9/4; c = 5 see https://en.wikipedia.org/wiki/Rose_(mathematics)
		// to learn how different parameters affect the shape.
		let flowerPath = UIBezierPath()
		flowerPath.lineWidth = 1.0
		
		let k: Double = 9/4 // n/d. If odd k = petals , if even k = petals/2. Check 6
		
		let flowers: Array<Double>! = [Double(100), Double(50)] // Each item represents a flower length
		for amplitude in flowers { // len(flowers) = # of flowers
			for theta in stride(from: 0, to: Double.pi * 2 * 100, by: 0.1) {// Wtf shouldn't theta be going from 0 to 3.28
				// Convert polar coordinates to cartesion coordinates
				let x: Double = amplitude * cos(k*theta) * cos(theta)
				let y: Double = amplitude * cos(k*theta) * sin(theta)
				
				// Scale the coordinates to the view
				// newvalue = (max'-min')/(max-min)*(value-max)+max'
				let scale_factor:Double = flowers.max()! // Should be largest flower so that smaller flowers appear smaller.
				let scaled_x:Double = Double(self.frame.width)/(scale_factor*2) * (x - scale_factor) + Double(self.frame.width)
				let scaled_y:Double = Double(self.frame.height)/(scale_factor*2) * (y - scale_factor) + Double(self.frame.height)

				if theta == 0 {
					// (100, 0) then (50, 0)
					flowerPath.move(to: CGPoint(x:scaled_x, y: scaled_y))
					// flowerPath.move(to: CGPoint(x: x, y: y))
				} else {
					// flowerPath.addLine(to: CGPoint(x: x, y:y))
					flowerPath.addLine(to: CGPoint(x:scaled_x, y: scaled_y))
				}
			}
		}
		
		flowerPath.close()
		
		print ("Done path.")
		
		// Create a mask with the path
		let flowerShapeLayer = CAShapeLayer()
		flowerShapeLayer.path = flowerPath.cgPath
		flowerShapeLayer.strokeColor = self.strokeColor!.cgColor
		flowerShapeLayer.fillColor = self.fillColor!.cgColor
		flowerShapeLayer.fillRule = .evenOdd
		flowerShapeLayer.backgroundColor = UIColor.blue.cgColor
		
		// Add the layer
		self.layer.backgroundColor = UIColor.red.cgColor
		self.layer.addSublayer(flowerShapeLayer)
	}
}
