//
//  OperationModel.swift
//  mathe
//
//  Created by Harry Patsis on 02/05/2020.
//  Copyright © 2020 patsis. All rights reserved.
//

import Foundation
import UIKit

enum GameState {
	case start
	case playing
	case finished
	case settings
}

public class OperationModel: ObservableObject {
//	@Published var oplines: [OpLine] = []
	@Published var operations: [Operation] = []
	@Published var digits: String = ""
	@Published var operands: [Bool] = [true, false, false, false]
	@Published var updateView: Bool = false
	@Published var clearState: Bool = false

	fileprivate var totalStats: [String: Int] = [:]//"add": 0, "sub": 0, "mul": 0, "div": 0]
	fileprivate var correctStats: [String: Int] = [:]//"add": 0, "sub": 0, "mul": 0, "div": 0]

	@Published var state: GameState = .start
	var progress: CGFloat {
		if totalOperations > 0 {
			return CGFloat(answeredOperations) / CGFloat(totalOperations)
		} else {
			return 0
		}
	}

	var answeredOperations: Int = 0
	var totalOperations: Int = 0
	var correctOperations: Int = 0

	var hasDigits: Bool {
		if operations.count > 0 {
			return operations[0].answer.count > 0
		}
		return false
	}

	var opline: OpLine? = nil

	func setTotal(total: Int) {
		self.totalOperations = total
	}

	func start() {
		clear()
		state = .playing
	}

	func clear() {
		digits = ""
		operations = []
		opline = nil
		correctOperations = 0;
		answeredOperations = 0
	}

	func clearStats() {
		if self.clearState {
			totalStats = [:]//"add": 0, "sub": 0, "mul": 0, "div": 0]
			correctStats = [:]//"add": 0, "sub": 0, "mul": 0, "div": 0]
//			updateView.toggle()
		}
		self.clearState.toggle()
	}

	func toggleSettings() {
		if self.state == .settings {
			self.state = .playing
		} else {
			//								self.isUp = false
			self.clearState = false
			self.state = .settings
		}

	}


	func statFor(operation: String) -> CGFloat {
		guard  let correct = correctStats[operation], let total = totalStats[operation], total > 0 else {
			return 0
		}
		let percentage: CGFloat = CGFloat(correct) / CGFloat(total)
		return percentage
	}

	func newOperation() {
		digits = ""
		let operation = Operation(max: 10, allowed: operands)
		operations.insert(operation, at: 0)
	}

	func oplineFor(id: Int) -> OpLine {
		return OpLine(id: id, operation: operations[id], isActive: id == 0)
	}

	func addDigit(digit: Int) {
		if operations.count > 0 && operations[0].answer.count < 3 {
			operations[0].answer += String(digit)
		}
	}

	func deleteDigit() {
		if operations.count > 0 && operations[0].answer.count > 0 {
			operations[0].answer.removeLast()
		}
	}

	func validateAnswer() {
		if hasDigits {
			if operations.count > 0 {
				operations[0].finished = true

				let name = operations[0].operandName
				totalStats[name] = (totalStats[name] ?? 0) + 1

				if operations[0].correct {
					correctOperations += 1
					correctStats[name] = (correctStats[name] ?? 0) + 1
				}
				answeredOperations += 1
				if answeredOperations == totalOperations {
					state = .finished
				}
			}
			if state == .playing {
				newOperation()
			}
		}
	}

	func toggleOperand(at: Int) {
		for i in 0...3 {
			if i != at && operands[i] == true {
				operands[at] = !operands[at]
				self.clearState = false
				return
			}
		}
	}

	func calcOpacity(index: Int) -> Double {
		if state == .finished || index == 0 {
			return 1.0
		}
		let dif = Double(index)
		return max(0.3, ((0.8 - dif * 0.075)))
	}

}
