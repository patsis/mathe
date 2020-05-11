//
//  Operation.swift
//  mathe
//
//  Created by Harry Patsis on 30/04/2020.
//  Copyright © 2020 patsis. All rights reserved.
//

import Foundation


struct Operation {
	var term = ["", "", ""]
	var operand: String = ""
	var answer: String = ""
	var inputTerm = 2
	var finished = false

	var operandName: String {
		switch operand {
		case "+":
			return "add"
		case "−":
			return "sub"
		case "×":
			return "mul"
		case "÷":
			return "div"
		default:
			print("Error in Operation Struct")
			return ""
		}
	}


	var correct: Bool {
		return answer == term[inputTerm]
	}

	mutating func format(num1: Int, num2: Int, result: Int) {
		term = [String(num1), String(num2), String(result)]
	}

	/// add max is the result max
	mutating func makeADD(max: Int) {
		let result = Int.random(in: 1 ... max)
		let number1 = Int.random(in: 0 ... result)
		let number2 = result - number1
		format(num1: number1, num2: number2, result: result)
	}

	/// sub max is the numbers max
	mutating func makeSUB(max: Int) {
		var number1 = Int.random(in: 1 ... max)
		var number2 = Int.random(in: 0 ... max)
		if number2 > number1 {
			let num = number1
			number1 = number2
			number2 = num
		}
		let result = number1 - number2
		format(num1: number1, num2: number2, result: result)
	}

	/// mul max is the numbers max
	mutating func makeMUL(max: Int) {
		let number1 = Int.random(in: 1 ... max)
		let number2 = Int.random(in: 1 ... max)
		let result = number1 * number2
		format(num1: number1, num2: number2, result: result)
	}

	/// div max is the numbers max
	mutating func makeDIV(max: Int) {
		let number1 = Int.random(in: 1 ... max)
		let number2 = Int.random(in: 1 ... max)
		let result = number1 * number2
		format(num1: result, num2: number1, result: number2)
	}

	init(max: Int, allowed: [Bool]) {
		let ops = ["+", "−", "×", "÷"]
		/// filter-map magic
		let allowedOps: [String] = allowed
			.enumerated()
			.filter { $0.element == true }
			.map { ops[$0.offset]
		}
		let count = allowedOps.count
		operand = allowedOps[Int.random(in: 0..<count)]
		switch operand {
		case "+":
			makeADD(max: max)
		case "−":
			makeSUB(max: max)
		case "×":
			makeMUL(max: max)
		case "÷":
			makeDIV(max: max)
		default:
			print("Error in Operation Struct")
		}
	}

}

