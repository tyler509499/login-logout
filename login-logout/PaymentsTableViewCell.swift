//
//  PaymentsTableViewCell.swift
//  login-logout
//
//  Created by Galkov Nikita on 23.02.2021.
//

import UIKit

class PaymentsTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.sizeToFit()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
