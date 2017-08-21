//
//  RegisterViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 09/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
class RegisterViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var lastNameTexxtField: UITextField!
    @IBOutlet weak var specialInstructionTextFiled: UITextField!
    @IBOutlet weak var apparmentTextField: UITextField!
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var ReligionTextField: UITextField!
    @IBOutlet weak var NationalityTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var confromPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var phonenumberTextField: UITextField!
    @IBOutlet weak var modileCodeTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titlePicker: UIPickerView!
    var list = ["Dr", "Mr", "Miss"]
    
    
    
    // Data base Refrance 
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titlePicker.delegate = self
        titlePicker.dataSource = self
        
        ref = Database.database().reference()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows : Int = list.count
        if pickerView == titlePicker {
            
            countrows = self.list.count
        }
        
        return countrows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == titlePicker {
            
            let titleRow = list[row]
            
            return titleRow
            
        }
            
        else if pickerView == titlePicker{
            let titleRow = list[row]
            
            return titleRow
        }
        
        return ""
    }
    // Picker View delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == titlePicker {
            self.titleTextField.text = self.list[row]
            self.titlePicker.isHidden = true
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == self.titleTextField){
            self.titlePicker.isHidden = false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.titleTextField){
            self.titlePicker.isHidden = false
        }
    }
   
    @IBAction func didTapCreatAccountButton(_ sender: UIButton) {
        if emailtextField.text == "" || passwordTextField.text == "" || firstNameTextField.text == "" || lastNameTexxtField.text == "" || modileCodeTextField.text == "" || phonenumberTextField.text == "" || titleTextField.text == "" || countryCodeTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "So Required Data is missing ", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else if passwordTextField.text != confromPasswordTextField.text {
            let alertController = UIAlertController(title: "Error", message: "Password Not Matched ", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {   // Sing Up
                Auth.auth().createUser(withEmail: emailtextField.text!, password: passwordTextField.text!) { (user, error) in
                    
                    if error == nil {
                        print("You have successfully signed up")
                        // compelsary
                        let userID: String = (user?.uid)!
                        let userEmail: String = self.emailtextField.text!
                        let userPassword: String = self.passwordTextField.text!
                        let userFirstName: String = self.firstNameTextField.text!
                        let userLastName: String = self.lastNameTexxtField.text!
                        let userTitle: String = self.titleTextField.text!
                        let userCountryCode: String = self.countryCodeTextField.text!
                        let userMobileCode: String = self.modileCodeTextField.text!
                        let userPhoneNumber: String = self.phonenumberTextField.text!
                        // aditional Info
                        let userBirthDay: String = self.dateOfBirth.text ?? "-"
                        let userGender: String = self.genderTextField.text ?? "-"
                        let userNationality: String = self.NationalityTextField.text ?? "-"
                        let userReligon: String = self.ReligionTextField.text ?? "-"
                        let userAreaAddress: String = self.areaTextField.text ?? "-"
                        let userApparment: String = self.apparmentTextField.text ?? "-"
                        let userSpecialInstruction: String = self.specialInstructionTextFiled.text ?? "-"
                        let userBuildingAddress: String = self.buildingTextField.text ?? "-"
                        
                        self.ref?.child("User").child(userID).setValue(["Title": userTitle, "FirstName": userFirstName, "LastName":userLastName, "CountryCode": userCountryCode, "MobileCode": userMobileCode, "MobileNumber": userPhoneNumber, "Email": userEmail, "Password": userPassword, "Birthdate": userBirthDay, "Gender": userGender, "Nationality": userNationality, "Religion": userReligon, "Area": userAreaAddress, "Apparment": userApparment, "BuildingNo": userBuildingAddress, "SpecialInstruction": userSpecialInstruction])
                        
                        self.performSegue(withIdentifier: "goToHomeViewFromSingUp", sender: self)
                        
                        
                    } else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }

            }

    }
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
