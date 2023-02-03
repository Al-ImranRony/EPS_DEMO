//
//  ShopProfileViewController.swift
//  EPS_Demo
//
//  Created by iMrn on 2/3/23.
//

import UIKit


public enum SelectedOrderType : String {
    case confirmed = "Confirmed",
    partialDelivered = "PartiallyDelivered",
    delivered = "Delivered"
}

class ShopProfileViewController: UIViewController {
    
    @IBOutlet weak var shopTitleLabel: UILabel!
    @IBOutlet weak var shopAddLabel: UILabel!
    
    @IBOutlet weak var confirmedButton: UIButton!
    @IBOutlet weak var partialDeliverButton: UIButton!
    @IBOutlet weak var deliveredButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchLabel: UILabel!
    
    @IBOutlet weak var orderListCollectionView: UICollectionView!
    
    var cellIdentifier = "OrderCollectionViewCell"
    var shopSummary: ShopSummary?
    var orderItems: [OrderInfo] = []
    var activityIndicatorView: ActivityIndicatorView!
    var confirmedOrderList: [OrderInfo] = []
    var partialDeliveredList: [OrderInfo] = []
    var deliveredOrderList: [OrderInfo] = []
    var searchInOrderList: [OrderInfo] = []
    var isSearchApplied = false
    
    var selectedType = SelectedOrderType.confirmed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeAPICall()

        setupShopSummeryView()
        setupSearchBarView()
        setupCollectionView()
    }
    
    func makeAPICall() {
        DispatchQueue.global(qos: .background).async {
            APIManager.shared.callShopAPI(withCompletion: { (shopSummary) in
                self.shopSummary = shopSummary
                self.updateShopSummaryData()
            })
            APIManager.shared.callOrderAPI { (orderList) in
                self.orderItems = orderList
                self.setupFilteredOrderList()
            }
        }
    }
    
    func updateShopSummaryData() {
        DispatchQueue.main.async {
            if let shop = self.shopSummary {
                if let shopName = shop.shopName {
                    self.shopTitleLabel.text = shopName
                }
                if let address = shop.address {
                    self.shopAddLabel.text = address
                }
                if let confirmedNum = shop.confirm {
                    self.confirmedButton.setTitle(String(stringLiteral: "C-\(confirmedNum)"), for: .normal)
                }
                if let partialDeliverNum = shop.partialDelivered {
                    self.partialDeliverButton.setTitle(String(stringLiteral: "PD-\(partialDeliverNum)"), for: .normal)
                }
                if let deliveredNum = shop.delivered {
                    self.deliveredButton.setTitle(String(stringLiteral: "D-\(deliveredNum)"), for: .normal)
                }
            }
        }
    }
    
    func setupShopSummeryView() {
        confirmedButton.layer.borderColor = ShopViewsConfig.getConfirmedButtonColor().cgColor
        confirmedButton.layer.borderWidth = ShopViewsConfig.getButtonBorderWidth()
        confirmedButton.layer.cornerRadius = ShopViewsConfig.getButtonCornerRadius()
        
        partialDeliverButton.layer.borderColor = ShopViewsConfig.getpartialCButtonColor().cgColor
        partialDeliverButton.layer.borderWidth = ShopViewsConfig.getButtonBorderWidth()
        partialDeliverButton.layer.cornerRadius = ShopViewsConfig.getButtonCornerRadius()
        
        deliveredButton.layer.borderColor = ShopViewsConfig.getDelivredButtonColor().cgColor
        deliveredButton.layer.borderWidth = ShopViewsConfig.getButtonBorderWidth()
        deliveredButton.layer.cornerRadius = ShopViewsConfig.getButtonCornerRadius()
    }
    
    @IBAction func confirmedButtonAction(_ sender: Any) {
        confirmedButton.backgroundColor = ShopViewsConfig.getConfirmedButtonColor()
        confirmedButton.setTitleColor(.white, for: .normal)
        
        selectedType = SelectedOrderType.confirmed
        
        partialDeliverButton.backgroundColor = .clear
        partialDeliverButton.setTitleColor(ShopViewsConfig.getpartialCButtonColor(), for: .normal)
        deliveredButton.backgroundColor = .clear
        deliveredButton.setTitleColor(ShopViewsConfig.getDelivredButtonColor(), for: .normal)
        
        self.orderListCollectionView.reloadData()
    }
    
    @IBAction func partialDeliverBtnAction(_ sender: Any) {
        partialDeliverButton.backgroundColor = ShopViewsConfig.getpartialCButtonColor()
        partialDeliverButton.setTitleColor(.black, for: .normal)
        
        selectedType = SelectedOrderType.partialDelivered
        
        confirmedButton.backgroundColor = .clear
        confirmedButton.setTitleColor(ShopViewsConfig.getConfirmedButtonColor(), for: .normal)
        deliveredButton.backgroundColor = .clear
        deliveredButton.setTitleColor(ShopViewsConfig.getDelivredButtonColor(), for: .normal)
        
        self.orderListCollectionView.reloadData()
    }
    
    @IBAction func deliveredButtonAction(_ sender: Any) {
        deliveredButton.backgroundColor = ShopViewsConfig.getDelivredButtonColor()
        deliveredButton.setTitleColor(.white, for: .normal)
        
        selectedType = SelectedOrderType.delivered
        
        partialDeliverButton.backgroundColor = .clear
        partialDeliverButton.setTitleColor(ShopViewsConfig.getpartialCButtonColor(), for: .normal)
        confirmedButton.backgroundColor = .clear
        confirmedButton.setTitleColor(ShopViewsConfig.getConfirmedButtonColor(), for: .normal)
        
        self.orderListCollectionView.reloadData()
    }
    
    func setupSearchBarView() {
        let paddingView = UIView(frame: CGRectMake(0, 0, 40, 16));
        searchTextField.leftView = paddingView;
        searchTextField.leftViewMode = .always;
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(didChangeTextFieldValue), for: .editingChanged)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        searchWith(text: searchTextField.text!)
        searchTextField.resignFirstResponder()
        searchLabel.isHidden = false
        isSearchApplied = true
    }
    
    func searchWith(text: String) {
        let searchKey = text.lowercased()
        if searchKey.isEmpty { return }
        searchInOrderList.removeAll()
        switch selectedType {
        case .confirmed:
            for orderItem in self.confirmedOrderList {
                if String("\(orderItem.bookingID)").contains(searchKey) {
                    self.searchInOrderList.append(orderItem)
                }
                if String("\(orderItem.totalValue)").contains(searchKey) {
                    self.searchInOrderList.append(orderItem)
                }
            }
        case .partialDelivered:
            for orderItem in self.partialDeliveredList {
                if String("\(orderItem.bookingID)").contains(searchKey) {
                    self.searchInOrderList.append(orderItem)
                }
                if (String("\(orderItem.totalValue)") == searchKey) {
                    self.searchInOrderList.append(orderItem)
                }
            }
        case .delivered:
            for orderItem in self.deliveredOrderList {
                if String("\(orderItem.bookingID)").contains(searchKey) {
                    self.searchInOrderList.append(orderItem)
                }
                if (String("\(orderItem.totalValue)") == searchKey) {
                    self.searchInOrderList.append(orderItem)
                }
            }
        }
        self.orderListCollectionView.reloadData()
    }
    
    func setupCollectionView() {
        orderListCollectionView.delegate = self
        orderListCollectionView.dataSource = self
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        orderListCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func setupFilteredOrderList() {
        DispatchQueue.main.async {
            self.orderItems.forEach { (orderItem) in
                if orderItem.statusID == 9 {
                    self.confirmedOrderList.append(orderItem)
                }
                if orderItem.statusID == 15 {
                    self.partialDeliveredList.append(orderItem)
                }
                if orderItem.statusID == 12 {
                    self.deliveredOrderList.append(orderItem)
                }
            }
            self.orderListCollectionView.reloadData()
        }
    }
}

