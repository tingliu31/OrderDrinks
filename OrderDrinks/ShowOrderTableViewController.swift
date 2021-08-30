//
//  ShowOrderTableViewController.swift
//  OrderDrinks
//
//  Created by student on 2021/7/4.
//

import UIKit
import Firebase
import FirebaseFirestore


class ShowOrderTabelViewCell: UITableViewCell {
    
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var enNameLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
}


class ShowOrderTableViewController: UITableViewController {
    
    
    @IBOutlet var orderListTableView: UITableView!
    @IBOutlet weak var numberOfDrinksLabel: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    var documentId:[String] = []
    var nameList:[String] = []
    var drinkList:[String] = []
    var enDrinkList:[String] = []
    var sizeList:[String] = []
    var sugarList:[String] = []
    var iceList:[String] = []
    var priceList:[String] = []
    var newPriceList = [Int]()
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(self.orderListTableView.numberOfRows(inSection: 0))

        orderListTableView.dataSource = self
        orderListTableView.delegate = self
        
        db = Firestore.firestore()
        readData()
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    
    }
    
    
    // 警告
    func alert(title:String,message:String) {
        // 建立一個提示框
        let alertController = UIAlertController(title: title,message: message,preferredStyle: .alert)
        // 建立[確認]按鈕
        let okAction = UIAlertAction(title: "確認", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
            }
        alertController.addAction(okAction)
        // 顯示提示框
        self.present(alertController,animated: true,completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.nameList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "showOrderCell", for: indexPath) as! ShowOrderTabelViewCell
        cell.drinkNameLabel.text = drinkList[indexPath.row]
        cell.orderNameLabel.text = nameList[indexPath.row]
        cell.enNameLabel.text = enDrinkList[indexPath.row]
        cell.iceLabel.text = iceList[indexPath.row]
        cell.sugarLabel.text = sugarList[indexPath.row]
        cell.sizeLabel.text = sizeList[indexPath.row]
        cell.priceLabel.text = priceList[indexPath.row]
        
        return cell
    }
    
    
    
    //無訂單時
//    func noOrderList() {
//        if numberOfDrinksLabel.text == "0" {
//            self.alert(title: "目前沒有訂單！", message: "")
//        }
//    }
    
    
    // 刪除
    override func setEditing(_ editing: Bool, animated: Bool) {
        self.orderListTableView.setEditing(editing, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //刪除資料庫內的資料
            let id = self.documentId[indexPath.row]
            self.db.collection("orderList").document(id).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }else{
                    print("Document successfully removed!")
                    
                    DispatchQueue.main.async {
                        self.numberOfDrinksLabel.text = String(self.nameList.count)
                        self.totalPrice.text = String(self.priceToInt())
                        
                        if self.numberOfDrinksLabel.text == "0" {
                            self.alert(title: "目前沒有訂單！", message: "")
                        }
                    }
                }
            }
            
            //刪除List內資料
            self.documentId.remove(at: indexPath.row)
            self.nameList.remove(at: indexPath.row)
            self.drinkList.remove(at: indexPath.row)
            self.enDrinkList.remove(at: indexPath.row)
            self.iceList.remove(at: indexPath.row)
            self.sizeList.remove(at: indexPath.row)
            self.sugarList.remove(at: indexPath.row)
            self.priceList.remove(at: indexPath.row)
            self.newPriceList.removeAll()
            self.orderListTableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
 
    
    /*
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doDelet = UIContextualAction(style: .destructive, title: "刪除") { [self] (action, view, completion) in
            let id = self.documentId[indexPath.row]
            self.db.collection("orderList").document(id).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }else{
                    print("Document successfully removed!")
                    
                    DispatchQueue.main.async {
                        self.numberOfDrinksLabel.text = String(self.nameList.count)
                        self.totalPrice.text = String(self.priceToInt())
                        
                        if self.numberOfDrinksLabel.text == "0" {
                            self.alert(title: "目前沒有訂單！", message: "")
                        }
                    }
                }
            }
            //刪除List內資料
            self.documentId.remove(at: indexPath.row)
            self.nameList.remove(at: indexPath.row)
            self.drinkList.remove(at: indexPath.row)
            self.enDrinkList.remove(at: indexPath.row)
            self.iceList.remove(at: indexPath.row)
            self.sizeList.remove(at: indexPath.row)
            self.sugarList.remove(at: indexPath.row)
            self.priceList.remove(at: indexPath.row)
            self.newPriceList.removeAll()
            self.orderListTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let doEdit = UIContextualAction(style: .normal, title: "修改") { (action, view, completion) in
            self.performSegue(withIdentifier: "editDrinks", sender: indexPath.row)
        }
        doEdit.backgroundColor = .cyan
        var swipeAction = UISwipeActionsConfiguration()
        swipeAction = UISwipeActionsConfiguration(actions: [doDelet, doEdit])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
 */
    
    
    
    
    
    func priceToInt() -> Int {
        if priceList.count > 0 {
            for i in self.priceList {
                let newPrice = Int(i) ?? 0
                newPriceList.append(newPrice)
                //priceList.removeLast()
            }
        }
        var totalPrice = 0
        for x in newPriceList {
            totalPrice += x
        }
        return totalPrice
    }

    
    func readData() {
        db.collection("orderList").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    self.documentId.append(document.documentID)
                    self.nameList.append(document.data()["orderName"] as! String)
                    self.drinkList.append(document.data()["drinkName"] as! String)
                    self.enDrinkList.append(document.data()["enDrinkName"] as! String)
                    self.sizeList.append(document.data()["size"] as! String)
                    self.iceList.append(document.data()["ice"] as! String)
                    self.sugarList.append(document.data()["sugar"] as! String)
                    self.priceList.append(document.data()["price"] as! String)
                }
            }
            DispatchQueue.main.async {
                self.orderListTableView.reloadData()
                self.numberOfDrinksLabel.text = String(self.nameList.count)
                self.totalPrice.text = String(self.priceToInt())
                
                if self.numberOfDrinksLabel.text == "0" {
                    self.alert(title: "目前沒有訂單！", message: "")
                }
            }
        }
    }
    
    
    


}
