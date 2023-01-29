//
//  SceneDelegate.swift
//  UserFormDemoApp
//
//  Created by mac on 27/01/23.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var uploadDbDataTimer : Timer?
    var updateDataStatus: Bool?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        updateDataStatus = true
        self.uploadDbDataTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(postDataToServerInBackgroudApi), userInfo: nil, repeats: true)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    // MARK: -
    // MARK: - Stored OffLine Data Post To Server
    // MARK: -
    
    @objc func postDataToServerInBackgroudApi(){
        
        if ConnectionManager.shared.hasConnectivity(){
            
            //Logout
            let coreDataModel = EmployeeAssetsCoreDataModel()
            let empAssetData = coreDataModel.retrieveData()
            
            let serialQueue = DispatchQueue(label: "serialQueue")
            
            if empAssetData.count > 0 {
                if updateDataStatus ?? false {
                    serialQueue.async{  //call this whenever you need to add a new work item to your queue
                        self.empAssetDataRequest(asserData: empAssetData, nextIndex: 0)
                    }
                }
            }
        }
    }
    
    func empAssetDataRequest(asserData:[NSManagedObject] ,nextIndex:Int){
        if asserData.count > nextIndex {
            updateDataStatus = false
            
            let data = asserData[nextIndex]
            
            let paramDict = [
                "name" : (data as AnyObject).value(forKey:"name") as! String,
                "data" :  (data as AnyObject).value(forKey:"assetsData") as! [String : Any]] as [String : Any]
            self.apiCallToPostDataRequest(parametersDict: paramDict as [String : AnyObject], currentIndex: nextIndex)
            
            
        }
        else{
            self.removeLogoutDatFromDb()
        }
    }
    
    func removeLogoutDatFromDb(){
        updateDataStatus = true
        
        let coreDataModel = EmployeeAssetsCoreDataModel()
        coreDataModel.deleteAllRecords()
    }
    
    
    func apiCallToPostDataRequest(parametersDict:[String: Any],currentIndex:Int) {
        
        if ConnectionManager.shared.hasConnectivity(){
            let nextCaseDataArrIndex = currentIndex + 1
            let logoutEntityObj = EmployeeAssetsCoreDataModel()
            let savedCaseData = logoutEntityObj.retrieveData()
            
            WebService.sharedInstance.postRequest(parameter: parametersDict) { (statusCode, responseData) in
                print(statusCode)
                print(responseData)
                
                if statusCode == 200{
                    self.empAssetDataRequest(asserData: savedCaseData, nextIndex: nextCaseDataArrIndex)
                    print("==================Data synce with remote database and delete from local database=============")
                }
                
            }
            
        }
    }
}

