//
//  MenuAssembly.swift
//  Timer
//
//  Created by Anton Cherkasov on 23.02.2024.
//

import AppKit

final class MenubarAssembly {

	static func assemble() -> MenubarView {

		let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

		if let button = statusItem.button {
			button.image = NSImage(systemSymbolName: "bolt.fill", accessibilityDescription: "Timer")
			button.font = NSFont.monospacedDigitSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
		}

		let presenter = MenubarPresenter(
			timer: TimerService(),
			applicationFacade: ApplicationFacade(),
			itemsFactory: ItemsFactory()
		)
		let menubar = MenubarView(statusItem)
		presenter.menubar = menubar
		menubar.output = presenter

		return menubar
	}
}
