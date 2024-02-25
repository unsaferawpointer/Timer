//
//  TimerPeriod.swift
//  Timer
//
//  Created by Anton Cherkasov on 20.02.2024.
//

import Foundation

enum TimerPeriod: Int {
	case fiveMinutes
	case tenMinutes
	case fifteenMinutes
	case twentyMinutes
	case twentyFiveMinutes
	case thirtyMinutes
	case oneHour
}

// MARK: - CaseIterable
extension TimerPeriod: CaseIterable { }

extension TimerPeriod {

	var interval: TimeInterval {
		switch self {
		case .fiveMinutes:
			return 5 * 60
		case .tenMinutes:
			return 10 * 60
		case .fifteenMinutes:
			return 15 * 60
		case .twentyMinutes:
			return 20 * 60
		case .twentyFiveMinutes:
			return 25 * 60
		case .thirtyMinutes:
			return 30 * 60
		case .oneHour:
			return 60 * 60
		}
	}
}

extension TimerPeriod {

	var title: String {
		switch self {
		case .fiveMinutes: 			"5 minutes"
		case .tenMinutes: 			"10 minutes"
		case .fifteenMinutes: 		"15 minutes"
		case .twentyMinutes: 		"20 minutes"
		case .twentyFiveMinutes:	"25 minutes"
		case .thirtyMinutes: 		"30 minutes"
		case .oneHour:				"1 hour"
		}
	}
}
