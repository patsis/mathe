//
//  ContentView.swift
//  mathe
//
//  Created by Harry Patsis on 28/04/2020.
//  Copyright © 2020 patsis. All rights reserved.
//

import SwiftUI

var GradientColors: [[Color]] = [
	[Color("enabledColor1Light"), Color("enabledColor1Dark")],
	[Color("disabledColor1Light"), Color("disabledColor1Dark")],
	[Color("titleBackColor1Dark"), Color("titleBackColor1Light")],
	[Color("backColor1Dark"), Color("backColor1Light")]
]

func colorsForSelectionButton(isOn: Bool, isPressed: Bool) -> [Color] {
	var colors = GradientColors[isOn ? 0 : 1]
	if isPressed {
		colors.reverse()
	}
	return colors
}

struct OperandButtonStyle: ButtonStyle {
	var isOn: Bool
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.foregroundColor(Color("titleForeColor1"))
			.font(.system(size: 30, weight: .bold))
			.frame(width: 50, height: 50)
			.background( Rectangle()
				.fill(LinearGradient(gradient: Gradient(colors: GradientColors[0]), startPoint: .topLeading, endPoint: .bottom))
				.opacity(isOn ? 1 : 0)
				.animation(.easeIn(duration: 0.2)))
			.cornerRadius(5.0)
			.shadow(radius: 0.5)
	}
}

struct DigitButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.foregroundColor(Color("titleForeColor1"))
			.font(.system(size: 38, weight: .bold))
			.frame(width: 50, height: 50)
			.shadow(radius: 1)
	}
}

struct DelRetButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.foregroundColor(Color("titleForeColor1"))
			.font(.system(size: 35))
			.frame(width: 50, height: 50)
			.shadow(radius: 1)
	}
}

struct MainBackground: View {
	var body: some View {
		Rectangle() /// background
			.fill(LinearGradient(gradient: Gradient(colors: GradientColors[3]), startPoint: .topLeading, endPoint: .bottomTrailing))
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.statusBar(hidden: true)
			.edgesIgnoringSafeArea(.all)
	}
}

struct TitleView: View {
	@EnvironmentObject var operationModel: OperationModel
	var body: some View {
		ZStack { /// Title ZStack
			Rectangle()
				.fill(LinearGradient(gradient: Gradient(colors: GradientColors[2]), startPoint: .top, endPoint: .bottom))
				.frame(maxWidth: .infinity, maxHeight: 60)
				.cornerRadius(8, antialiased: true)
				.padding(8)
				.shadow(radius: 3)
			HStack {
				Text("math")
					.font(.system(size: 24))
					.bold()
					.foregroundColor(Color("titleForeColor1"))
					.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40, alignment: .leading)
				if [.playing, .settings, .finished].contains(self.operationModel.state) {
					HStack {
						Text("\(self.operationModel.correctOperations)")
							.bold()
							.font(.system(size: 30))
							.foregroundColor(Color("titleForeColor1"))
							.animation(nil)
						Image(systemName: "star.fill")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 30, alignment: .leading)
							.foregroundColor(Color("correctColor1"))
							.shadow(color: Color("correctColor1"), radius: 1, x: 0, y: 0)
									.animation(nil)
					}
					.frame(minWidth: 0, maxWidth: .infinity)
					ProgressBar(progress: self.operationModel.progress)
				} else {
					Spacer()
				}
			}
			.padding([.leading, .trailing], 22)
		} /// End of title ZStack
	}
}

struct OpLine: View {
	var id: Int
	var operation: Operation
	var isActive: Bool

