//
//  PolarCurveCalculator.swift
//  Birthday Card
//
//  Created by Georges Kanaan on 11/10/2018.
//  Copyright © 2018 Georges Kanaan. All rights reserved.
//

import Foundation
import CoreGraphics

func cartesianCoordsForPolarFunc(frame: CGRect, thetaCoefficient:Double, thetaCoefficientDenominator:Double, cosScalar:Double, iPrecision:Double, largestScalar:Double) -> Array<CGPoint> {
	
	// Frame: The frame in which to fit this curve.
	// thetaCoefficient: The number to scale theta by in the cos.
	// cosScalar: The number to multiply the cos by.
	// largestScalar: Largest cosScalar used in this frame so that scaling is relative.
	// iPrecision: The step for continuity. 0 < iPrecision <= 2.pi. Defaults to 0.1
	
	// Clean inputs
	var precision:Double = 0.1 // Default precision
	if iPrecision != 0 {// Can't be 0.
		precision = iPrecision
	}
	
	var cThetaCoefficientDenominator:Double = 1 // Default coefficient
	if thetaCoefficientDenominator != 0 {
		cThetaCoefficientDenominator = thetaCoefficientDenominator
	}
	
	// This is ther polar function
	// var theta: Double = 0 //  0 <= theta <= 2pi
	// let r = cosScalar * cos(thetaCoefficient * theta)
	
	var points:Array<CGPoint> = [] // We store the points here
	let upperBound:Double = Double.pi * 2 * cThetaCoefficientDenominator
	
	for theta in stride(from: 0, to: upperBound, by: precision) { // Try to recreate continuity.
		let x = cosScalar * cos(thetaCoefficient * theta) * cos(theta) // Convert to cartesian
		let y = cosScalar * cos(thetaCoefficient * theta) * sin(theta) // Convert to cartesian
		
		// newvalue = (max'-min')/(max-min)*(value-max)+max'
		let scaled_x = (Double(frame.width) - 0)/(largestScalar*2)*(x-largestScalar)+Double(frame.width) // Scale to the frame
		let scaled_y = (Double(frame.height) - 0)/(largestScalar*2)*(y-largestScalar)+Double(frame.height) // Scale to the frame
		
		points.append(CGPoint(x: scaled_x, y:scaled_y)) // Add the result

	}

	return points
}
