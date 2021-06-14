//
//  PostDetailTableViewCell.swift
//  Dcard-Test 2
//
//  Created by Ryan Chang on 2021/6/9.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
