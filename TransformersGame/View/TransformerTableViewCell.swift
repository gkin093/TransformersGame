//
//  TransformerTableViewCell.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 10/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import UIKit

class TransformerTableViewCell: UITableViewCell {
    static let identifier = "TransformerTableViewCellIdentifier"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    
    var transformer: Transformer? {
        didSet {
            guard let transformer = transformer else { return }
            nameLabel.text = transformer.name.uppercased()
            idLabel.text = "OVERALL: \(transformer.overallRating)"
            if let stringUrl = transformer.team_icon {
                teamImage.downloaded(from: stringUrl)
            }
            
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
