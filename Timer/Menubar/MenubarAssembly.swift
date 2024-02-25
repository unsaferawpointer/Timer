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

		let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

		let interactor = MenubarInteractor(
			timer: TimerService(),
			sessionsProvider: SessionsProvider(context: context!),
			applicationFacade: ApplicationFacade(),
			dateManager: DateManager()
		)
		let presenter = MenubarPresenter(itemsFactory: ItemsFactory())
		presenter.interactor = interactor
		interactor.presenter = presenter
		let menubar = MenubarView(statusItem)
		presenter.menubar = menubar
		menubar.output = presenter

		return menubar
	}
}
