//
//  PlantTableViewCell.swift
//  WaterMyPlants-iOS
//
//  Created by Austin Potts on 3/2/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {

    
    let plantcontroller = PlantController.shared
   
    
    var plant: Plant? {
        didSet {
            updateViews()
            waterButton.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantSpecies: UILabel!
    @IBOutlet weak var plantFrequency: UILabel!
    
    @IBOutlet weak var backgroundPlantImage: UIImageView!
    
    @IBOutlet weak var waterButton: UIButton!
    
    @IBAction func waterButtonPressed(_ sender: Any) {
        
        //MARK: - Change the Opactiy of Button to Grey when watered
        
         
        waterButton.backgroundColor = .darkGray
    
        
    }
    
    
    
    func updateViews(){
        
        if let plant = plant {
        
            
            plantName.text = plant.nickname
            plantSpecies.text = plant.speciesName
        //  plantImage.image = plant.image
            plantFrequency.text = plant.frequency
            
            
                        
        }
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        updateViews()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
