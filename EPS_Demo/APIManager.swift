//
//  APIManager.swift
//  EPS_Demo
//
//  Created by Bitmorpher 4 on 2/3/23.
//

import Foundation


class APIManager {
    static let shared = APIManager()
    
    var shopSummary: ShopSummary?
    var orderList: [OrderInfo] = []
    
    func getShopSummary(complition: @escaping (ShopSummary?) -> Void, failure: @escaping() -> Void) {
        let session = URLSession.shared
        let shopURL = URL(string: "http://test.bdbizhub.com/Api/App/Shop")!
        let parameters: [String: Any] = [
            "UserID": 120,
            "CompanyID": 29,
            "ShopFK": 8
        ]
        var request = URLRequest(url: shopURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        do {
           request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
         } catch let error {
           print(error.localizedDescription)
           return
         }

        let taskSession = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                failure()
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                let responseData = data else { return }
            let statusCode = httpResponse.statusCode
            if statusCode != 200 {
                failure()
                return
            }

            let decoder = JSONDecoder()
            do {
                let shopSummary = try decoder.decode(ShopSummary.self, from: responseData)
                
                DispatchQueue.main.async {
                    complition(shopSummary)
                }
            } catch {
                print("Conversion not possible")
            }
        }
        taskSession.resume()
    }
    
    func getOrderList(complition: @escaping ([OrderInfo]) -> Void, failure: @escaping() -> Void) {
        let session = URLSession.shared
        let orderURL = URL(string: "http://test.bdbizhub.com/Api/App/Orders")!
        let parameters: [String: Any] = [
            "UserID" :120,
            "CompanyID" : 29,
            "ShopFK" : 8,
            "StatusID" : 0
        ]
        var request = URLRequest(url: orderURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        do {
           request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
         } catch let error {
           print(error.localizedDescription)
           return
         }
        
        let taskSession = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                failure()
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                let responseData = data else { return }
            let statusCode = httpResponse.statusCode
            if statusCode != 200 {
                failure()
                return
            }

            let decoder = JSONDecoder()
            do {
                let orderList = try decoder.decode([OrderInfo].self, from: responseData)
                
                DispatchQueue.main.async {
                    complition(orderList)
                }
            } catch {
                print("Conversion not possible")
            }
        }
        taskSession.resume()
    }
    
    func callShopAPI(withCompletion : @escaping (ShopSummary)-> ()) {
        getShopSummary { [weak self] (fetchedShopSummary) in
            guard let fetchedData = fetchedShopSummary else { return }
            self?.shopSummary = fetchedData
            withCompletion(fetchedData)
        } failure: {
            print("Shop summary API call failed !")
        }
    }
    
    func callOrderAPI(withCompletion : @escaping ([OrderInfo])-> ()) {
        getOrderList(complition: { [weak self] (fetchedOrders) in
//            guard let fetchedData = fetchedOrders else { return }
            self?.orderList = fetchedOrders
            withCompletion(fetchedOrders)
        }, failure: {
            print("Order List API call failed !")
        })
    }
}
