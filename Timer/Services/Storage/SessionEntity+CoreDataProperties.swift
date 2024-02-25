//
//  SessionEntity+CoreDataProperties.swift
//  Timer
//
//  Created by Anton Cherkasov on 25.02.2024.
//
//

import Foundation
import CoreData


extension SessionEntity {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<SessionEntity> {
		return NSFetchRequest<SessionEntity>(entityName: "SessionEntity")
	}
	
	@NSManaged public var uuid: UUID
	@NSManaged public var start: Date
	@NSManaged public var end: Date

	public override func awakeFromInsert() {
		super.awakeFromInsert()
		self.uuid = UUID()
		self.start = Date()
		self.end = Date()
	}

}

extension SessionEntity {

	var duration: TimeInterval {
		return end.distance(to: start)
	}
}

// MARK: - Identifiable
extension SessionEntity : Identifiable { }
