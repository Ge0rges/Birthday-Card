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
	
	public func draw(animate: Bool, completion:@escaping () -> Void) {
		// Remove existing flower
		if self.layer.sublayers != nil {
			for layer in self.layer.sublayers! {
				// Fade out
				if animate {
					// Set the actual values when animation is done
					let fadeAnimation = CABasicAnimation(keyPath: "opacity")
					fadeAnimation.fromValue = 1
					fadeAnimation.toValue = 0.0
					fadeAnimation.duration = 0.6
					fadeAnimation.fillMode = .forwards
					
					layer.add(fadeAnimation, forKey: nil)
					
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + fadeAnimation.duration - 0.1, execute: {
						layer.opacity = 0.0
						layer.removeFromSuperlayer()
					})
					
				} else {
					layer.removeFromSuperlayer()
				}
			}
		}
		
		// Draw the flower
		let flowerFrame = self.frame
		DispatchQueue.global(qos: .background).async {
			self.drawFlower(frame: flowerFrame, animate: animate, completion: completion)
		}
	}
	
	private func drawFlower(frame: CGRect, animate:Bool, completion:@escaping () -> Void) {
		// Draw a flower (UIBezierPath) using polar coordinates: r = cos (k\theta) + c
		// We chose k = 9/4; c = 5 see https://en.wikipedia.org/wiki/Rose_(mathematics)
		// to learn how different parameters affect the shape.
		//var flowerPaths: Array<UIBezierPath> = []
		let k: Double = 9/4
		let flowers: Array<Double>! = [Double(100), Double(75), Double(37.5)] // Each item represents a flower length
		
		for length in flowers { // len(flowers) = # of flowers
			let flowerPath:UIBezierPath = UIBezierPath()
			
			let points = cartesianCoordsForPolarFunc(frame: frame, thetaCoefficient: k, cosScalar: length,
													 iPrecision: 0.001, largestScalar: flowers.max()!)
			flowerPath.move(to: points[0])
			for i in 2...points.count {// Wtf shouldn't theta be going from 0 to 6.28
				flowerPath.addLine(to: points[i-1])
			}
						
			flowerPath.close()
			
			// Create a mask with the path
			DispatchQueue.main.async {
				let flowerShapeLayer = CAShapeLayer()
				flowerShapeLayer.path = flowerPath.cgPath
				flowerShapeLayer.strokeColor = self.strokeColor!.cgColor
				flowerShapeLayer.fillColor = self.fillColor!.cgColor
				flowerShapeLayer.fillRule = .evenOdd
				flowerShapeLayer.shouldRasterize = true
				flowerShapeLayer.rasterizationScale = 2.0 * UIScreen.main.scale;
				
				if animate {
					// Set the actual values (CA has presentation layer + another)
					flowerShapeLayer.strokeStart = 1
					flowerShapeLayer.fillColor = UIColor.clear.cgColor
					
					// Create the stroke animation
					let strokeAnimation = CABasicAnimation(keyPath: "strokeStart")
					strokeAnimation.fromValue = 1
					strokeAnimation.toValue = 0.0
					strokeAnimation.duration = 4
					strokeAnimation.beginTime = 0
					strokeAnimation.fillMode = .forwards
					
					// Create the fill animation
					let fillAnimation = CABasicAnimation(keyPath: "fillColor")
					fillAnimation.fromValue = UIColor.clear.cgColor
					fillAnimation.toValue = self.fillColor!.cgColor
					fillAnimation.duration = 0.7
					fillAnimation.beginTime = strokeAnimation.duration - 0.1
					
					// Create the animation group
					let animationGroup = CAAnimationGroup()
					animationGroup.animations = [strokeAnimation, fillAnimation]
					for animation in animationGroup.animations! { // Calculate total animation duration
						animationGroup.duration += animation.duration
					}
					
					flowerShapeLayer.add(animationGroup, forKey: nil)
					
					// Set the actual values when animation is done
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + strokeAnimation.duration, execute: {
						flowerShapeLayer.strokeStart = 0.0
					})
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animationGroup.duration - 0.1, execute: {
						flowerShapeLayer.fillColor = self.fillColor!.cgColor
						
						// Completion only if this is the last flower with small delay for animation
						if length == flowers.last {
							DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
								completion()
							})
						}
					})
					
				} else {
					// Completion only if this is the last flower
					if length == flowers.last {
						DispatchQueue.main.async {
							completion()
						}
					}
				}
				
				// We're done add the layer.
				self.layer.addSublayer(flowerShapeLayer)
			}
		}
	}
}
