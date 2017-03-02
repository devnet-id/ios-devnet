//
//  PostsListTableViewCell.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 3/2/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit

class PostsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}