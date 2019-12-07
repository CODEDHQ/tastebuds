//
//  ProfileViewController.swift
//  Tastebuds
//
//  Created by iForsan on 12/6/19.
//  Copyright © 2019 iForsan. All rights reserved.
//

import UIKit
import SQLite

class ProfileViewController: UIViewController {

    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var userImage: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
         
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    var user: String?
    var videosList = [Row]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor.white.cgColor
        
        rankingLabel.layer.cornerRadius = rankingLabel.frame.width / 2
        rankingLabel.layer.masksToBounds = true
        
        pointsLabel.layer.cornerRadius = rankingLabel.frame.width / 2
        pointsLabel.layer.masksToBounds = true
        
//        plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openTaste))
        
        
        
        if let row = db.selectUser(usernameValue: user ?? currentUser) {
//            nameLabel.text = row[username]
            title =  row[username]?.capitalized
            nameLabel.isHidden = true
            
            if let name = row[username] {
                userImage.text = String(name.dropLast(name.count - 1)).capitalized
            }
        }
        
        var value = 0
        for video in db.selectVides(usernameValue: user ?? currentUser) ?? [] {
            videosList.append(video)
            value += video[voteCount] + 10
        }
        
        rankingLabel.text = "2"
        pointsLabel.text = value.description
    }
    
    @IBAction func openTaste() {
        
        isMakeTaste = true

        let controller = storyboard?.instantiateViewController(withIdentifier: "CategoriesTableViewController") as? CategoriesTableViewController
        navigationController?.pushViewController(controller!, animated: true)
        
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

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videosList.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell

        cell.prepare(row: videosList[indexPath.row])
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
