//
//  ActivitiesPresenter.swift
//  Timer
//
//  Created by Anton Cherkasov on 28.02.2024.
//

import Foundation

final class ActivitiesPresenter {
	
	weak var view: ActivitiesView?
}

// MARK: - ActivitiesViewOutput
extension ActivitiesPresenter: ActivitiesViewOutput {

	func viewDidLoad() {
		view?.display(models:
						[
							.init(uuid: .init(), title: "Programming"),
							.init(uuid: .init(), title: "Plan App"),
							.init(uuid: .init(), title: "Timer App")
						]
		)
	}

	func plusButtonHasBeenClicked() {
		// TODO: - Handle action
	}
	
	func minusButtonHasBeenClicked() {
		// TODO: - Handle action
	}

	func textfieldDidChange(text: String, id: UUID) {
		// TODO: - Handle action
	}
}
