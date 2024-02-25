//
//  MenubarPresenter.swift
//  Timer
//
//  Created by Anton Cherkasov on 23.02.2024.
//

import Foundation

protocol MenubarPresenterProtocol {
	func menuWillOpen()
	func menuItemHasBeenClicked(_ id: MenuIdentifier)
}

final class MenubarPresenter {

	var timer: TimerServiceProtocol

	var menubar: MenubarViewProtocol?

	var applicationFacade: ApplicationFacadeProtocol

	var itemsFactory: ItemsFactoryProtocol

	lazy var formatter: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .positional
		formatter.zeroFormattingBehavior = .pad
		formatter.allowedUnits = [.second, .minute, .hour]

		return formatter
	}()

	// MARK: - Initialization

	init(
		timer: TimerServiceProtocol,
		applicationFacade: ApplicationFacadeProtocol,
		itemsFactory: ItemsFactoryProtocol
	) {
		self.timer = timer
		self.applicationFacade = applicationFacade
		self.itemsFactory = itemsFactory

		self.timer.delegate = self
	}
}

// MARK: - TimerServiceDelegate
extension MenubarPresenter: TimerServiceDelegate {

	func timerDidChange(state: TimerState) {
		var title: String?
		switch state {
		case .active(let start, let remainingTime):
			let end = start.addingTimeInterval(remainingTime)
			title = formatter.string(from: start, to: end)
			menubar?.configure(.stop, withItem: itemsFactory.makeStopItem(isEnabled: true))
			menubar?.configure(.pauseResume, withItem: itemsFactory.makePause(isEnabled: true))
		case .paused(let start, let remainingTime):
			let end = start.addingTimeInterval(remainingTime)
			title = formatter.string(from: start, to: end)
			menubar?.configure(.stop, withItem: itemsFactory.makeStopItem(isEnabled: true))
			menubar?.configure(.pauseResume, withItem: itemsFactory.makeResume(isEnabled: true))
		case .inactive:
			menubar?.configure(.stop, withItem: itemsFactory.makeStopItem(isEnabled: false))
			menubar?.configure(.pauseResume, withItem: itemsFactory.makePause(isEnabled: false))
		}
		menubar?.configureButton(title: title ?? "", iconName: "bolt.fill")
	}
	
	func timerHasBeenFinished(start: Date, end: Date, reason: Reason) {
		guard case .timeHasExpired = reason else {
			return
		}
		applicationFacade.playSound()
	}
}

// MARK: - MenubarPresenterProtocol
extension MenubarPresenter: MenubarPresenterProtocol {

	func menuWillOpen() {
		timerDidChange(state: timer.state)
	}

	func menuItemHasBeenClicked(_ id: MenuIdentifier) {
		switch id {
		case .stop:
			timer.stop()
		case .pauseResume:
			timer.pauseResume()
		case .period(let value):
			timer.start(with: value)
		case .quit:
			applicationFacade.quit()
		}
	}
}
