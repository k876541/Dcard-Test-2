//
//  ForumsCollectionViewCell.swift
//  Dcard-Test 2
//
//  Created by Ryan Chang on 2021/6/7.
//

import UIKit

class ForumsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var forumsNameLabel: UILabel!

    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!
    
    let width = floor((UIScreen.main.bounds.width-0)/3.3)

    
    override func awakeFromNib() {
        
        cellWidthConstraint.constant = width
        
    }
    
    
    
}
