//
//  ViewController.swift
//  Tips
//
//  Created by Eric Zim on 11/30/15.
//  Copyright © 2015 Eric Zim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var billField: UITextField!
	
	@IBOutlet weak var tipLabel: UILabel!
	
	@IBOutlet weak var totalLabel: UILabel!
	
	@IBOutlet weak var tipControl: UISegmentedControl!
	
	@IBOutlet weak var billText: UILabel!
	
	@IBOutlet weak var tipText: UILabel!
	
	@IBOutlet weak var totalText: UILabel!
	
	@IBOutlet weak var barDivider: UIView!

	let defaults = NSUserDefaults.standardUserDefaults()
	
	let currency = NSNumberFormatter()
	
	var thisLocale = ""
	
	// sets segmented control to unselected as a default
	var intValue = -1
	
	// safe animation control, see: onEditingChanged
	var textVisible = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// compare stored closing date to now
		// and use if less than 10 minutes
		if (NSDate().timeIntervalSinceDate(defaults.objectForKey("time_closed") as! NSDate) < 600)
		{
			billField.text = (defaults.objectForKey("recent_bill") as! String)
			
		}
		
		// set locale to phone default if app has not been used in over a week
		if (NSDate().timeIntervalSinceDate(defaults.objectForKey("time_closed") as! NSDate) > 10080)
		{
			defaults.setValue(NSLocale.preferredLanguages()[0], forKey: "default_locale")
		}
		
		updateLocale()
		
		print(currency.stringFromNumber(54321.12345))
		print(NSLocale.preferredLanguages())
		
		print(currency.currencySymbol)
		
		tipLabel.text = currency.stringFromNumber(0.00)
		totalLabel.text = currency.stringFromNumber(0.00)

		
		if (billField.text == "")
		{
			quickHideLabels()
			textVisible = false
		}
		
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// loads default tip setting, if it has been set
		if (defaults.objectForKey("default_tip") != nil) {
			intValue = defaults.integerForKey("default_tip")
			
			print(intValue)
		}
		
