//
//  MenuIdentifier.swift
//  Timer
//
//  Created by Anton Cherkasov on 20.02.2024.
//

import Foundation

enum MenuIdentifier {
	case pauseResume
	case stop
	case period(_ value: TimerPeriod)
	case today
	case quit
}

// MARK: - Equatable
extension MenuIdentifier: Equatable { }
