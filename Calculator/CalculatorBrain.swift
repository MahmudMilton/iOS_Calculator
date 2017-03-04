//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mahmud Milton on 12/28/16.
//  Copyright © 2016 Mahmud Milton. All rights reserved.
//

import Foundation

class CalculatorBrain{
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π"     : Operation.Constant(M_PI),
        "e"     : Operation.Constant(M_E),
        "+/-"   : Operation.UnaryOperation({ -$0 }),
        "√"     : Operation.UnaryOperation(sqrt),
        "sin"   : Operation.UnaryOperation(sin),
        "cos"   : Operation.UnaryOperation(cos),
        "tan"   : Operation.UnaryOperation(tan),
        "^"     : Operation.Square,
        "log"   : Operation.UnaryOperation(log10),
        "×"     : Operation.BinaryOperation({ $0 * $1 }),
        "÷"     : Operation.BinaryOperation({ $0 / $1 }),
        "+"     : Operation.BinaryOperation({ $0 + $1 }),
        "−"     : Operation.BinaryOperation({ $0 - $1 }),
        "C"     : Operation.Clear,
        "="     : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Square
        case Equals
        case Clear
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(
                binaryFunction: function, firstOperand:
                accumulator)
            case .Square:
                executeSquareOperation()
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                executeClearOperation()
            }
        }
    }
    
    private func executeSquareOperation() {
        accumulator = accumulator * accumulator
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private func executeClearOperation() {
        accumulator = 0
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
