//
//  EmployeeAssets+CoreDataProperties.swift
//  UserFormDemoApp
//
//  Created by mac on 28/01/23.
//
//

import Foundation
import CoreData


extension EmployeeAssets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeAssets> {
        return NSFetchRequest<EmployeeAssets>(entityName: "EmployeeAssets")
    }

    @NSManaged public var assetsData: NSObject?
    @NSManaged public var name: String?

}

extension EmployeeAssets : Identifiable {

}
