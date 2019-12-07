//
//  CategoriesTableViewController.swift
//  Tastebuds
//
//  Created by iForsan on 12/6/19.
//  Copyright © 2019 iForsan. All rights reserved.
//

import UIKit

var isMakeTaste: Bool = false

var categoriesList = [
    Category(carId: "1", name: "Cat Video", image: UIImage(named: "catt")),
    Category(carId: "2", name: "Dog Video", image: UIImage(named: "dogg")),
    Category(carId: "3", name: "Comedy Video", image: UIImage(named: "comedy1")),
    Category(carId: "5", name: "Music Video", image: UIImage(named: "music")),
    Category(carId: "6", name: "Nature Video", image: UIImage(named: "Nature")),
    Category(carId: "7", name: "Science Video", image: UIImage(named: "Science")),
    Category(carId: "4", name: "Scary Video", image: UIImage(named: "Scary"))
]

var selectedCatId = ""

class CategoriesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var view1Con: NSLayoutConstraint!
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var urlField: UITextField!
    
    var oldIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        addButton.layer.cornerRadius = 5
        
        if isMakeTaste {
            title = "Make A Taste"
            tableView.rowHeight = 50
            tableView.isScrollEnabled = false
            
        } else {
            title = "Categories"
            view1Con.constant = 0
            bottomConstrain.constant = 0
            addButton.isHidden = true
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CategoryTableViewCell
        
        cell.prepare(model: categoriesList[indexPath.row])
        
        if isMakeTaste {
            cell.catName.textAlignment = .center
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCatId = categoriesList[indexPath.row].carId!
        
        if isMakeTaste {
            
            let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
            
            if oldIndex != nil {
                let old = tableView.cellForRow(at: oldIndex!) as! CategoryTableViewCell
                old.catName.textColor = UIColor.white
            }
            
            let currentCell = tableView.cellForRow(at: indexPath!) as! CategoryTableViewCell
            currentCell.catName.textColor = UIColor.red
            oldIndex = indexPath
            
        } else {
            
            
            
            guard let videos = db.selectVides(catIdValue: selectedCatId), videos.count >= 2 else {
                
                let alert = UIAlertController(title: "Vote", message: "No enough Video to vote", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "VoteViewController") as? VoteViewController
            navigationController?.pushViewController(controller!, animated: true)
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        if urlField.text == "" {
            let alert = UIAlertController(title: "Youtube URL", message: "Please enter the Youtube URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return

        }
        
        if selectedCatId == "" {
            let alert = UIAlertController(title: "Category", message: "Please enter the Category", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if let video = user.object(forKey: "videos") as? [String : Any], video["url"] as? String == urlField.text! {
            
            let alert = UIAlertController(title: "Youtube URL", message: "The Youtube URL already Exist", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        /*
        
        let dic = ["username": currentUser,
                   "url": urlField.text!,
                   "catId": selectedCatId,
                   "voteCount": "1"] as [String : String]
        
        var video = getVideo() ?? [[String: String]]()
        video.append(dic)
        
        user.set(["videos": video], forKey: currentUser)
 */
 
        if db.insertVideo(urlValue: urlField.text!, catIdValue: selectedCatId) {
            startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                
                stopAnimating()
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
                self.navigationController?.pushViewController(controller!, animated: true)
            }
        }
    }
}
