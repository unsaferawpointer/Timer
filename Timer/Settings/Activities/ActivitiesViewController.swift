//
//  ActivitiesViewController.swift
//  Timer
//
//  Created by Anton Cherkasov on 27.02.2024.
//

import Cocoa

protocol ActivitiesView: AnyObject {
	func display(models: [ActivityModel])
}

protocol ActivitiesViewOutput {

	func viewDidLoad()

	func plusButtonHasBeenClicked()
	func minusButtonHasBeenClicked()

	func textfieldDidChange(text: String, id: UUID)
}

class ActivitiesViewController: NSViewController {

	var output: ActivitiesViewOutput?

	// MARK: - Data

	private var models: [ActivityModel] = []

	// MARK: - UI-Properties

	lazy var scrollview: NSScrollView = {
		let view = NSScrollView()
		view.borderType = .bezelBorder
		view.hasHorizontalScroller = false
		view.autohidesScrollers = true
		view.hasVerticalScroller = true
		view.automaticallyAdjustsContentInsets = true
		view.drawsBackground = true
		return view
	}()

	lazy var table: NSTableView = {
		let view = NSTableView()
		view.style = .inset
		view.rowSizeStyle = .default
		view.floatsGroupRows = false
		view.allowsMultipleSelection = true
		view.allowsColumnResizing = false
		view.usesAlternatingRowBackgroundColors = true
		view.usesAutomaticRowHeights = false
		return view
	}()

	lazy var stack: NSStackView = {
		let view = NSStackView(views: [plusButton, minusButton])
		view.orientation = .horizontal
		return view
	}()

	lazy var plusButton: NSButton = {
		let view = NSButton()
		view.setButtonType(.momentaryPushIn)
		view.imagePosition = .imageOnly
		view.bezelStyle = .automatic
		view.isBordered = true
		view.showsBorderOnlyWhileMouseInside = true
		view.image = NSImage(systemSymbolName: "plus", accessibilityDescription: nil)
		view.target = self
		view.action = #selector(plusButtonHasBeenClicked(_:))
		return view
	}()

	lazy var minusButton: NSButton = {
		let view = NSButton()
		view.setButtonType(.momentaryPushIn)
		view.imagePosition = .imageOnly
		view.bezelStyle = .automatic
		view.isBordered = true
		view.showsBorderOnlyWhileMouseInside = true
		view.image = NSImage(systemSymbolName: "minus", accessibilityDescription: nil)
		view.target = self
		view.action = #selector(minusButtonHasBeenClicked(_:))
		return view
	}()

	override func loadView() {
		self.view = NSView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureUserInterface()
		configureConstraints()
		output?.viewDidLoad()
	}

}

// MARK: - ActivitiesView
extension ActivitiesViewController: ActivitiesView {

	func display(models: [ActivityModel]) {
		self.models = models
		table.reloadData()
	}
}

// MARK: - Helpers
private extension ActivitiesViewController {

	func configureUserInterface() {

		table.headerView = nil
		table.dataSource = self
		table.delegate = self
		scrollview.documentView = table

		table.frame = scrollview.bounds

		let column1 = NSTableColumn(identifier: .init(rawValue: "main"))
		table.addTableColumn(column1)
	}

	func configureConstraints() {
		scrollview.pin(to: view, inset: 24)

		stack.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stack)

		NSLayoutConstraint.activate(
			[
				stack.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
				stack.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
				stack.topAnchor.constraint(equalTo: scrollview.bottomAnchor)
			]
		)
	}
}

// MARK: - NSTableViewDataSource
extension ActivitiesViewController: NSTableViewDataSource {

	func numberOfRows(in tableView: NSTableView) -> Int {
		return models.count
	}
}

// MARK: - NSTableViewDelegate
extension ActivitiesViewController: NSTableViewDelegate {

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

		let model = models[row]

		let id = NSUserInterfaceItemIdentifier("cell")
		var view = table.makeView(withIdentifier: id, owner: self) as? NSTextField
		if view == nil {
			view = NSTextField(string: model.title)
			view?.drawsBackground = false
			view?.isBordered = false
			view?.cell?.sendsActionOnEndEditing = true
			view?.target = self
			view?.action = #selector(textfieldDidChangeText(_:))
			view?.cell?.representedObject = model.uuid
			view?.identifier = id
		}
		return view
	}
}

extension NSView {

	func pin(to view: NSView, inset: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(self)

		NSLayoutConstraint.activate(
			[
				leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
				trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
				topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
				bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
			]
		)
	}
}

// MARK: - Actions
extension ActivitiesViewController {

	@objc
	func plusButtonHasBeenClicked(_ sender: NSButton) {
		output?.plusButtonHasBeenClicked()
	}

	@objc
	func minusButtonHasBeenClicked(_ sender: NSButton) {
		output?.minusButtonHasBeenClicked()
	}

	@objc
	func textfieldDidChangeText(_ sender: NSTextField) {
		guard let id = sender.cell?.representedObject as? UUID else {
			return
		}
		let newValue = sender.stringValue
		output?.textfieldDidChange(text: newValue, id: id)
	}
}
