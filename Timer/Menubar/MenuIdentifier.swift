//
//  MenuIdentifier.swift
//  Timer
//
//  Created by Anton Cherkasov on 20.02.2024.
//

enum MenuIdentifier {
	case pauseResume
	case stop
	case period(_ value: TimerPeriod)
	case quit
}

// MARK: - Equatable
extension MenuIdentifier: Equatable { }
