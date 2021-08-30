//
//  OrderTableViewController.swift
//  OrderDrinks
//
//  Created by student on 2021/7/3.
//

import UIKit
import Firebase
import FirebaseFirestore


class OrderTableViewController: UITableViewController, UITextFieldDelegate {

    
    var cellData: DrinkData?
    var db: Firestore!
    @IBOutlet var orderTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setCellData(with: cellData!)
        //orderNameTextField.resignFirstResponder()
        // orderNameTextField.delegate = self
        
    }
    
    
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var enNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var orderNameTextField: UITextField!
    @IBOutlet weak var sizeSegment: UISegmentedControl!
    @IBOutlet weak var sugarSegment: UISegmentedControl!
    @IBOutlet weak var iceSegment: UISegmentedControl!
    

    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }
    
    
    func setCellData(with cellData: DrinkData) {
        drinkImage.image = UIImage(named: cellData.imageName!)
        drinkNameLabel.text = cellData.drinkName
        enNameLabel.text = cellData.enName
        contentLabel.text = cellData.content
        priceLabel.text = cellData.price
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
    
    
    @IBAction func cupSize(_ sender: Any) {
        if sizeSegment.selectedSegmentIndex == 1 {
            priceLabel.text = cellData?.priceL
        }else{
            priceLabel.text = cellData?.price
        }
    }
    
    
    @IBAction func sendOrder(_ sender: Any) {
        
        if orderNameTextField.text?.isEmpty == true {
            print("[name] == empty")
            //警告： 沒打名字
            let alertScreen = UIAlertController(title: "名字沒有打喔", message: "幫我打一下吧", preferredStyle: .alert)
            let alertBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertScreen.addAction(alertBtn)
            present(alertScreen, animated: true, completion: nil)
            
            //送資料到Firebase
        }else{
            db.collection("orderList").addDocument(data: [
                "orderName": orderNameTextField.text ?? "",
                "drinkName": drinkNameLabel.text ?? "",
                "enDrinkName": enNameLabel.text ?? "",
                "price": priceLabel.text ?? "",
                "size": sizeSegment.titleForSegment(at: sizeSegment.selectedSegmentIndex) ?? "",
                "sugar": sugarSegment.titleForSegment(at: sugarSegment.selectedSegmentIndex) ?? "",
                "ice": iceSegment.titleForSegment(at: iceSegment.selectedSegmentIndex) ?? "",
            ]) { error in
                if let error = error {
                    print("error \(error)")
                }
            }
            
            self.alert(title: "訂單完成", message: "\(drinkNameLabel.text ?? ""), $\(priceLabel.text ?? "")")
            
        }
    }
    
    
     
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.orderTableView.deselectRow(at: indexPath, animated: true)
       // orderTableView.allowsSelectionDuringEditing = false
    }
    

}