	var body: some View {
		HStack(alignment: .center, spacing: 0) {
			Spacer()
			Text(operation.term[0])
				.font(.system(size: 40))
				.bold()
				.foregroundColor(Color("titleForeColor1"))
				.frame(width: 80, height: 50)

			Text(operation.operand)
				.font(.system(size: 40))
				.bold()
				.foregroundColor(Color("titleForeColor1"))
				.frame(width: 40, height: 50)

			Text(operation.term[1])
				.font(.system(size: 40))
				.bold()
				.foregroundColor(Color("titleForeColor1"))
				.frame(width: 80, height: 50)

			Text("=")
				.font(.system(size: 40))
				.bold()
				.foregroundColor(Color("titleForeColor1"))
				.frame(width: 40, height: 50)

			if operation.finished {
				if operation.correct {
					Text(operation.answer)
						.font(.system(size: 40))
						.bold()
						.foregroundColor(Color("correctColor1"))
						.frame(width: 100, height: 50)
				} else if operation.answer.isEmpty {
					Text(operation.term[2])
						.font(.system(size: 40))
						.bold()
						.foregroundColor(Color("wrongColor1"))
						.frame(width: 100, height: 50)
				} else {
					HStack {
						Text(operation.answer)
							.font(.system(size: 40))
							.strikethrough(true, color: .red)
							.bold()
							.foregroundColor(Color("wrongColor1"))
						Text(operation.term[2])
							.font(.system(size: 40))
							.bold()
							.foregroundColor(Color("correctColor1"))
					}
					.frame(width: 100, height: 50)
					.minimumScaleFactor(0.01)
				}
			} else {
				Text(operation.answer)
					.font(.system(size: 40))
					.bold()
					.foregroundColor(Color("titleForeColor1"))
					.frame(width: 100, height: 50)
					.background(Color(hue: 1, saturation: 0, brightness: 1, opacity: isActive ? 0.2 : 0))
					.cornerRadius(25)
			}
			Spacer()
		}
	}
}

struct LinearProgressBar: View {
	var progress: CGFloat
	func getColors() -> [Color] {
		let lightColor = Color.init(hue: Double(progress) * 0.3, saturation: 1, brightness: 0.8, opacity: 1)
		let darkColor = Color.init(hue: Double(progress) * 0.3, saturation: 1, brightness: 0.7, opacity: 1)
		return [lightColor, darkColor]
	}
	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Rectangle()
					.frame(width: geometry.size.width , height: geometry.size.height)
					.foregroundColor(Color("backColor1Dark"))

				Rectangle()
					.fill(LinearGradient(gradient: Gradient(colors: self.getColors()), startPoint: .top, endPoint: .bottom))
					.frame(width: min(self.progress * geometry.size.width, geometry.size.width), height: geometry.size.height)
			}
		}
	}
}

struct ProgressBar: View {
	var progress: CGFloat
	var body: some View {
		ZStack(alignment: .trailing) {
			Circle()
				.stroke(lineWidth:6.0)
				.opacity(0.5)
				.foregroundColor(Color("backColor1Dark"))
				.frame(width: 40, height: 40)
			Circle()
				.trim(from: 0, to: progress)
				.stroke(style: StrokeStyle(lineWidth: 6.0, lineCap: .butt))
				.foregroundColor(Color("correctColor1"))
				.rotationEffect(.degrees(270))
				.frame(width: 40, height: 40)
		}
		.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
	}
}

struct KeyboardView: View {
	@EnvironmentObject var operationModel: OperationModel
	var body: some View {
		VStack(alignment: .center, spacing: 0) { /// Keyboard
			if [.playing].contains(self.operationModel.state) {
			HStack { /// 0...4
				ForEach(0..<5) { i in
					Button(String(i), action: {
						playSound(name: "snap1", type: "mp3")
						self.operationModel.addDigit(digit: i)
					})
						.buttonStyle(DigitButtonStyle())
					if i < 4 {
						Spacer()
					}
				}
			}
			HStack { /// 5...9
				ForEach(5..<10) { i in
					Button(String(i), action: {
						playSound(name: "snap1", type: "mp3")
						self.operationModel.addDigit(digit: i)
					})
						.buttonStyle(DigitButtonStyle())
					if i < 9 {
						Spacer()
					}
				}
			}
			HStack { /// Delete - Return buttons
				/// Backspace Button
				Button(action: {
					playSound(name: "snap1", type: "mp3")
					self.operationModel.deleteDigit()
				}) {
					Image(systemName: "xmark.circle.fill")
				}.buttonStyle(DelRetButtonStyle())
					.opacity(self.operationModel.hasDigits ? 1.0 : 0.3)
					.animation(.easeInOut(duration: 0.1))
				Spacer()
				/// Return Button
				Button(action: {
					playSound(name: "snap1", type: "mp3")
					self.operationModel.validateAnswer()
				}) {
					Image(systemName: "chevron.right.circle.fill")
				}.buttonStyle(DelRetButtonStyle())
					.opacity(self.operationModel.hasDigits ? 1.0 : 0.3)
					.animation(.easeInOut(duration: 0.1))
			}
			}
		}
		.frame(minWidth: 300, maxWidth: 500)
		.padding(.horizontal, 30)
		.padding(.top, 20)
	}
}

