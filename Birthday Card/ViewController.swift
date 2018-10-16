//
//  ViewController.swift
//  Birthday Card
//
//  Created by Georges Kanaan on 10/10/2018.
//  Copyright © 2018 Georges Kanaan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	// Birthdate
	let birthdayDay:Int = 01
	let birthdayMonth:Int = 01

	// View
	var flowerView:FlowerView?
	var guideLabel:UITextView?
	var easterEggImageView:UIImageView?
	
	// Text
	var prompts: Array<String>! = [""]
	var promptIndex:Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Set the background color
		self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1)
		
		// Set the background gradient
		if self.isTodayBirthday().0 {
			let gradientLayer:CAGradientLayer = CAGradientLayer()
			gradientLayer.frame = self.view.bounds
			gradientLayer.colors = [#colorLiteral(red: 1, green: 0.07489942989, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1).cgColor]
			gradientLayer.drawsAsynchronously = true
			
			self.view.layer.insertSublayer(gradientLayer, at: 0)
		}
		
		// Create the flower view
		let frameWidth:CGFloat  = self.view.frame.width
		let frameHeight:CGFloat = self.view.frame.height
		let flowerDimension:CGFloat = frameWidth * 0.6
		
		let flowerFrame:CGRect = CGRect(x: frameWidth/2 - flowerDimension/2, y: frameHeight/10, width: flowerDimension, height: flowerDimension)
		let fillPatternColor: UIColor = UIColor.init(patternImage: #imageLiteral(resourceName: "flowerPattern"))
		self.flowerView = FlowerView(frame: flowerFrame, strokeColor: #colorLiteral(red: 0.9998956323, green: 1, blue: 0, alpha: 1), fillColor: fillPatternColor)
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
		
		// Create and hide the image view
		self.easterEggImageView = UIImageView(frame: self.view.frame)
		self.easterEggImageView!.isHidden = true
		self.easterEggImageView!.image = #imageLiteral(resourceName: "margoDerp")
		self.easterEggImageView!.contentMode = .scaleAspectFit
		self.easterEggImageView!.backgroundColor = UIColor.black
		self.easterEggImageView!.alpha = 0.0

		self.view.addSubview(self.easterEggImageView!)
		
		// Become first responder for shake easter egg
		self.becomeFirstResponder()
	}
	
	// We are willing to become first responder to get shake motion
	override var canBecomeFirstResponder: Bool {
			return true
	}
	
	// Enable detection of shake motion
	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		if motion == .motionShake && self.easterEggImageView!.isHidden && self.isTodayBirthday().0 {
			self.easterEggImageView!.isHidden = false
			UIView.animate(withDuration: 0.3) {
				self.easterEggImageView!.alpha = 1.0
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		let isTodayBirthday = self.isTodayBirthday()
		if  isTodayBirthday.0 {
			self.flowerView?.draw(animate: true, completion: {
				// Show the first text prompt
				self.nextPrompt()
				
				// Enable touch
				self.view.isUserInteractionEnabled = true
			})
			
		} else {
			self.setLabelText(for: isTodayBirthday.1, animate: animated, completion:{_ in})
			promptIndex -= 1
			
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
				self.viewDidAppear(false)
			})
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if self.easterEggImageView!.isHidden {
			// Show next prompt
			self.nextPrompt()
			
		} else { // Hide easter egg
			self.setLabelText(for: "This is why we take pictures.", animate: true, completion:{_ in})
			promptIndex -= 1
			UIView.animate(withDuration: 0.3, animations: {
				self.easterEggImageView!.alpha = 0.0
				
			}, completion: { _ in
				self.easterEggImageView!.isHidden = true
			})
		}
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
				self.guideLabel!.frame = CGRect(x: 0, y: self.view.frame.height/2 - height/2, width: self.view.frame.width, height: height)
				
				// Animate change
				UIView.animate(withDuration: 0.6, animations: {
					self.guideLabel!.alpha = 1.0
				}, completion: completion)
			})
			
		} else {
			self.guideLabel!.text = text
			let height = self.estimatedHeight(forWidth: self.guideLabel!.frame.width, text: text, ofSize: self.guideLabel!.font!.pointSize) + 10
			self.guideLabel!.frame = CGRect(x: 0, y: self.view.frame.height/2 - height/2, width: self.view.frame.width, height: height)
			self.guideLabel!.alpha = 1.0
		}
	}
	
	func estimatedHeight(forWidth: CGFloat, text: String, ofSize: CGFloat) -> CGFloat {
		let size = CGSize(width: forWidth, height: CGFloat(MAXFLOAT))
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ofSize)]
		let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
		
		return ceil(rectangleHeight)
	}
	
	func isTodayBirthday() -> (Bool, String) {
		let todayDate:Date = Date()
		let calendar:Calendar = Calendar.current
		let todayMonth:Int = calendar.component(.month, from: todayDate)
		let todayDay:Int = calendar.component(.day, from: todayDate)

		// Get next birthday
		var components:DateComponents = DateComponents()
		components.month = self.birthdayMonth
		components.day = self.birthdayDay
		let birthdayDate:Date = calendar.nextDate(after: todayDate, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)!
		let nextBirthdayYear = calendar.component(.year, from: birthdayDate)
		
		let difference = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: todayDate, to: birthdayDate)
		var timeLeftString: String = ""
		
		if difference.month! > 0 {
			timeLeftString += "\(difference.month!) Month"
			if difference.month! > 1 {
				timeLeftString += "s"
			}
			
		} else if difference.day! > 0 {
			timeLeftString += "\(difference.day!) Day"
			if difference.day! > 1 {
				timeLeftString += "s"
			}

		} else if difference.hour! > 0 {
			timeLeftString += "\(difference.hour!) Hour"
			if difference.hour! > 1 {
				timeLeftString += "s"
			}

		} else if difference.minute! > 0 {
			timeLeftString += "\(difference.minute!):\(difference.second!) Minutes"

		} else {
			timeLeftString += "\(difference.second!)"
		}
		
		return (todayMonth == self.birthdayMonth && todayDay == self.birthdayDay || nextBirthdayYear > 2018, timeLeftString)
	}
}

