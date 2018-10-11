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
		self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.width) // Force Square
		self.clipsToBounds = true
		
		// Colors
		self.backgroundColor = UIColor.blue
		self.layer.backgroundColor = UIColor.red.cgColor
		
		if self.strokeColor == nil {
			self.strokeColor = #colorLiteral(red: 0.9803921569, green: 0.7843137255, blue: 0.2901960784, alpha: 1)
		}
		
		if self.fillColor == nil {
			self.fillColor = #colorLiteral(red: 0.9803921569, green: 0.7843137255, blue: 0.2901960784, alpha: 1)
		}
		
		// Draw the flower
		drawFlower()
	}
	
	func drawFlower() {
		// Draw a flower (UIBezierPath) using polar coordinates: r = cos (k\theta) + c
		// We chose k = 7/2; c = 5 see https://en.wikipedia.org/wiki/Rose_(mathematics)
		// to learn how different parameters affect the shape.
		let flowerPath = UIBezierPath()
		flowerPath.lineWidth = 1.0
		//flowerPath.move(to: CGPoint.zero)
		
		print("Begining generating path")
		
		let k: Double = 9/4 // n/d. If odd k = petals , if even k = petals/2.
		
		for amplitude in [Double(100), Double(50)] {// length of each petal (2) flowers
			for theta in stride(from: 0, to: Double.pi * 2 * 100, by: 0.001) {// Wtf shouldn't theta be going from 0 to 3.28
				// Convert polar coordinates to cartesion coordinates
				let x: Double = amplitude * cos(k*theta) * cos(theta)
				let y: Double = amplitude * cos(k*theta) * sin(theta)
				
				// Scale the coordinates to the view
				let scaled_x:Double = (x + amplitude) / (amplitude*2) * Double(self.frame.width)
				let scaled_y:Double = (y + amplitude) / (amplitude*2) * Double(self.frame.height)

				
				if theta == 0 {
					flowerPath.move(to: CGPoint(x: scaled_x, y: scaled_y))
				} else {
					flowerPath.addLine(to: CGPoint(x: scaled_x, y: scaled_y))
				}
			}
		}
		
		print("Done generating path")
		
		// Create a mask with the path
		let flowerLayer = CAShapeLayer()
		flowerLayer.path = flowerPath.cgPath
		// #colorLiteral(red: 0.9803921569, green: 0.7843137255, blue: 0.2901960784, alpha: 1)
		
		flowerLayer.strokeColor = self.strokeColor!.cgColor
		flowerLayer.fillColor = self.fillColor!.cgColor
		flowerLayer.fillRule = .evenOdd
		flowerLayer.backgroundColor = UIColor.clear.cgColor
		
		// Add the layer
		self.layer.addSublayer(flowerLayer)
//
//		// Animate the drawing
//		let animation = CABasicAnimation(keyPath: "strokeEnd")
//		animation.fromValue = 0.0
//		animation.toValue = 1.0
//		animation.duration = 20.0
//		flowerLayer.add(animation, forKey: "drawLineAnimation")
	}
}
