//
//  AppDelegate.swift
//  Timer
//
//  Created by Anton Cherkasov on 20.02.2024.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

	var statusItem: NSStatusItem?

	func applicationDidFinishLaunching(_ aNotification: Notification) {

		statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

		statusItem?.menu = makeMenu()

		if let button = statusItem?.button {
			button.image = NSImage(systemSymbolName: "bolt.fill", accessibilityDescription: "Timer")
		}
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentCloudKitContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentCloudKitContainer(name: "Timer")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving and Undo support

	func save() {
	    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
	    let context = persistentContainer.viewContext

	    if !context.commitEditing() {
	        NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
	    }
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Customize this code block to include application-specific recovery steps.
	            let nserror = error as NSError
	            NSApplication.shared.presentError(nserror)
	        }
	    }
	}

	func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
	    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
	    return persistentContainer.viewContext.undoManager
	}

	func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
	    // Save changes in the application's managed object context before the application terminates.
	    let context = persistentContainer.viewContext
	    
	    if !context.commitEditing() {
	        NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
	        return .terminateCancel
	    }
	    
	    if !context.hasChanges {
	        return .terminateNow
	    }
	    
	    do {
	        try context.save()
	    } catch {
	        let nserror = error as NSError

	        // Customize this code block to include application-specific recovery steps.
	        let result = sender.presentError(nserror)
	        if (result) {
	            return .terminateCancel
	        }
	        
	        let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
	        let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
	        let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
	        let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
	        let alert = NSAlert()
	        alert.messageText = question
	        alert.informativeText = info
	        alert.addButton(withTitle: quitButton)
	        alert.addButton(withTitle: cancelButton)
	        
	        let answer = alert.runModal()
	        if answer == .alertSecondButtonReturn {
	            return .terminateCancel
	        }
	    }
	    // If we got here, it is time to quit.
	    return .terminateNow
	}

}

// MARK: - Helpers
private extension AppDelegate {

	func makeMenu() -> NSMenu {
		let menu = NSMenu()

		for period in TimerPeriod.allCases {
			let item = NSMenuItem()
			item.title = period.title
			item.target = self
			item.action = #selector(menuItemHasBeenClicked(_:))
			item.representedObject = MenuIdentifier.period(period)

			menu.addItem(item)
		}

		menu.addItem(.separator())

		let pause = NSMenuItem()
		pause.title = "Pause"
		pause.target = self
		pause.action = #selector(menuItemHasBeenClicked(_:))
		pause.representedObject = MenuIdentifier.pause
		pause.keyEquivalent = "p"
		menu.addItem(pause)

		let resume = NSMenuItem()
		resume.title = "Resume"
		resume.target = self
		resume.action = #selector(menuItemHasBeenClicked(_:))
		resume.representedObject = MenuIdentifier.resume
		resume.keyEquivalent = "r"
		menu.addItem(resume)

		let stop = NSMenuItem()
		stop.title = "Stop"
		stop.target = self
		stop.action = #selector(menuItemHasBeenClicked(_:))
		stop.representedObject = MenuIdentifier.stop
		stop.keyEquivalent = "s"
		menu.addItem(stop)

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
extension AppDelegate {

	@objc
	func menuItemHasBeenClicked(_ sender: NSMenuItem) {
		guard let id = sender.representedObject as? MenuIdentifier else {
			return
		}
		// TODO: = Handle action
	}
}
