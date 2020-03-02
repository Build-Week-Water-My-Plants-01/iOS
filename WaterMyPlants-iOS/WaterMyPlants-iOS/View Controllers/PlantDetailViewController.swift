//
//  PlantDetailViewController.swift
//  WaterMyPlants-iOS
//
//  Created by Tobi Kuyoro on 02/03/2020.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    
    // MARK: - Properties
    
    let frequency = ["Everyday",
                     "Every two days",
                     "Every three days",
                     "Once a week"]
    
    var selectedFrequency: String?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTapGesture()
        createFrequencyPicker()
    }
    
    // MARK: - Tap Gesture Method
    
    func createTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Frequency Method
    
    func createFrequencyPicker() {
        let frequencyPicker = UIPickerView()
        frequencyPicker.delegate = self
        frequencyPicker.backgroundColor = .clear
        frequencyTextField.inputView = frequencyPicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension PlantDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFrequency = frequency[row]
        frequencyTextField.text = selectedFrequency
    }
}
