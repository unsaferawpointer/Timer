//
//  Session.swift
//  Timer
//
//  Created by Anton Cherkasov on 25.02.2024.
//

import Foundation

struct Session {
	
	var start: Date

	var duration: TimeInterval
}

extension Session {

	var end: Date {
		return start.addingTimeInterval(duration)
	}
}
