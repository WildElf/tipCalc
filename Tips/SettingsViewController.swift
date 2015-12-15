//
//  SettingsViewController.swift
//  Tips
//
//  Created by Eric Zim on 12/2/15.
//  Copyright © 2015 Eric Zim. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // set the segment to the last stored default
        defaultTipControl.selectedSegmentIndex = defaults.integerForKey("default_tip")
    }
    
    override func viewWillDisappear(animated: Bool) {

    }

    @IBAction func onDefaultChanged(sender: AnyObject) {
        
        // create/update the default selection
        defaults.setInteger(defaultTipControl.selectedSegmentIndex, forKey: "default_tip")
        defaults.synchronize()
        
        print(defaults.integerForKey("default_tip"))

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        defaults.synchronize()
        
        print("IN SEGUE")
        print(defaults.integerForKey("default_tip"))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
