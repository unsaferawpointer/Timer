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
	func timerDidChange(state: TimerState)
	func presentStatistics(_ interval: TimeInterval)
}

final class MenubarPresenter {

	var interactor: MenubarInteractorProtocol?

	var menubar: MenubarViewProtocol?

	var itemsFactory: ItemsFactoryProtocol

	weak var output: MenubarOutput?

	lazy var formatter: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .positional
		formatter.zeroFormattingBehavior = .pad
		formatter.allowedUnits = [.second, .minute, .hour]

		return formatter
	}()

	// MARK: - Initialization

	init(
		itemsFactory: ItemsFactoryProtocol,
		output: MenubarOutput
	) {
		self.itemsFactory = itemsFactory
		self.output = output
	}
}

// MARK: - MenubarPresenterProtocol
extension MenubarPresenter: MenubarPresenterProtocol {

	func presentStatistics(_ interval: TimeInterval) {
		menubar?.configure(.today, withItem: itemsFactory.makeTotalToday(interval: interval))
	}

	func menuWillOpen() {
		interactor?.fetchData()
	}

	func menuItemHasBeenClicked(_ id: MenuIdentifier) {
		switch id {
		case .stop:
			interactor?.stop()
		case .pauseResume:
			interactor?.pauseResume()
		case .period(let value):
			interactor?.start(with: value)
		case .quit:
			interactor?.quit()
		case .today:
			assertionFailure("Not supported")
		case .settings:
			output?.showSettings()
		}
	}

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
}
