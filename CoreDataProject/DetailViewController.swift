//
//  DetailViewController.swift
//  CoreDataProject
//
//  Created by Volare on 03/01/2018.
//  Copyright © 2018 Acme. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var currentLaptopId: String?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentLaptopId = currentLaptopId {
            let service = LaptopCoreDataService.shared.instance
            let laptop = service.findById(id: currentLaptopId)
            if let laptop = laptop,
                let manufacturer = laptop.manufacturer,
                let model = laptop.model,
                let price = laptop.price,
                let desc = laptop.desc,
                let pic = laptop.pic {
                    lblName.text = "\(manufacturer) \(model)"
                    let formatter = NumberFormatter()
                    formatter.numberStyle = NumberFormatter.Style.currency
                    let formatted = formatter.string(from: price)
                    lblPrice.text = "SRP: \(formatted ?? "n/a")"
                    lblDescription.text = desc
                    lblDescription.numberOfLines = 0
                    lblDescription.sizeToFit()
                    imgView.image = UIImage(data: pic as Data)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