//		print(defaults.integerForKey("default_tip"))
		
		// uses the default value, using -1 if none exists
		tipControl.selectedSegmentIndex = intValue
		
		updateLabels()
		
	}
	
	override func viewDidAppear(animated: Bool) {
		
		// set bill field to first responder
		// autoload the keyboard
		billField.becomeFirstResponder()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func onEditingChanged(sender: AnyObject) {
		
		updateLabels()
		
		if (billField.text == "")
		{
			activateScreenElements(false)
		}
		else if (!textVisible)
		{
			activateScreenElements(true)
		}
		
		
	}


	// store the segment values/array in its own function
	func getTipPercentage(index: Int) -> Double {
		if (index >= 0)
		{
			let tipPercentages = [ 0.18, 0.2, 0.22, 0.25 ]
			
			return tipPercentages[index]
		}
		else // in case of -1
		{
			return (0.0)
		}
	}
	
	// function to use anytime data may have changed
	func updateLabels()
	{
		if (thisLocale != defaults.stringForKey("default_locale")!)
		{
			updateLocale()
		}
		// pass the segment control to the percentage func
		let tipPercent = getTipPercentage(tipControl.selectedSegmentIndex)
		
		let billAmount = NSString(string: billField.text!).doubleValue
		
//		print("billField: \(billField.text!)")
//		print("billAmount: \(billAmount)")
		
		let tip = billAmount * tipPercent
		let total = billAmount + tip
		
		tipLabel.text = currency.stringFromNumber(tip)
		totalLabel.text = currency.stringFromNumber(total)
		
		// store the latest bill entry for later
		defaults.setValue(billField.text!, forKey: "recent_bill")
		
		defaults.synchronize()

	}
	
	// to be called from multiple locations
	func updateLocale()
	{
		// check for locale setting
		if (defaults.stringForKey("default_locale") == nil)
		{
			thisLocale = NSLocale.preferredLanguages()[0]
		}
		else
		{
			thisLocale = defaults.stringForKey("default_locale")!
		}

		currency.numberStyle = NSNumberFormatterStyle.CurrencyStyle
		currency.locale = NSLocale(localeIdentifier: thisLocale)

	}
	
	// close the keyboard upon taking any part of the screen
	@IBAction func onTap(sender: AnyObject) {
		view.endEditing(true)
	}
	

	// ******************
	// Animation controls
	// ******************

	// screen animation control
	func activateScreenElements(turnOn: Bool)
	{
		
		if (!turnOn)
		{
			self.showLabels(false)
			textVisible = false
		}
		else
		{
			self.showLabels(true)
			textVisible = true
		}
		
	}
	
	
	
	// hide UI elements without animations
	func quickHideLabels()
	{
		self.billText.center.x -= self.view.bounds.width
		self.tipText.center.x -= self.view.bounds.width
		self.totalText.center.x -= self.view.bounds.width
		self.tipLabel.center.x -= self.view.bounds.width
		self.totalLabel.center.x -= self.view.bounds.width
		self.barDivider.center.x -= self.view.bounds.width
		self.tipControl.center.x -= self.view.bounds.width
	}
	
	
	
	
	// animation control to enter from left if true
	// exit to left if false
	func showLabels(enter: Bool)
	{
		var move: CGFloat = 1
		var shift: Double = 0.0
		
		if (!enter)
		{
			move *= -1
			shift = Double(move)
		}
		
		
		// *********
		// Fixed text labels
		UIView.animateWithDuration(0.6, delay: 0.1 + shift, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .CurveEaseIn, animations: {
			
			self.billText.center.x += self.view.bounds.width * move
			
			}, completion: nil)
		
		UIView.animateWithDuration(0.6, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .CurveEaseIn, animations: {
			
			self.tipText.center.x += self.view.bounds.width * move
			
			}, completion: nil)
		
		UIView.animateWithDuration(0.6, delay: 0.3, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .CurveEaseIn, animations: {
			
			self.totalText.center.x += self.view.bounds.width * move
			
			}, completion: nil)
		// *******
		
		// **************
		// UI variable text labels
		UIView.animateWithDuration(0.5, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .CurveEaseIn, animations: {
			
			self.tipLabel.center.x += self.view.bounds.width * move
			
			}, completion: nil)
		
		UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .CurveEaseIn, animations: {
			
			self.totalLabel.center.x += self.view.bounds.width * move
			
			}, completion: nil)
		// **************
		
		// bar divider
		UIView.animateWithDuration(1.5, delay: 0.0 - shift, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .CurveEaseInOut, animations: {
			
			self.barDivider.center.x += self.view.bounds.width * move
			
			}, completion: nil)
		
		// segmented control
		UIView.animateWithDuration(1.2, delay: 0.5 + shift, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .CurveEaseIn, animations: {
			
			self.tipControl.center.x += self.view.bounds.width * move
			
			}, completion: nil)
		
	}
	
	// **************
	// **deprecated**
	// **************
	
	// $ prefix for billField
	func makePrefix() {
		let attributedString = NSMutableAttributedString(string: currency.currencySymbol)
		attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0,1))
		
		billField.attributedText = attributedString
	}

	// for animation control of fade in and out
	func alphaModify(newAlpha: CGFloat)
	{
		tipLabel.alpha = newAlpha
		totalLabel.alpha = newAlpha
		tipControl.alpha = newAlpha
		billText.alpha = newAlpha
		tipText.alpha = newAlpha
		totalText.alpha = newAlpha
		barDivider.alpha = newAlpha
	}
	
	// for animation control of billField size
	func growBillField(grow: Bool)
	{
		
		if (grow)
		{
			print("grow true")
			
			billField.bounds.size = CGSize(width: 124, height: 60)
			
		}
		else
		{
			print("grow false")
			
			billField.bounds.size = CGSize(width: 124, height: 30)
			
		}
		
	}
	
}

