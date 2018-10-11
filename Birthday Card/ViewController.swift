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
		
		let flowerFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height/4, width: 50, height: 50)
		DispatchQueue.main.async {
			let flowerView: FlowerView = FlowerView(frame: flowerFrame, strokeColor: #colorLiteral(red: 0.9725490196, green: 0.8274509804, blue: 0.2901960784, alpha: 1), fillColor: #colorLiteral(red: 0.9725490196, green: 0.8274509804, blue: 0.2901960784, alpha: 1))
			self.view.addSubview(flowerView)
		}
	}
}

