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
}

final class ItemsFactory { }

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
}
