//
//  ShopSummary.swift
//  EPS_Demo
//
//  Created by Bitmorpher 4 on 2/3/23.
//

import UIKit


public class ShopSummary: NSObject, Codable {
    var shopName: String?
    var address: String?
    var confirm: Int?
    var partialDelivered: Int?
    var delivered: Int?
    
    enum CodingKeys : String, CodingKey {
        case shopName = "shopName"
        case address = "address"
        case confirm = "confirm"
        case partialDelivered = "partialDelivered"
        case delivered = "delivered"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let shopName = try values.decodeIfPresent(String.self, forKey: .shopName) {
            self.shopName = shopName
        }
        if let address = try values.decodeIfPresent(String.self, forKey: .address) {
            self.address = address
        }
        if let confirm = try values.decodeIfPresent(Int.self, forKey: .confirm) {
            self.confirm = confirm
        }
        if let partialDelivered = try values.decodeIfPresent(Int.self, forKey: .partialDelivered) {
            self.partialDelivered = partialDelivered
        }
        if let delivered = try values.decodeIfPresent(Int.self, forKey: .delivered) {
            self.delivered = delivered
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shopName, forKey: .shopName)
        try container.encode(address, forKey: .address)
        try container.encode(confirm, forKey: .confirm)
        try container.encode(partialDelivered, forKey: .partialDelivered)
        try container.encode(delivered, forKey: .delivered)
    }
}

