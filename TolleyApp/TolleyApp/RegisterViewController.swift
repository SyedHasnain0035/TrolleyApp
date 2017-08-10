//
//  RegisterViewController.swift
//  TolleyApp
//
//  Created by Rashdan Natiq on 09/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titlePicker: UIPickerView!
    var list = ["Dr", "Mr", "Miss"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titlePicker.delegate = self
        titlePicker.dataSource = self
        
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
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == titlePicker {
            self.titleTextField.text = self.list[row]
            self.titlePicker.isHidden = true
        }
    }
    
  
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.titleTextField){
            self.titlePicker.isHidden = false
        }
    }
   
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
