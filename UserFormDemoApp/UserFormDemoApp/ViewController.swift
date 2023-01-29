//
//  ViewController.swift
//  UserFormDemoApp
//
//  Created by mac on 27/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var CPUmodel: UITextField!
    @IBOutlet weak var hddSize: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func submitEmolyeeRecord(sender: AnyObject){
        
        if (name.text?.count == 0) {
            showAlert(message: "Enter Asset Name")
        }
        else if (year.text?.count == 0) {
            showAlert(message: "Enter Year")
        }
        else if (price.text?.count == 0) {
            showAlert(message: "Enter Price")
        }
        else if (CPUmodel.text?.count == 0) {
            showAlert(message: "Enter CPU Model")
        }
        else if (hddSize.text?.count == 0) {
            showAlert(message: "Enter HardDisk Size")
        }
        else{
            self.view.endEditing(true)
            
            
            let partsDict = ["year": Int(year.text!) ?? 2023 ,"price" : Double(price.text!) ?? 1000.0 ,"CPU model" : CPUmodel.text! ,"Hard disk size": "\(hddSize.text!) TB"] as [String : Any]
            
            let paramDict = ["name":name.text!  ,"assetsData": partsDict] as [String : Any]
            
            print("request Dict body \(paramDict)")
            DispatchQueue.main.async {
                let coreDataModal = EmployeeAssetsCoreDataModel()
                coreDataModal.insertEmployeeRecordFrom(mobileumber: paramDict["name"] as! String, dictionary: paramDict as [String : Any])
                print("==================Data successfully load in local database===================")
            }
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "EmploreeApp", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension ViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text?.count == 0) && (string == " " || string == "\n" ){
            return false
        }
    
        if textField == year || textField == price{
            let allowedCharacters = CharacterSet.decimalDigits
               let characterSet = CharacterSet(charactersIn: string)
               return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true
    }
}


