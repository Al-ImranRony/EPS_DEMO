//
//  OrderInfo.swift
//  EPS_Demo
//
//  Created by Bitmorpher 4 on 2/3/23.
//

import Foundation
import UIKit

public class OrderInfo: NSObject, Codable {
    var bookingID: Int?
    var statusID: Int?
    var confirmedDate: String?
    var totalValue: Float?
    var totalItem: Int?
    
    enum CodingKeys : String, CodingKey {
        case bookingID = "bookingID"
        case statusID = "statusID"
        case confirmedDate = "cd"
        case totalValue = "totalValue"
        case totalItem = "totalItem"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let bookingID = try values.decodeIfPresent(Int.self, forKey: .bookingID) {
            self.bookingID = bookingID
        }
        if let statusID = try values.decodeIfPresent(Int.self, forKey: .statusID) {
            self.statusID = statusID
        }
        if let confirmedDate = try values.decodeIfPresent(String.self, forKey: .confirmedDate) {
            self.confirmedDate = confirmedDate
        }
        if let totalValue = try values.decodeIfPresent(Float.self, forKey: .totalValue) {
            self.totalValue = totalValue
        }
        if let totalItem = try values.decodeIfPresent(Int.self, forKey: .totalItem) {
            self.totalItem = totalItem
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bookingID, forKey: .bookingID)
        try container.encode(statusID, forKey: .statusID)
        try container.encode(confirmedDate, forKey: .confirmedDate)
        try container.encode(totalValue, forKey: .totalValue)
        try container.encode(totalItem, forKey: .totalItem)
    }
}
