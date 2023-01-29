//
//  Employee+CoreDataProperties.swift
//  UserFormDemoApp
//
//  Created by mac on 27/01/23.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var profession: String?
    @NSManaged public var mobileNumber: Int16
    @NSManaged public var emailId: String?
    @NSManaged public var name: String?

}

extension Employee : Identifiable {

}
