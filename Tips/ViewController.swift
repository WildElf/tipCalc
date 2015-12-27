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
    
    // sets segmented control to unselected as a default
    var intValue = -1
    
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
        
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        
        if (billField.text == "")
        {
            showLabels(false)
            textVisible = false
        }

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        print("Will appear")
        
        // loads default tip setting, if it has been set
        if (defaults.objectForKey("default_tip") != nil) {
            intValue = defaults.integerForKey("default_tip")
            
            print("Found default tip")
            print(intValue)
        }

        print(defaults.integerForKey("default_tip"))
        
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
            print("turn off screen elements")
            activateScreenElements(false)
        }
        else if (!textVisible)
        {
            print("turn on screen elements")
            activateScreenElements(true)
        }
        

    }
    
    // $ prefix for billField
    func makePrefix() {
        let attributedString = NSMutableAttributedString(string: "$")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0,1))
        
        billField.attributedText = attributedString
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
        
        // pass the segment control to the percentage func
        let tipPercent = getTipPercentage(tipControl.selectedSegmentIndex)
        
        let billAmount = NSString(string: billField.text!).doubleValue
        
        print("billField: \(billField.text!)")
        print("billAmount: \(billAmount)")
        
        let tip = billAmount * tipPercent
        let total = billAmount + tip
                
        tipLabel.text = String (format: "$%.2f", tip)
        totalLabel.text = String (format: "$%.2f", total)

        // store the latest bill entry for later
        defaults.setValue(billField.text!, forKey: "recent_bill")
        
        defaults.synchronize()

    }
    
    // close the keyboard upon taking any part of the screen
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // screen animation control
    func activateScreenElements(turnOn: Bool)
    {
        
        print("animation call")
        
        if (!turnOn)
        {
            UIView.animateWithDuration(1.0, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .CurveEaseOut,
                animations:
                {
                    self.showLabels(false)
                },
                completion: {
                    (Bool) in
/*                    self.billField.font = UIFont.systemFontOfSize(64);                    self.billField.transform = CGAffineTransformScale(self.billField.transform, 1.0, 1.0)
*/                    print("elements off")
                    
            })
            
            textVisible = false
        }
        else // make screen elements visible
        {
            UIView.animateWithDuration(1.0, delay: 0.25, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.7, options: .CurveEaseIn,
                animations: {
                    
                    self.showLabels(true)
                    
                },
                completion: {
                    (Bool) in
/*                    self.billField.font = UIFont.systemFontOfSize(16);
                    self.billField.transform = CGAffineTransformScale(self.billField.transform, 1.0, 1.0)
*/                   print("elements on")
            })
            
            textVisible = true
        }
        
    }

    // animation control to enter from left
    func showLabels(enter: Bool)
    {
        var move: CGFloat = -1
        
        if (enter)
        {
            move *= -1
        }
        
        tipLabel.center.x += view.bounds.width * move
        totalLabel.center.x += view.bounds.width * move
        tipControl.center.x += view.bounds.width * move
        billText.center.x += view.bounds.width * move
        tipText.center.x += view.bounds.width * move
        totalText.center.x += view.bounds.width * move
        barDivider.center.x += view.bounds.width * move

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

