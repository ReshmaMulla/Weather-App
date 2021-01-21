//
//  WeatherDetailsTableCell.swift
//  Weather
//
//  Created by kartheek.p on 20/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import UIKit
protocol DateCollectionCellDelegate: class {
    func dateSelected(index: Int)
}
class WeatherDetailsTableCell: UITableViewCell {
    @IBOutlet weak var collecionView: UICollectionView!
    weak var delegate:DateCollectionCellDelegate?
    var dates: [String]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collecionView.register(UINib.init(nibName: "WeatherDateCollectionCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifers.weatherDetailDateCollectionCell)
        
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // making 1st selection item as selected
        self.collecionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: [])
        // Configure the view for the selected state
    }
    
}
//Mark: - Collection view Delegate Methods
extension WeatherDetailsTableCell:UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dates = dates, !dates.isEmpty else {
            return 0
        }
        return dates.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifers.weatherDetailDateCollectionCell, for: indexPath as IndexPath) as! WeatherDateCollectionCell
        guard let dates = dates, !dates.isEmpty else {
            return cell
        }
        cell.titleLbl.text = dates[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        delegate.dateSelected(index: indexPath.row)
    }
}
