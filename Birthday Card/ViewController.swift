//
//  ViewController.swift
//  Birthday Card
//
//  Created by Georges Kanaan on 10/10/2018.
//  Copyright © 2018 Georges Kanaan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Set the background color
		self.view.backgroundColor = #colorLiteral(red: 0.7970689535, green: 1, blue: 0, alpha: 1)
		
		DispatchQueue.main.async {
			let frameWidth:CGFloat  = self.view.frame.width
			let frameHeight:CGFloat = self.view.frame.height
			let flowerDimension:CGFloat = frameWidth * 0.6

			let flowerFrame:CGRect = CGRect(x: frameWidth/2 - flowerDimension/2, y: frameHeight/10, width: flowerDimension, height: flowerDimension)
			let fillPatternColor: UIColor = UIColor.init(patternImage: UIImage(named: "flowerPattern")!)
			let flowerView: FlowerView = FlowerView(frame: flowerFrame, strokeColor: #colorLiteral(red: 0.9725490196, green: 0.8274509804, blue: 0.2901960784, alpha: 1), fillColor: fillPatternColor)
			self.view.addSubview(flowerView)
		}
	}
}

