//
//  PackageCell.swift
//  ordertracking
//
//  Created by Lincoln Nguyen on 4/9/21.
//

import UIKit

class PackageCell: UITableViewCell {
    @IBOutlet weak var statusDescription: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var checkpointStatus: UILabel!
    @IBOutlet weak var orderNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
