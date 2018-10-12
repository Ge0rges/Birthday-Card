//
//  ViewController.swift
//  Birthday Card
//
//  Created by Georges Kanaan on 10/10/2018.
//  Copyright © 2018 Georges Kanaan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	var flowerView:FlowerView?
	var guideLabel:UITextView?
	
	var prompts: Array<String> = ["Prompt 1", "Prompt 2"]
	var promptIndex:Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Set the background color 
		self.view.backgroundColor = #colorLiteral(red: 0.7568627451, green: 0.662745098, blue: 0.3647058824, alpha: 1)
		
		// Create the flower view
		let frameWidth:CGFloat  = self.view.frame.width
		let frameHeight:CGFloat = self.view.frame.height
		let flowerDimension:CGFloat = frameWidth * 0.6
		
		let flowerFrame:CGRect = CGRect(x: frameWidth/2 - flowerDimension/2, y: frameHeight/10, width: flowerDimension, height: flowerDimension)
		let fillPatternColor: UIColor = UIColor.init(patternImage: UIImage(named: "flowerPattern")!)
		 self.flowerView = FlowerView(frame: flowerFrame, strokeColor: #colorLiteral(red: 0.5333333333, green: 0.4470588235, blue: 0.137254902, alpha: 1), fillColor: fillPatternColor)
		self.view.addSubview(self.flowerView!)
		
		// Disable touches
		self.view.isUserInteractionEnabled = false
		
		// Create the guide label
		self.guideLabel = UITextView()
		self.guideLabel!.alpha = 0.0
		self.guideLabel!.textColor = UIColor.white
		self.guideLabel!.font = UIFont.boldSystemFont(ofSize: 24)
		self.guideLabel!.textAlignment = .center
		self.guideLabel!.backgroundColor = UIColor.clear
		self.guideLabel!.isEditable = false

		self.view.addSubview(self.guideLabel!)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if self.flowerView != nil {
			self.flowerView?.draw(animate: true, completion: {
				// Show the first text prompt
				self.nextPrompt()
				
				// Enable touch
				self.view.isUserInteractionEnabled = true
			})
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		// Show next prompt
		self.nextPrompt()
	}
	
	// Helpers
	func nextPrompt() {
		if promptIndex !=  prompts.count {
			self.setLabelText(for: self.prompts[promptIndex], animate: true, completion:{_ in})
			promptIndex += 1
			
		} else {
			// Reset prompts
			promptIndex = 0
			
			// Disable touch
			self.view.isUserInteractionEnabled = false
			
			// Hide label while we draw
			UIView.animate(withDuration: 0.6, animations: {
				self.guideLabel!.alpha = 0.0
			})
			
			// Draw anew
			self.flowerView?.draw(animate: true, completion: {
				// Show the first text prompt
				self.nextPrompt()
				
				// Enable touch
				self.view.isUserInteractionEnabled = true
			})
		}
	}
	
	func setLabelText(for text:String, animate:Bool, completion: @escaping (Bool) -> Void) {
		if animate {
			// Animate the label
			UIView.animate(withDuration: 0.6, animations: {
				self.guideLabel!.alpha = 0.0
				
			}, completion: {_ in
				// Change the text and resize label
				self.guideLabel!.text = text
				let height = self.estimatedHeight(forWidth: self.guideLabel!.frame.width, text: text, ofSize: self.guideLabel!.font!.pointSize) + 10
				self.guideLabel!.frame = CGRect(x: 0, y: self.view.frame.height/2 - height/2,
												width: self.view.frame.width, height: height)
				
				// Animate change
				UIView.animate(withDuration: 0.6, animations: {
					self.guideLabel!.alpha = 1.0
				}, completion: completion)
			})
		}
	}
	
	func estimatedHeight(forWidth: CGFloat, text: String, ofSize: CGFloat) -> CGFloat {
		let size = CGSize(width: forWidth, height: CGFloat(MAXFLOAT))
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ofSize)]
		let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
		
		return ceil(rectangleHeight)
	}
}

