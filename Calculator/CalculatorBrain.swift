//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Chunseop on 7/29/15.
//  Copyright (c) 2015 Chunseop. All rights reserved.
//

import Foundation

public class CalculatorBrain {
    private enum Op: Printable {    // just class has inherit, enum just can implements
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    //    var opStack = Array[Op]()
    private var opStack = [Op]()
    
    //    var knownOps = Dictionary<String, Op>()
    private var knownOps = [String : Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("x", *))
        
        
        //        knownOps["*"] = Op.BinaryOperation("*") { $0 * $1 }
        //        knownOps["*"] = Op.BinaryOperation("*", *)
        knownOps["/"] = Op.BinaryOperation("/") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+") { $0 + $1 }
        knownOps["-"] = Op.BinaryOperation("-") { $1 - $0 }
        //        knownOps["√"] = Op.UnaryOperation("√") { sqrt($0) }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {     // Array and Dictionary(even int and double) are Structure. Structure passed by value, class passed by referrence
        if !ops.isEmpty {
            var remainingOps = ops  // get value copy, but not really copy.
            let op = remainingOps.removeLast()  // swift get real value copy on this time. just copy minimum
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation): // '_' means I don't care about this
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack) // tuple
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        return evaluate()
    }
}