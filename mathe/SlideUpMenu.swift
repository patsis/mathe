//
//  SlideUpMenu.swift
//  mathe
//
//  Created by Harry Patsis on 7/5/20.
//  Copyright © 2020 patsis. All rights reserved.
//

import SwiftUI

struct PopUp: Shape {
	@State var button: CGFloat = 50
	@State var cornerRadius: CGFloat = 10
	@State var buttonCornerRadius: CGFloat = 50
	func path(in rect: CGRect) -> Path {
		Path { path in

			let width = rect.width
			let height = rect.height
			let cntr = width * 0.5
			let arc1 = (start: Angle.radians(-.pi*0.5), end: Angle.radians(.pi*0.0))
			let arc2 = (start: Angle.radians(.pi*0.0),  end: Angle.radians(.pi*0.5))
			let arc3 = (start: Angle.radians(.pi*0.5),  end: Angle.radians(.pi*1.0))
			let arc4 = (start: Angle.radians(.pi*1.0),  end: Angle.radians(-.pi*0.5))

			let arc5 = (start: Angle.radians(.pi*1.0),  end: Angle.radians(.pi*0.5))
			let arc6 = (start: Angle.radians(.pi*0.5),  end: Angle.radians(.pi*0.0))

			path.move(to: CGPoint(x: cntr , y: 0))

			path.addArc(center: CGPoint(x: width * 0.5, y: button * 0.5),
									radius: button * 0.5,
									startAngle: arc1.start,
									endAngle: arc1.end,
									clockwise: false )

			path.addArc(center: CGPoint(x: cntr + button * 0.5 + buttonCornerRadius, y: button * 0.5),
									radius: buttonCornerRadius,
									startAngle: arc5.start,
									endAngle: arc5.end,
									clockwise: true )

			path.addArc(center: CGPoint(x: width - cornerRadius, y: button * 0.5 + cornerRadius + buttonCornerRadius),
									radius: cornerRadius,
									startAngle: arc1.start,
									endAngle: arc1.end,
									clockwise: false )

			path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
									radius: cornerRadius,
									startAngle: arc2.start,
									endAngle: arc2.end,
									clockwise: false )

			path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius),
									radius: cornerRadius,
									startAngle: arc3.start,
									endAngle: arc3.end,
									clockwise: false )

			path.addArc(center: CGPoint(x: cornerRadius, y: button * 0.5 + cornerRadius + buttonCornerRadius),
									radius: cornerRadius,
									startAngle: arc4.start,
									endAngle: arc4.end,
									clockwise: false )

			path.addArc(center: CGPoint(x: cntr - button * 0.5 - buttonCornerRadius, y: button * 0.5),
									radius: buttonCornerRadius,
									startAngle: arc6.start,
									endAngle: arc6.end,
									clockwise: true )

			path.addArc(center: CGPoint(x: width * 0.5, y: button * 0.5),
									radius: button * 0.5,
									startAngle: arc4.start,
									endAngle: arc4.end,
									clockwise: false )
		}
	}
}

struct SlideButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.foregroundColor(Color("titleForeColor1"))
			.font(.system(size: 20))
			.shadow(radius: 1)
	}
}

struct SlideUpMenu/*<Content: View>*/: View {
	@EnvironmentObject var operationModel: OperationModel
//	@State var isUp: Bool = false
	var buttonSize: CGFloat
	var height: CGFloat

	var body: some View {
		GeometryReader {geometry in
			ZStack {
				if [.playing, .settings].contains(self.operationModel.state) {
					PopUp(button: 50, cornerRadius: 12, buttonCornerRadius: 6)
						.fill(Color("backColor1Light"))
						//			.fill(LinearGradient(gradient: Gradient(colors: GradientColors[3]), startPoint: .topLeading, endPoint: .bottomTrailing))
						.opacity(self.operationModel.state == .settings ? 1.0 : 0)
						.zIndex(0)
						.frame(maxWidth: .infinity, minHeight: self.height, maxHeight: self.height)
						.shadow(radius: 5)

					Button(action: {
						withAnimation(.easeInOut(duration: 0.5)) {
							self.operationModel.toggleSettings()
//							if self.operationModel.state == .settings {
//								self.operationModel.state = .playing
//							} else {
////								self.isUp = false
//								self.operationModel.state = .settings
//							}
						}}) {
							Image(systemName: "chevron.right.2")
								.rotationEffect(.degrees(self.operationModel.state == .settings ? 90 : -90))
					}
					.buttonStyle(SlideButtonStyle())
					.frame(width: self.buttonSize, height: self.buttonSize)
					.offset(x: 0, y: (self.buttonSize - self.height) / 2)

					OperandsView() /// state == .settings
				}
			}
			.offset(x: 0, y: self.operationModel.state == .settings ? -self.height + 50 : 0)
			.padding()
			.position(x: geometry.size.width / 2, y: geometry.size.height + self.height / 2 - self.buttonSize + 2)
		}
	}
}

//struct SlideUpMenu_Previews: PreviewProvider {
//	static let operationModel = OperationModel()
//	static var previews: some View {
//		SlideUpMenu(buttonSize: 50, height: 300)
//	}
//}
