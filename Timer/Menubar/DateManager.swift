//
//  DateFacade.swift
//  Timer
//
//  Created by Anton Cherkasov on 25.02.2024.
//

import Foundation

enum TimePeriod {
	case today
}

protocol DateManagerProtocol {
	func intersection(start: Date, end: Date, period: TimePeriod) -> TimeInterval
}

final class DateManager {

	let calendar = Calendar.autoupdatingCurrent

}

// MARK: - DateManagerProtocol
extension DateManager: DateManagerProtocol {

	func intersection(start: Date, end: Date, period: TimePeriod) -> TimeInterval {

		guard 
			let interval = calendar.dateInterval(of: .day, for: .now)
		else {
			return 0.0
		}

		let periodStart = interval.start
		let periodEnd = interval.end

		switch (start < periodStart, end > periodEnd) {
		case (false, false):	return end.distance(to: start)
		case (true, true):		return interval.duration
		case (false, true):		return periodEnd.distance(to: start)
		case (true, false):		return end.distance(to: periodStart)
		}
	}
}
