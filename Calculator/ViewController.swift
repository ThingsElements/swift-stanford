//
//  ViewController.swift
//  Calculator
//
//  Created by Chunseop on 7/26/15.
//  Copyright (c) 2015 Chunseop. All rights reserved.
//

import UIKit

public class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!    // @IBOutlet is xcode generated. weak: refernce count, heap, release
    
    var isMiddleNumber: Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!    // 1. let is constant, 2. ! means not nil, 3. if the value is null, it will crashs; 4. There's another way called 'Implicitly Unwrapped Optionals'
        if isMiddleNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            isMiddleNumber = true
        }
        
        println("disigt = \(digit)")
    }
    
    //    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        isMiddleNumber = false
        //        operandStack.append(displayValue)
        //        println("operandStack = \(operandStack)")
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        //        let operation = sender.currentTitle!
        //        if isMiddleNumber {
        //            enter()
        //        }
        //        switch operation {
        //        case "*": performOperation(multiply)
        //        case "/":
        ////            performOperation({ $1 / $0 })   // same as func devide
        ////            performOperation() { $1 / $0 }
        //            performOperation { $1 / $0 }
        //        case "+": performOperation { $0 + $1 }
        //        case "-": performOperation { $1 - $0 }
        //        case "√": performOperation { sqrt($0) }
        //        default:
        //            break
        //        }
        
        if isMiddleNumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    //
    //    func performOperation(operation: (Double, Double) -> Double) {  // operation is variable name; (Double, Double) -> Double: means a funciton(d, d) and return double
    //        if operandStack.count >= 2 {
    //            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
    //            enter()
    //        }
    //    }
    //
    //    func performOperation(operation: Double -> Double) {
    //        if operandStack.count >= 1 {
    //            displayValue = operation(operandStack.removeLast())
    //            enter()
    //        }
    //    }
    //
    //    func multiply(op1: Double, op2: Double) -> Double {
    //        return op1 * op2
    //    }
    //
    //    func devide(op1: Double, op2: Double) -> Double {
    //        return op1 / op2
    //    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            isMiddleNumber = false
        }
    }
}

