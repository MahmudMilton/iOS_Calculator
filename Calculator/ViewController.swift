//
//  ViewController.swift
//  Calculator
//
//  Created by Mahmud Milton on 12/24/16.
//  Copyright © 2016 Mahmud Milton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func buttonClicked(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." && display.text!.range(of: ".") != nil {
            return
        }
        
        if userIsInTheMiddleOfTyping {
            let currentlyInDisplay = display.text!
            display.text = currentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    
    private var brain = CalculatorBrain()
    
    @IBAction private func operationPerformed(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
    }
}

