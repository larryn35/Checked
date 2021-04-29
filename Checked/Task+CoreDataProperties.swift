//
//  Task+CoreDataProperties.swift
//  Checked
//
//  Created by Larry N on 4/29/21.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var dateCompleted_: Date?
    @NSManaged public var dateCreated_: Date?
    @NSManaged public var deadline_: Date?
    @NSManaged public var reminderDate_: Date?
    @NSManaged public var id_: UUID?
    @NSManaged public var notes_: String?
    @NSManaged public var priority_: String?
    @NSManaged public var title_: String?

}

extension Task : Identifiable {

}
