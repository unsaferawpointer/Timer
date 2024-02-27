//
//  SettingsAssembly.swift
//  Timer
//
//  Created by Anton Cherkasov on 26.02.2024.
//

import AppKit

final class SettingsAssembly {
	
	static func assemble() -> NSViewController {

		let viewController = NSTabViewController(nibName: nil, bundle: nil)

		viewController.tabStyle = .toolbar

		viewController.title = "Settings"

		let item = NSTabViewItem(viewController: NSViewController())
		item.label = "Activities"
		item.image = NSImage(systemSymbolName: "list.bullet.rectangle", accessibilityDescription: nil)

		let general = NSTabViewItem(viewController: NSViewController())
		general.label = "General"
		general.image = NSImage(systemSymbolName: "slider.horizontal.3", accessibilityDescription: nil)

		viewController.addTabViewItem(general)
		viewController.addTabViewItem(item)

		return viewController
	}
}
