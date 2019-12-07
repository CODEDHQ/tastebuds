//
//  CategoryTableViewCell.swift
//  Tastebuds
//
//  Created by iForsan on 12/6/19.
//  Copyright © 2019 iForsan. All rights reserved.
//

import UIKit
import DynamicBlurView

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var catName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func prepare(model: Category) {
        imgView.image = model.image
        catName.text = model.name
        
        var y = imgView.frame.height - 50
        if isMakeTaste {
            y = 0
        } else {
            
        }
        
        
        let frame = CGRect(x: 0, y: y , width: blurView.frame.width, height: blurView.frame.height)
        let blurView2 = DynamicBlurView(frame: frame)
        blurView2.blurRadius = 10
        blurView2.blurRatio = 0.5
        imgView.insertSubview(blurView2, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
