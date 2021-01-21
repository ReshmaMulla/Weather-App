//
//  HomeViewCell.swift
//  Weather
//
//  Created by kartheek.p on 19/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import UIKit
protocol HomeCellDelegate:class {
    func removeBookMarkCell<T>(cell: T)
}
class HomeViewCell: UITableViewCell {
@IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    weak var delegate: HomeCellDelegate?
    
    // MARK: - On selectio of remove Book Mark calling delegate method for Home screen controller
    @IBAction func remveBookMarkAction(_ sender: UIButton) {
        guard let delegate = delegate else { return
        }
        delegate.removeBookMarkCell(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
