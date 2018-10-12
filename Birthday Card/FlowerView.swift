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
	}
	
	public func draw(animate: Bool) {
		// Draw the flower
		let flowerFrame = self.frame
		DispatchQueue.global(qos: .background).async {
			self.drawFlower(frame: flowerFrame, animate: animate)
		}
	}
	
	private func drawFlower(frame: CGRect, animate:Bool) {
		// Draw a flower (UIBezierPath) using polar coordinates: r = cos (k\theta) + c
		// We chose k = 9/4; c = 5 see https://en.wikipedia.org/wiki/Rose_(mathematics)
		// to learn how different parameters affect the shape.
		var flowerPath:UIBezierPath?
		
		let k: Double = 9/4
		let flowers: Array<Double>! = [Double(100), Double(75), Double(37.5)] // Each item represents a flower length
		
		for length in flowers { // len(flowers) = # of flowers
			let lFlowerPath:UIBezierPath = UIBezierPath()
			
			let points = cartesianCoordsForPolarFunc(frame: frame, thetaCoefficient: k, cosScalar: length,
													 iPrecision: 0.001, largestScalar: flowers.max()!)
			lFlowerPath.move(to: points[0])
			for i in 2...points.count {// Wtf shouldn't theta be going from 0 to 6.28
				lFlowerPath.addLine(to: points[i-1])
				
				// Adnimate drawing the stroke.
				if animate {
					DispatchQueue.main.sync {
						let pointView:UIView = UIView(frame: CGRect(x: points[i-1].x, y:points[i-1].y, width:1, height:1))
						pointView.backgroundColor = self.strokeColor!
						self.addSubview(pointView)
					}
				}
			}
			
			//lFlowerPath.close()
			print("Closed flower")

			if flowerPath == nil {
				flowerPath = lFlowerPath
				
			} else {
				flowerPath!.append(lFlowerPath)
			}
		}
		
		flowerPath!.close()
		print("Closed Path")
		
		// Create a mask with the path
		DispatchQueue.main.async {
			let flowerShapeLayer = CAShapeLayer()
			flowerShapeLayer.path = flowerPath!.cgPath
			flowerShapeLayer.strokeColor = self.strokeColor!.cgColor
			flowerShapeLayer.fillColor = self.fillColor!.cgColor
			flowerShapeLayer.fillRule = .evenOdd
			flowerShapeLayer.shouldRasterize = true
			flowerShapeLayer.rasterizationScale = 2.0 * UIScreen.main.scale;
					
			self.layer.addSublayer(flowerShapeLayer)
		}
	}
}
