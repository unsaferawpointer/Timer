//
//  TimerState.swift
//  Timer
//
//  Created by Anton Cherkasov on 23.02.2024.
//

import Foundation

enum TimerState {
	case active(start: Date, remainingTime: TimeInterval)
	case paused(start: Date, remainingTime: TimeInterval)
	case inactive
}
