//
//  NewsCell.swift
//  Portfolio
//
//  Created by 안정은 on 10/12/2018.
//  Copyright © 2018 portfolio. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
