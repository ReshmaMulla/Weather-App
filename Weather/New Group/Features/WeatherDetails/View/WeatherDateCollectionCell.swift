//
//  WeatherDateCollectionCell.swift
//  Weather
//
//  Created by kartheek.p on 20/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import UIKit

class WeatherDateCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // Making differnciate on selected cell
    override var isSelected: Bool {
        didSet {
            bgView.backgroundColor = isSelected ?  Colour.PrimaryColor : .clear
        }
    }
}