extension ShopProfileViewController: UITextFieldDelegate {
    @objc func didChangeTextFieldValue(textField: UITextField) {
        if ((textField.text?.isEmpty) != nil) {
            searchLabel.isHidden = false
            isSearchApplied = true
        }
        else {
            searchLabel.isHidden = true
        }
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.textColor = .black
        searchLabel.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        searchWith(text: searchTextField.text!)
        isSearchApplied = true
        return true
    }
}


extension ShopProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! OrderCollectionViewCell
        if (isSearchApplied && searchTextField.text != ""){
            cell.invoiceHistoryButton.isHidden = false
            cell.updateFilteredOrderCellData(orderList: searchInOrderList, index: indexPath.item)
            return cell
        }
        switch selectedType {
        case .confirmed:
            cell.invoiceHistoryButton.isHidden = true
            cell.updateFilteredOrderCellData(orderList: self.confirmedOrderList, index: indexPath.item)
        case .partialDelivered:
            cell.invoiceHistoryButton.isHidden = false
            cell.updateFilteredOrderCellData(orderList: self.confirmedOrderList, index: indexPath.item)
        case .delivered:
            cell.invoiceHistoryButton.isHidden = false
            cell.updateFilteredOrderCellData(orderList: self.confirmedOrderList, index: indexPath.item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchApplied && searchTextField.text != "" {
            return self.searchInOrderList.count
        }
        switch selectedType {
        case .confirmed:
            return self.confirmedOrderList.count
        case .partialDelivered:
            return self.partialDeliveredList.count
        case .delivered:
            return self.deliveredOrderList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ShopProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.orderListCollectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
}
