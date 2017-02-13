//
//  PostTableViewCell.swift
//  devnet
//
//  Created by Zulwiyoza Putra on 2/13/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var modificationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
