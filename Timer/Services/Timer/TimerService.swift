//
//  TimerService.swift
//  Timer
//
//  Created by Anton Cherkasov on 23.02.2024.
//

import AppKit

enum Reason {
	case stop
	case pause
	case timeHasExpired
}

protocol TimerServiceDelegate: AnyObject {
	func timerDidChange(state: TimerState)
	func timerHasBeenFinished(start: Date, end: Date, reason: Reason)
}

protocol TimerServiceProtocol {
	func start(with period: TimerPeriod)
	func pauseResume()
	func stop()

	var delegate: TimerServiceDelegate? { get set }
	var state: TimerState { get }
}

final class TimerService {

	internal var state: TimerState = .inactive {
		didSet {
			self.delegate?.timerDidChange(state: state)
		}
	}

	private var timer: Timer?

	weak var delegate: TimerServiceDelegate?
}

// MARK: - TimerServiceProtocol
extension TimerService: TimerServiceProtocol {

	func start(with period: TimerPeriod) {
		self.state = .active(start: Date(), remainingTime: period.interval)
		self.timer?.invalidate()
		self.timer = nil
		self.timer = makeTimer()
	}

	func pauseResume() {
		switch state {
		case let .active(start, remainingTime):
			self.state = .paused(start: start, remainingTime: remainingTime)
			self.timer?.invalidate()
			self.timer = nil

			self.delegate?.timerHasBeenFinished(start: start, end: .now, reason: .pause)
		case let .paused(_ , remainingTime):
			self.state = .active(start: .now, remainingTime: remainingTime)
			self.timer = makeTimer()
		default:
			fatalError()
		}
	}

	func stop() {
		switch state {
		case let .paused(start, _), let .active(start, _):
			self.timer?.invalidate()
			self.timer = nil

			self.state = .inactive
			self.delegate?.timerHasBeenFinished(start: start, end: .now, reason: .stop)
		default:
			break
		}
	}
}

// MARK: - Helpers
private extension TimerService {

	func makeTimer() -> Timer {
		let result = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
			guard case let .active(start, remainingTime) = self?.state else {
				return
			}
			self?.state = .active(start: start, remainingTime: remainingTime - 1.0)
			if remainingTime <= 0 {
				self?.timer?.invalidate()
				self?.timer = nil

				self?.state = .inactive
				self?.delegate?.timerHasBeenFinished(
					start: start,
					end: .now,
					reason: .timeHasExpired
				)
			}
		}
		RunLoop.main.add(result, forMode: .common)
		return result
	}
}
