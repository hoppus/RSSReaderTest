//
//  ListCell.swift
//  RSSReader
//
//  Created by Eugeniy Popov on 09.01.16.
//  Copyright © 2016 Eugeniy Popov. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var descr: UITextView!
    
    @IBOutlet weak var source: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
