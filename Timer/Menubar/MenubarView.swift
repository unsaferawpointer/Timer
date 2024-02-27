//
//  MenubarView.swift
//  Timer
//
//  Created by Anton Cherkasov on 23.02.2024.
//

import AppKit

protocol MenubarViewProtocol {
	func configure(_ id: MenuIdentifier, withItem item: ItemContent)
	func configureButton(title: String, iconName: String?)
}

struct ItemContent {

	var title: String
	var iconName: String?

	var isEnabled: Bool
}

final class MenubarView: NSObject {

	var output: MenubarPresenterProtocol?

	var item: NSStatusItem

	var menu: NSMenu? {
		return item.menu
	}

	var title: String? {
		get {
			item.button?.title
		}
		set {
			item.button?.title = newValue ?? ""
		}
	}

	var image: NSImage? {
		get {
			item.button?.image
		}
		set {
			item.button?.image = newValue
		}
	}

	// MARK: - Initialization

	init(_ item: NSStatusItem) {
		self.item = item
		super.init()
		self.item.menu = makeMenu()
		self.menu?.delegate = self
	}
}

// MARK: - MenubarViewProtocol
extension MenubarView: MenubarViewProtocol {

	func configure(_ id: MenuIdentifier, withItem item: ItemContent) {
		guard let firstItem = menu?.items.first(where: { ($0.representedObject as? MenuIdentifier) == id}) else {
			return
		}
		firstItem.title = item.title
		if let iconName = item.iconName {
			firstItem.image = NSImage(
				systemSymbolName: iconName,
				accessibilityDescription: nil
			)
		}
		firstItem.action = item.isEnabled ? #selector(menuItemHasBeenClicked(_:)) : nil
	}

	func configureButton(title: String, iconName: String?) {
		self.title = title
		if let iconName {
			self.image = NSImage(
				systemSymbolName: iconName,
				accessibilityDescription: nil
			)
		}
	}
}

// MARK: - NSMenuDelegate
extension MenubarView: NSMenuDelegate {

	func menuWillOpen(_ menu: NSMenu) {
		output?.menuWillOpen()
	}
}

// MARK: - Helpers
private extension MenubarView {

	func makeMenu() -> NSMenu {
		let menu = NSMenu()

		let todayStatistics = NSMenuItem.sectionHeader(title: "Total Today")
		menu.addItem(todayStatistics)

		let today = NSMenuItem()
		today.representedObject = MenuIdentifier.today
		menu.addItem(today)

		menu.addItem(.separator())

		let quickTimers = NSMenuItem.sectionHeader(title: "Quick timers")
		menu.addItem(quickTimers)

		for period in TimerPeriod.allCases {
			let item = NSMenuItem()
			item.title = period.title
			item.target = self
			item.action = #selector(menuItemHasBeenClicked(_:))
			item.representedObject = MenuIdentifier.period(period)
			item.indentationLevel = 0
			item.keyEquivalent = "\(period.rawValue)"
			menu.addItem(item)
		}

		menu.addItem(.separator())

		let controls = NSMenuItem.sectionHeader(title: "Controls")
		menu.addItem(controls)

		let stop = NSMenuItem()
		stop.title = "Start"
		stop.target = self
		stop.action = #selector(menuItemHasBeenClicked(_:))
		stop.representedObject = MenuIdentifier.stop
		stop.keyEquivalent = "s"
		stop.image = NSImage(systemSymbolName: "stop.fill", accessibilityDescription: nil)
		stop.indentationLevel = 0
		menu.addItem(stop)

		let pauseResume = NSMenuItem()
		pauseResume.title = "Pause"
		pauseResume.target = self
		pauseResume.action = #selector(menuItemHasBeenClicked(_:))
		pauseResume.representedObject = MenuIdentifier.pauseResume
		pauseResume.keyEquivalent = "p"
		pauseResume.image = NSImage(systemSymbolName: "pause.fill", accessibilityDescription: nil)
		pauseResume.indentationLevel = 0
		menu.addItem(pauseResume)

		menu.addItem(.separator())

		let settings = NSMenuItem()
		settings.title = "Settings..."
		settings.target = self
		settings.action = #selector(menuItemHasBeenClicked(_:))
		settings.representedObject = MenuIdentifier.settings
		settings.keyEquivalent = ","
		settings.indentationLevel = 0
		menu.addItem(settings)

		menu.addItem(.separator())

		let quit = NSMenuItem()
		quit.title = "Quit"
		quit.target = self
		quit.action = #selector(menuItemHasBeenClicked(_:))
		quit.representedObject = MenuIdentifier.quit
		quit.keyEquivalent = "q"
		menu.addItem(quit)

		return menu
	}
}

// MARK: - Actions
extension MenubarView {

	@objc
	func menuItemHasBeenClicked(_ sender: NSMenuItem) {
		guard let id = sender.representedObject as? MenuIdentifier else {
			return
		}
		output?.menuItemHasBeenClicked(id)
	}
}
