//
//  EmployeeCoreDataModel.swift
//  UserFormDemoApp
//
//  Created by mac on 27/01/23.
//

import UIKit
import CoreData

class EmployeeAssetsCoreDataModel: NSObject {

   let managedContext = PersistenceManager.sharedInstance.getMainContextInstance()
     
     //get User Data from Entity and set value
     func insertEmployeeRecordFrom(mobileumber :String, dictionary: [String: Any]) {
        
        
         //UpdateExisting Record
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeAssets")
         
         do {
             let fetchedRecords = try self.managedContext.fetch(fetchRequest) as? [EmployeeAssets]
             if (fetchedRecords?.count)! == 0 {
                 
                 if let employeeEntity = NSEntityDescription.insertNewObject(forEntityName: "EmployeeAssets", into: managedContext) as? EmployeeAssets {
                     employeeEntity.name = dictionary["name"] as? String
                     employeeEntity.assetsData = dictionary["assetsData"] as? [String:Any] as NSObject?
                                          
                     do {
                         try self.managedContext.save()
                     }
                     catch{
                         print("There was an error in saving data")
                     }
                 }
             }
         }
         catch let error{
             NSLog("NSError ocurred: \(error)")
         }
     }
     
     
     func retrieveData() -> [NSManagedObject]{
         // Obtaining data from model
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeAssets")
         fetchRequest.returnsObjectsAsFaults = false
         
         // Helpers
         var result = [NSManagedObject]()
         
         do {
             // Execute Fetch Request
             let records = try managedContext.fetch(fetchRequest)
             
             if let records = records as? [NSManagedObject] {
                 result = records
             }
             
         } catch {
             print("Unable to fetch managed objects for entity \("EmployeeAssets").")
         }
         
         return result
     }
    
    //delete All Records in table
    func deleteAllRecords() {
        //getting context from your Core Data Manager Class
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeAssets")
        _ = NSBatchDeleteRequest(fetchRequest: deleteFetch)
       
        do {
             let arrUsrObj = try managedContext.fetch(deleteFetch)
             for usrObj in arrUsrObj as! [NSManagedObject] { // Fetching Object
                 managedContext.delete(usrObj) // Deleting Object
               try managedContext.save()
            }
        } catch {
            print ("There is an error in deleting records")
        }
    }

     
 }
