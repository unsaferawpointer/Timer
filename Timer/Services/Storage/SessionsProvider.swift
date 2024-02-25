//
//  SessionsProvider.swift
//  Timer
//
//  Created by Anton Cherkasov on 25.02.2024.
//

import Foundation
import CoreData

protocol SessionsProviderProtocol {
	func subscribe(_ object: SessionsProviderDelegate) throws
	func insertSession(_ session: Session) throws
	func save() throws
}

protocol SessionsProviderDelegate: AnyObject {
	func providerDidChangeContent(_ sessions: [Session])
}

final class SessionsProvider: NSObject {

	private var context: NSManagedObjectContext

	private var controller: NSFetchedResultsController<SessionEntity>?

	weak var delegate: SessionsProviderDelegate?

	// MARK: - Initialization

	init(context: NSManagedObjectContext) {
		self.context = context
		super.init()
		self.controller = configure()
	}
}

// MARK: - Helpers
private extension SessionsProvider {

	func configure() -> NSFetchedResultsController<SessionEntity> {
		let request = SessionEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \SessionEntity.start, ascending: false)]
		request.predicate = nil

		let controller = NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil
		)

		controller.delegate = self
		return controller
	}
}

// MARK: - SessionsProviderProtocol
extension SessionsProvider: SessionsProviderProtocol {

	func subscribe(_ object: SessionsProviderDelegate) throws {
		self.delegate = object

		try controller?.performFetch()

		let entities = controller?.fetchedObjects ?? []
		let sessions = entities.map { entity in
			Session(
				start: entity.start,
				duration: .init(entity.duration)
			)
		}

		delegate?.providerDidChangeContent(sessions)
	}

	func insertSession(_ session: Session) throws {
		let new = SessionEntity(context: context)
		new.start = session.start
		new.end = session.start.addingTimeInterval(session.duration)
	}

	func save() throws {
		guard context.hasChanges else {
			return
		}

		try context.save()
	}
}

// MARK: - NSFetchedResultsControllerDelegate
extension SessionsProvider: NSFetchedResultsControllerDelegate {

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

		guard let entities = controller.fetchedObjects as? [SessionEntity] else {
			return
		}

		let sessions = entities.map { entity in
			Session(
				start: entity.start,
				duration: .init(entity.duration)
			)
		}

		delegate?.providerDidChangeContent(sessions)
	}
}
