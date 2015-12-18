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
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // sets segmented control to unselected as a default
    var intValue = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // compare stored closing date to now
        // and use if less than 10 minutes
        if (NSDate().timeIntervalSinceDate(defaults.objectForKey("time_closed") as! NSDate) < 600)
        {
            billField.text = (defaults.objectForKey("recent_bill") as! String)
            
        }
        
        let cgHeight = billField.frame.height
        let cgWidth = billField.frame.width
        let cgX = billField.frame.origin.x
        let cgY = billField.frame.origin.y
        

        billField.frame.insetInPlace(dx: 3, dy: 5)
        
        print("X " + cgX.description + " Y " + cgY.description)
        print("Height " + (cgHeight.description))
        print("Width " + (cgWidth.description))

        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        
        if (billField.text == "")
        {
            alphaModify(0)
            growBillField(true)
        }
        else
        {
            alphaModify(1)
            growBillField(true)
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
            UIView.animateWithDuration(1.0, animations:
                {
                    self.alphaModify(0)
                    self.growBillField(true)
            })
        }
        else
        {
            UIView.animateWithDuration(1.0, animations:
                {
                    self.alphaModify(1)
                    self.growBillField(false)
            })
            
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
        // pass the segment control to the percentage func
        let tipPercent = getTipPercentage(tipControl.selectedSegmentIndex)
        
        let billAmount = NSString(string: billField.text!).doubleValue
        
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

    func alphaModify(newAlpha: CGFloat)
    {
        tipLabel.alpha = newAlpha
        totalLabel.alpha = newAlpha
        tipControl.alpha = newAlpha
        billText.alpha = newAlpha
        tipText.alpha = newAlpha
        totalText.alpha = newAlpha
    }
    
    func growBillField(grow: Bool)
    {
        let normRect = CGRect(x: 176, y: 79, width: 30, height: 124)
        let largetRect = CGRect(x: 176, y: 79, width: 90, height: 372)

        if (grow)
        {
            billField.drawRect(largetRect)
        }
        else
        {
            billField.drawRect(normRect)
        }
    }
    
}