struct StartButtonView: View {
	@EnvironmentObject var operationModel: OperationModel
	var body: some View {
		VStack {
			if [.start].contains(self.operationModel.state) {
				Button(action: {
					withAnimation(.easeOut(duration: 0.5)) {
						self.operationModel.start()
					}
				}) {
					Text("Start")
						.font(.system(size: 50))
						.fontWeight(.light)
						.kerning(8)
						.foregroundColor(Color("titleForeColor1"))
						.shadow(color: .white, radius: 2, x: 0, y: 0)
				}
			}
		}
	}
}

struct OperandsView: View {
	@EnvironmentObject var operationModel: OperationModel
	var body: some View {
		VStack {
			HStack { /// Game Buttons HStack
				VStack(alignment: .center, spacing: 8) {
					Button("+", action: {
						self.operationModel.toggleOperand(at: 0)
					}).buttonStyle(OperandButtonStyle(isOn: self.operationModel.operands[0]))
					LinearProgressBar(progress: self.operationModel.statFor(operation: "add"))
						.frame(width: 50, height: 8)
						.cornerRadius(5.0)
				}
				VStack(alignment: .center, spacing: 8) {
					Button("−", action: {
						self.operationModel.toggleOperand(at: 1)
					}).buttonStyle(OperandButtonStyle(isOn: self.operationModel.operands[1]))
					LinearProgressBar(progress: self.operationModel.statFor(operation: "sub"))
						.frame(width: 50, height: 8)
						.cornerRadius(5.0)
				}
				VStack(alignment: .center, spacing: 8) {
					Button("×", action: {
						self.operationModel.toggleOperand(at: 2)
					}).buttonStyle(OperandButtonStyle(isOn: self.operationModel.operands[2]))
					LinearProgressBar(progress: self.operationModel.statFor(operation: "mul"))
						.frame(width: 50, height: 8)
						.cornerRadius(5.0)
				}
				VStack(alignment: .center, spacing: 8) {
					Button("÷", action: {
						self.operationModel.toggleOperand(at: 3)
					}).buttonStyle(OperandButtonStyle(isOn: self.operationModel.operands[3]))
					LinearProgressBar(progress: self.operationModel.statFor(operation: "div"))
						.frame(width: 50, height: 8)
						.cornerRadius(5.0)
				}
			}
			.padding(.top, 8)
			.padding(.bottom, 10)
			.opacity(self.operationModel.state == .settings ? 1.0 : 0)

			Button(action: {
				self.operationModel.clearStats()
			}) {
				HStack {
					Image(systemName: "trash.fill")
						.foregroundColor(Color("titleForeColor1"))
						.font(.system(size: 14))

					Text(self.operationModel.clearState ? "Are you sure?" : "Clear statistics")
						.font(.system(size: 16))
						.bold()
						.animation(nil)
						.foregroundColor(self.operationModel.clearState ? Color("wrongColor1") : Color("titleForeColor1"))
						.offset(x: 0, y: 2)

				}
			}
			.opacity(0.75)
			.offset(x: 0, y: 30)
		}
	}
}

struct GameView: View {
	@EnvironmentObject var operationModel: OperationModel
	var body: some View {
		VStack {
			if [.playing, .settings, .finished].contains(self.operationModel.state) {
				ScrollView(.vertical, showsIndicators: false) {
					if (self.operationModel.operations.count > 0) {
						ForEach(0..<self.operationModel.operations.count, id: \.self) { i in
							self.operationModel.oplineFor(id: i)
								.animation(nil)
								.opacity(self.operationModel.calcOpacity(index: i))
								.animation(.easeInOut(duration: 0.1))
						} /// ForEach
					}
				}
				.onAppear {
					self.operationModel.setTotal(total: 20)
					self.operationModel.newOperation()
				}
			} else {
				Spacer()
			}
		}
		.padding(.top, 10)
	}
}

struct MainView: View {
	@EnvironmentObject var operationModel: OperationModel

	var body: some View {
		ZStack { /// outer level container
			MainBackground() /// always showing

			VStack(alignment: .center, spacing: 0) { /// Main VStack
				TitleView() /// always showing
				GameView() /// state == .playing, .finished
				KeyboardView() /// state == .playing
			} /// Main VStack

			SlideUpMenu(buttonSize: 50, height: 250) /// settings menu when .playin, .settings

			StartButtonView() /// state ==.start
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static let operationModel = OperationModel()
	static var previews: some View {
		MainView().environmentObject(operationModel)
	}
}
