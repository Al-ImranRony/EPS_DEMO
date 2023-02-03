//
//  OrderCollectionViewCell.swift
//  EPS_Demo
//
//  Created by Bitmorpher 4 on 2/3/23.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var idNumberLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numOfItemLabel: UILabel!
    @IBOutlet weak var invoiceHistoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 150/255, green: 236/255, blue: 204/255, alpha: 1.0).cgColor
        self.layer.cornerRadius = 4.0
        self.invoiceHistoryButton.layer.cornerRadius = 2.0
    }
    
    func updateFilteredOrderCellData(orderList: [OrderInfo], index: Int) {
        if let orderID = orderList[index].bookingID {
            self.idNumberLabel.text = String(stringLiteral: "Order ID #\(orderID)")
        }
        self.orderTimeLabel.text = orderList[index].confirmedDate
        if let totalPrice = orderList[index].totalValue {
            self.priceLabel.text = String(stringLiteral: "\u{009F3}\(totalPrice)")
        }
        if let totalAmount = orderList[index].totalItem {
            self.numOfItemLabel.text = String(stringLiteral: "Total Item : \(totalAmount)")
        }
    }
}
