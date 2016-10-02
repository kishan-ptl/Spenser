//
//  HistoryViewController.swift
//  Spenser
//
//  Created by Kishan Patel on 1/8/16.
//  Copyright © 2016 Kishan Patel. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    var clearButtonPressed = false
    var expensesHistory = [Double]()
    var descriptionHistory = [String]()
    var expensesString = ""
    var descriptionString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var expensesTextView: UITextView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        for desc in descriptionHistory {
            descriptionString += "\(desc) :\n"
        }
        for exp in expensesHistory {
            expensesString += "\(exp)\n"
        }
        
        descriptionTextView.text = descriptionString
        expensesTextView.text = expensesString
        
    }

    

    @IBAction func clearButtonPress(_ sender: UIBarButtonItem) {
        expensesHistory.removeAll()
        descriptionHistory.removeAll()
        descriptionString = ""
        expensesString = ""
        updateUI()
        clearButtonPressed = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let originViewController : KeyPadViewController = segue.destination as! KeyPadViewController
        if clearButtonPressed {
            originViewController.expensesArray.removeAll()
            originViewController.descriptionArray.removeAll()
            originViewController.defaults.set(originViewController.expensesArray, forKey: "expensesArray2")
            originViewController.defaults.set(originViewController.descriptionArray, forKey: "descriptionArray")
            clearButtonPressed = false
        }

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
