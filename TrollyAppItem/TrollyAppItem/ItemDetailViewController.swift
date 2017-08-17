//
//  ItemDetailViewController.swift
//  TrollyAppItem
//
//  Created by Rashdan Natiq on 15/08/2017.
//  Copyright © 2017 Devclan. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
class ItemDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,  UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var checkActiveImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var isActiveButton: UIButton!
    @IBOutlet weak var itemTypTextField: UITextField!
    @IBOutlet weak var itemWeightTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemDetailTextField: UITextField!
    var selcted = false
    var selectedActive = 0
    var item: ItemInfo?
    var refrence: DatabaseReference?
    var typesList = ["Fruit", "Vegetable"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        updateSaveButtonState()
        refrence = Database.database().reference()
            self.itemDetailTextField.text = item?.itemDetail ?? ""
            self.itemTypTextField.text = item?.itemType ?? ""
            self.itemPriceTextField.text = item?.itemPrice ?? ""
            self.itemWeightTextField.text = item?.itemWeight ?? ""
            self.itemImage.image = #imageLiteral(resourceName: "loading")
        if item != nil {
            self.selectedActive = (item?.active)!
            let imageView = self.itemImage.viewWithTag(1) as! UIImageView
            imageView.sd_setImage(with: URL(string: (item?.itemImage)!))
        }
                   if (item?.active == 1) {
                self.checkActiveImage.image = #imageLiteral(resourceName: "checked")
            } else {
                self.checkActiveImage.image = #imageLiteral(resourceName: "blank_box")
                
            }
    }
    override func viewWillAppear(_ animated: Bool) {
        updateSaveButtonState()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        updateSaveButtonState()
        if (textField == self.itemTypTextField){
            self.itemTypePicker.isHidden = false
        } else {
            self.itemTypePicker.isHidden = true
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        updateSaveButtonState()

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info [UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let orignalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = orignalImage
        }else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        if let selectedImage = selectedImageFromPicker {
            itemImage.image = selectedImage
        }
        
        // Dissmis Picker
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapActiveButton(_ sender: UIButton) {
        if self.selcted == false {
            selectedActive = 1
            self.selcted = true
            self.checkActiveImage.image = #imageLiteral(resourceName: "checked")
        } else {
           selectedActive = 0
            self.selcted = false
            self.checkActiveImage.image = #imageLiteral(resourceName: "blank_box")
        }
    }

    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }

    }
    @IBAction func selectImageFromPhotoGallery(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let detail = itemDetailTextField.text!
        let price = itemPriceTextField.text!
        let weight = itemWeightTextField.text!
        let type = itemTypTextField.text!
        let active = selectedActive
        let imageName = NSUUID().uuidString
        let storeRef = Storage.storage().reference().child("Item Images").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.itemImage.image!) {
            storeRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("\(error)")
                    return
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                 self.refrence?.child("ItemInfo").childByAutoId().setValue(["Detail": detail, "Image": profileImageUrl, "Price": price, "Weight": weight, "Type": type, "Active": active ])
                }
            })
        }
    }
    
    ////////////////////////////////////////////////////
    ///// Picker Type ///////////
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows : Int = typesList.count
        if pickerView == itemTypePicker {
            
            countrows = self.typesList.count
        }
        
        return countrows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == itemTypePicker {
            
            let titleRow = typesList[row]
            
            return titleRow
            
        }
        return ""
    }
    // Picker View delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == itemTypePicker {
            self.itemTypTextField.text = self.typesList[row]
            self.itemTypePicker.isHidden = true
        }
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        if  itemTypTextField.text == "" || itemWeightTextField.text == "" || itemPriceTextField.text == "" || itemTypTextField.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    func setDelegate() {
        itemTypePicker.delegate = self
        itemTypePicker.dataSource = self
        self.itemTypePicker.isHidden = true
        itemTypTextField.delegate = self
        itemPriceTextField.delegate = self
        itemWeightTextField.delegate = self
        itemDetailTextField.delegate = self
    }
    func uploadImageToFireBase() -> String {
        let storeRef = Storage.storage().reference().child("ItemImage.png")
        var url = ""
        if let uploadData = UIImagePNGRepresentation(self.itemImage.image!) {
            storeRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                  
                    return
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                     url =  profileImageUrl
                }
            
            })
        }
        return url
    }
}
