//
//  HomeListTableViewCell.swift
//  SoundCast
//
//  Created by Ankur on 1/18/19.
//  Copyright © 2019 ankur. All rights reserved.
//

import UIKit
import SDWebImage

class HomeListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var homeViewModel: HomeViewModel! {
        didSet {
            
            DispatchQueue.main.async {
                self.img.layer.cornerRadius = self.img.bounds.size.width / 2.0
                self.img.clipsToBounds = true
            }
            nameLabel?.text = homeViewModel.title
            img.sd_setImage(with: URL(string: homeViewModel.thumbnailURL), placeholderImage: UIImage(named: "trackPlaceholder"))
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
