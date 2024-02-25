//
//  ItemsFactory.swift
//  Timer
//
//  Created by Anton Cherkasov on 25.02.2024.
//

import Foundation

protocol ItemsFactoryProtocol {
	func makeStopItem(isEnabled: Bool) -> ItemContent
	func makePause(isEnabled: Bool) -> ItemContent
	func makeResume(isEnabled: Bool) -> ItemContent
	func makeTotalToday(interval: TimeInterval) -> ItemContent
}

final class ItemsFactory { 

	lazy var formatter: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .positional
		formatter.zeroFormattingBehavior = .pad
		formatter.allowedUnits = [.second, .minute, .hour]

		return formatter
	}()

}

// MARK: - ItemsFactoryProtocol
extension ItemsFactory: ItemsFactoryProtocol {

	func makeStopItem(isEnabled: Bool) -> ItemContent {
		let content = ItemContent(
			title: "Stop",
			iconName: "stop",
			isEnabled: isEnabled
		)
		return content
	}

	func makePause(isEnabled: Bool) -> ItemContent {
		let content = ItemContent(
			title: "Pause",
			iconName: "pause",
			isEnabled: isEnabled
		)
		return content
	}

	func makeResume(isEnabled: Bool) -> ItemContent {
		let content = ItemContent(
			title: "Resume",
			iconName: "forward.end",
			isEnabled: isEnabled
		)
		return content
	}

	func makeTotalToday(interval: TimeInterval) -> ItemContent {
		let formattedTime = formatter.string(from: interval) ?? ""
		let content = ItemContent(
			title: formattedTime,
			iconName: nil,
			isEnabled: false
		)
		return content
	}
}
