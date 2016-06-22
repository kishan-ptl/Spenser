//
//  ViewController.swift
//  Spenser
//
//  Created by Kishan Patel on 1/7/16.
//  Copyright © 2016 Kishan Patel. All rights reserved.
//

import UIKit

class KeyPadViewController: UIViewController, UITextFieldDelegate {

    //IMPLEMENT SPLIT VIEW CONTROLLER MAYBE? maybe not idk look into it
    
    
    @IBOutlet weak var sum: UILabel!

    //bools
    var canBackspace = false
    var canPressAddExpense = false
    var addExpenseWasPressed = false
    var userIsInTheMiddleOfTyping = false
    var decimalPointWasUsed = false
    
    //constraints
    var heightConstraint : NSLayoutConstraint? = nil
    var entireHeightConstraint: NSLayoutConstraint? = nil
    
    
    var defaults = NSUserDefaults.standardUserDefaults()
    //var expensesArray : [(price: Double, description: String)] = NSUserDefaults.standardUserDefaults().objectForKey("expensesArray") as? [(price: Double, description: String)] ?? []
    var descriptionArray : [String] = NSUserDefaults.standardUserDefaults().objectForKey("descriptionArray") as? [String] ?? []
    var expensesArray : [Double] = NSUserDefaults.standardUserDefaults().objectForKey("expensesArray") as? [Double] ?? []

    
    var x : Double = 0
    
    var runningTotal : Double {
        return expensesArray.reduce(0, combine: +)
    }
    
    func updateUI() {
        sum.text! = "Total: \(runningTotal)"
        canBackspace = false        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destViewController : HistoryViewController = segue.destinationViewController as! HistoryViewController
        destViewController.expensesHistory = expensesArray
        destViewController.descriptionHistory = descriptionArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        self.descriptionTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        descriptionTextField.resignFirstResponder()
        return true
    }
    
    
    @IBOutlet weak var keysView: UIView!
    
    
    @IBOutlet weak var entireView: UIView!
    
    func keyboardWillShow(notification: NSNotification) {
        
        heightConstraint = NSLayoutConstraint(item: keysView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
        entireHeightConstraint = NSLayoutConstraint(item: entireView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 300)
        
        for view in keysView.subviews {
            view.hidden = true
        }
        keysView.addConstraint(heightConstraint!)
        entireView.addConstraint(entireHeightConstraint!)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        keysView.removeConstraint(heightConstraint!)
        entireView.removeConstraint(entireHeightConstraint!)
        for view in keysView.subviews {
            view.hidden = false
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle
        canBackspace = true

        if userIsInTheMiddleOfTyping {
            sum!.text = sum!.text! + digit!
        }
        else {
            sum!.text = digit!
            userIsInTheMiddleOfTyping = true
            canPressAddExpense = true
        }
    }

    @IBAction func appendDecimal() {
        if !decimalPointWasUsed {
            sum!.text = sum!.text! + "."
            decimalPointWasUsed = true
        }
    }
    
    @IBAction func addExpense() {
        if canPressAddExpense {
        userIsInTheMiddleOfTyping = false
        decimalPointWasUsed = false
            if sum.text!.characters.count > 0 {
                expensesArray.append(Double(sum.text!)!)
                if descriptionTextField.text != "" {
                    //expensesArray.append((Double(sum.text!)!, descriptionTextField.text!))
                    descriptionArray.append(descriptionTextField.text!)
                }
                else {
                    //expensesArray.append((Double(sum.text!)!, "NA"))
                    descriptionArray.append("NA")
                }
            }
        //defaults.setObject(expensesArray, forKey: "expensesArray")
        defaults.setObject(descriptionArray, forKey: "descriptionArray")
        defaults.setObject(expensesArray, forKey: "expensesArray")
        defaults.synchronize()
        
        sum.text! = "Total: \(runningTotal)"
        canBackspace = false
        canPressAddExpense = false
        descriptionTextField.text?.removeAll()
        descriptionTextField.resignFirstResponder()
        }
        
    }
    
    @IBAction func backspaceButtonPress() {
        if (sum.text!.characters.count > 0 && canBackspace) {
            sum.text!.removeAtIndex(sum.text!.endIndex.predecessor())
        }
    }
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
}

