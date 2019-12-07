//
//  TasteMakeViewController.swift
//  Tastebuds
//
//  Created by iForsan on 12/6/19.
//  Copyright © 2019 iForsan. All rights reserved.
//

import UIKit
let storyboard = UIStoryboard(name: "Main", bundle: nil)

class TasteMakeViewController: UIViewController {

    @IBOutlet weak var tasteButton: UIButton!
    @IBOutlet weak var makeButton: UIButton!
    
    @IBOutlet weak var voteView: UIView!
    @IBOutlet weak var makeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        voteView.layer.cornerRadius = 5
        voteView.layer.masksToBounds = true

        makeView.layer.cornerRadius = 5
        makeView.layer.masksToBounds = true
        
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func tasteAction(_ sender: Any) {
        
        isMakeTaste = false
        let controller = storyboard?.instantiateViewController(withIdentifier: "CategoriesTableViewController") as? CategoriesTableViewController
        navigationController?.pushViewController(controller!, animated: true)
    }
    
    @IBAction func makeAction(_ sender: Any) {
    
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
    @IBAction func logout(_ sender: Any) {
        navigationController?.popToRootViewController(animated: false)
    }

    @IBAction func profile(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        navigationController?.pushViewController(controller!, animated: true)
        
    }
    
}
