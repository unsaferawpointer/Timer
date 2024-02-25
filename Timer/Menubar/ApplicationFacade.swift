//
//  ApplicationFacade.swift
//  Timer
//
//  Created by Anton Cherkasov on 24.02.2024.
//

import AppKit

protocol ApplicationFacadeProtocol {
	func quit()
	func playSound()
}

final class ApplicationFacade {

}

// MARK: - ApplicationFacadeProtocol
extension ApplicationFacade: ApplicationFacadeProtocol {

	func quit() {
		NSApplication.shared.terminate(nil)
	}

	func playSound() {
		NSSound(named: "Glass")?.play()
	}
}
