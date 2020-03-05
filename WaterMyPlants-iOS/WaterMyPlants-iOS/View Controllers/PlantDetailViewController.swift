//
//  PlantDetailViewController.swift
//  WaterMyPlants-iOS
//
//  Created by Tobi Kuyoro on 02/03/2020.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit




class PlantDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    
    var plantController: PlantController?
    var usercontroller: UserController?
    
    var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "MMM dd yyyy"
           formatter.timeZone = TimeZone(secondsFromGMT: 0)
           return formatter
       }()
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var imager: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    
    let frequency = ["5.0",
                     "Everyday",
                     "Every two days",
                     "Every three days",
                     "Once a week"]
    
    var selectedFrequency: String?
    
    // MARK: - View Lifecycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTapGesture()
        createFrequencyPicker()
        
        
        saveButton.layer.cornerRadius = 20
        
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
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
                  picker.allowsEditing = false
                  picker.delegate = self
                  picker.sourceType = .photoLibrary
                  present(picker, animated: true)
    }
    
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    
    @IBAction func savePlantTapped(_ sender: Any) {
        
        
        
        guard let name = nameTextField.text,
            let bearer = usercontroller?.bearer,
            let nickname = nicknameTextField.text,
            let species = speciesTextField.text,
            let frequency = frequencyTextField.text,
            let imager = imager.image else {return}
        
        let plant = Plant(nickname: nickname, speciesName: species, image: nil, frequency: frequency)
        
        plantController?.putPlant(plant: plant, bearer: bearer)
        
        
        
        //MARK: - Start Coundown Timer
      // timerCountdownStart()
        
        
        
        //MARK: - POP to Table View
        
        navigationController?.popToRootViewController(animated: true)
        
        
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

extension PlantDetailViewController {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 227, height: 227), true, 2.0)
            image.draw(in: CGRect(x: 0, y: 0, width: 414, height: 326))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
            var pixelBuffer : CVPixelBuffer?
            let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
            guard (status == kCVReturnSuccess) else {
                return
            }
            
            CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
            
            context?.translateBy(x: 0, y: newImage.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            
            UIGraphicsPushContext(context!)
            newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            imager.image = newImage
    
             
        }
    
    
    
    
}
