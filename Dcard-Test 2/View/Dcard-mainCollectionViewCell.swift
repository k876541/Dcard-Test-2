//
//  Dcard-mainCollectionViewCell.swift
//  Dcard-Test 2
//
//  Created by Ryan Chang on 2021/6/4.
//

import UIKit

class Dcard_mainCollectionViewCell: UICollectionViewCell {
 

    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var fNameLabel: UILabel!
    @IBOutlet weak var collectionViewView: UIView!
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!
    
    let width = floor((UIScreen.main.bounds.width-10)/2)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(UIScreen.main.bounds.width,UIScreen.main.bounds.width-10,(UIScreen.main.bounds.width-10)/2)
        cellWidthConstraint?.constant = self.width
        
        
    }
  

}
