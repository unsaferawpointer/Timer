//
//  MenubarInteractor.swift
//  Timer
//
//  Created by Anton Cherkasov on 25.02.2024.
//

import Foundation

protocol MenubarInteractorProtocol {
	func start(with period: TimerPeriod)
	func fetchData()
	func pauseResume()
	func stop()
	func quit()
}

final class MenubarInteractor {

	var presenter: MenubarPresenterProtocol?

	var sessionsProvider: SessionsProviderProtocol

	var timer: TimerServiceProtocol

	var applicationFacade: ApplicationFacadeProtocol

	var dateManager: DateManagerProtocol

	init(
		timer: TimerServiceProtocol,
		sessionsProvider: SessionsProviderProtocol,
		applicationFacade: ApplicationFacadeProtocol,
		dateManager: DateManagerProtocol
	) {
		self.timer = timer
		self.sessionsProvider = sessionsProvider
		self.applicationFacade = applicationFacade
		self.dateManager = dateManager

		self.timer.delegate = self
	}
}

// MARK: - MenubarInteractorProtocol
extension MenubarInteractor: MenubarInteractorProtocol {

	func start(with period: TimerPeriod) {
		timer.start(with: period)
	}
	
	func pauseResume() {
		timer.pauseResume()
	}

	func fetchData() {
		timerDidChange(state: timer.state)
		do {
			try sessionsProvider.subscribe(self)
		} catch {

		}
	}

	func stop() {
		timer.stop()
	}

	func quit() {
		applicationFacade.quit()
	}
}

// MARK: - SessionsProviderDelegate
extension MenubarInteractor: SessionsProviderDelegate {

	func providerDidChangeContent(_ sessions: [Session]) {
		let total = sessions.reduce(TimeInterval()) { partialResult, session in
			return partialResult + dateManager.intersection(
				start: session.start,
				end: session.end,
				period: .today
			)
		}
		presenter?.presentStatistics(total)
	}
}

// MARK: - TimerServiceDelegate
extension MenubarInteractor: TimerServiceDelegate {

	func timerDidChange(state: TimerState) {
		presenter?.timerDidChange(state: state)
	}

	func timerHasBeenFinished(start: Date, end: Date, reason: Reason) {
		let session = Session(start: start, duration: end.timeIntervalSince(start))
		do {
			try sessionsProvider.insertSession(session)
			try sessionsProvider.save()
		} catch {

		}
		guard case .timeHasExpired = reason else {
			return
		}
		applicationFacade.playSound()
	}
}
