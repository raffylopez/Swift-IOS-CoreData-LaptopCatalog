//
//  EmployeesTableTableViewController.swift
//  CoreDataProject
//
//  Created by Volare on 02/01/2018.
//  Copyright © 2018 Acme. All rights reserved.
//

import UIKit
import CoreData

class Globals {
}

class LaptopCoreDataService {
    let context:NSManagedObjectContext
    let entityName:String = "Laptop"
    private init(context:NSManagedObjectContext) {
        self.context = context
    }
    public class shared {
        private static var _instance:LaptopCoreDataService?
        
        // -- Ensure only a single instance is ever created
        public static var instance: LaptopCoreDataService {
            if _instance == nil {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                _instance = LaptopCoreDataService(context:delegate.persistentContainer.viewContext)
            }
            return _instance!
        }
        public static var context:NSManagedObjectContext {
            return shared._instance!.context
        }
    }
    
    func fetchAll()->[Laptop]{
        let fetchRequest = NSFetchRequest<Laptop>(entityName: entityName)
        let laptops = try! context.fetch(fetchRequest)
        return laptops
    }
    
    func findById(id: String)->Laptop? {
        let fetchRequest = NSFetchRequest<Laptop>(entityName: entityName)
        let pred = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = pred
        let laptops = try! context.fetch(fetchRequest)
        return laptops.first
    }
    
    func deleteLaptopWithId(id: String) {
        let targetLaptop = findById(id: id)
        if let targetLaptop = targetLaptop {
            context.delete(targetLaptop)
            saveContext()
        }
    }
    func saveContext() {
        try! context.save()
    }
    
    
    func loadSampleData() {
        let entityDesc = NSEntityDescription.entity(forEntityName: "Laptop", in: context)
        let request = NSFetchRequest<Laptop>(entityName: "Laptop")
        
        if try! context.count(for: request) == 0 {
            let laptop0 = Laptop(entity: entityDesc!, insertInto: context)
            laptop0.id = "MQD42LL/A"
            laptop0.model = "Macbook Air 2017"
            laptop0.manufacturer = "Apple"
            laptop0.desc = "The MacBook Air is a line of Macintosh subnotebook computers developed and manufactured by Apple Inc. It consists of a full-size keyboard, a machined aluminum case, and a thin light structure. The Air is available with a screen size of (measured diagonally) 13.3in (33.782 cm), with different specifications produced by Apple. Since 2011, all MacBook Air models have used solid-state drive storage and Intel Core i5 or i7 CPUs. A MacBook Air with an 11.6in (29.46 cm) screen was made available in 2010."
            laptop0.price = Decimal(900.0) as NSDecimalNumber?
            laptop0.pic = NSData(data:UIImagePNGRepresentation(UIImage(named: "macbookair")!)!)
            
            let laptop1 = Laptop(entity: entityDesc!, insertInto: context)
            laptop1.id = "13-4101dx"
            laptop1.manufacturer = "HP"
            laptop1.model = "Spectre x360 (2017)"
            laptop1.desc = "The Spectre 13 is the latest ultrabook from HP's premium Spectre line. It starts at $1000 and the entry level model features a 13.3-inch display with a dual-core Core i5-4200U processor, 4GB RAM, 128GB SSD and a 1920 x 1080 display. It can be specced up for $1400 for a dual-core Core i7-4500U processor, 8GB RAM, 256GB SSD and a 2560 x 1440 resolution. It weighs 3.34 pounds and was released in October 2013."
            laptop1.price = Decimal(1_068.06) as NSDecimalNumber?
            laptop1.pic = NSData(data:UIImagePNGRepresentation(UIImage(named: "spectre")!)!)
            
            let laptop2 = Laptop(entity: entityDesc!, insertInto: context)
            laptop2.id = "XPS9360-1718SLV"
            laptop2.manufacturer = "Dell"
            laptop2.model = "XPS 13"
            laptop2.desc = "The Dell XPS 13 was unveiled at CES 2012. It is the company's first Ultrabook, a term coined by Intel. The XPS 13 features a 13.3-inch screen (1366 x 768 NON Touch Corning Gorilla Glass) and uses flash memory to help with fast booting. The XPS 13 features certain unique design elements. The edges are rounded and the bottom is made of carbon fibre, with a gentle silicone surface treatment. Dell also offers a developer's version of the XPS 13 running Ubuntu Linux."
            laptop2.price = Decimal(779.99) as NSDecimalNumber?
            laptop2.pic = NSData(data:UIImagePNGRepresentation(UIImage(named: "spectre")!)!)
            
            saveContext()
        }
    }
}

class LaptopListingTableViewController: UITableViewController {
    var ultrabooks:[(String,String)] = []
    let service  = LaptopCoreDataService.shared.instance
    func populateTable() {
        service.loadSampleData()
        let laptops = service.fetchAll()
        ultrabooks = laptops.map {
            laptop in
            if let id = laptop.id, let manufacturer = laptop.manufacturer, let model = laptop.model {
                return (id, "\(manufacturer) \(model)")
            } else {
                return ("<none>", "<none>")
            }
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTable()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            service.deleteLaptopWithId(id: ultrabooks[indexPath.row].0)
            populateTable()
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLaptopId = ultrabooks[indexPath.row].0
        performSegue(withIdentifier: "goto_details", sender: self)
    }
    
    var selectedLaptopId: String? = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DetailViewController
        dest.currentLaptopId = selectedLaptopId
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ultrabooks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ultrabooks[indexPath.row].1
        cell.detailTextLabel?.text = ultrabooks[indexPath.row].0
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
