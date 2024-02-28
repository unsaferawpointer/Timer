//
//  ActivitiesAssembly.swift
//  Timer
//
//  Created by Anton Cherkasov on 28.02.2024.
//

import AppKit

final class ActivitiesAssembly {

	static func assemble() -> NSViewController {
		let presenter = ActivitiesPresenter()
		let view = ActivitiesViewController()

		view.output = presenter
		presenter.view = view

		return view
	}
}
