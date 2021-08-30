//
//  MenuViewController.swift
//  OrderDrinks
//
//  Created by student on 2021/7/2.
//

import UIKit
import Firebase
import FirebaseFirestore



struct DrinkData {
    var imageName: String?
    var drinkName: String?
    var enName: String?
    var content: String?
    var price: String?
    var priceL: String?
}

struct newDrinkData {
    var imageName: String?
    var drinkName: String?
    var enName: String?
    var content: String?
    var price: String?
    var priceL: String?
    var documentID: String?
}


class MenuTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var imageNameLabel: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var enNameLabel: UILabel!
    @IBOutlet weak var drinkNameLabel: UILabel!
    
    
    func update(with cellData: DrinkData) {
        imageNameLabel.image = UIImage(named: cellData.imageName!)
        contentLabel.text = cellData.content
        priceLabel.text = cellData.price
        enNameLabel.text = cellData.enName
        drinkNameLabel.text = cellData.drinkName
    }
    
    
    
    func updates(with cellData: newDrinkData) {
        imageNameLabel.image = UIImage(named: cellData.imageName!)
        contentLabel.text = cellData.content
        priceLabel.text = cellData.price
        enNameLabel.text = cellData.enName
        drinkNameLabel.text = cellData.drinkName
    }

}


class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var db: Firestore!
    var bannerImageView: UIImageView!
    var cachedImageViewSize: CGRect!
    @IBOutlet weak var menuTableView: UITableView!
    
    let cellContents = [ DrinkData(imageName: "drink01", drinkName: "杏仁凍冬片", enName: "Almond Frozen Winter Tablets", content: "甘甜的冬片加入滑順的杏仁凍。", price: "40", priceL: "45"), DrinkData(imageName: "drink02", drinkName: "台茶18號紅玉", enName: "Taiwan Tea NO.18 Ruby", content: "帶有天然肉桂香與薄荷香。", price: "35", priceL: "40"), DrinkData(imageName: "drink03", drinkName: "鳳梨水果茶", enName: "Pineapple Fruit Tea", content: "百香果搭配鳳梨蜜和鳳梨果粒。", price: "50", priceL: "60"), DrinkData(imageName: "drink04", drinkName: "名間鄉冬片仔", enName: "Mingjian Township Tea", content: "暖冬採收的冬片仔茶香清揚。", price: "25", priceL: "30"), DrinkData(imageName: "drink05", drinkName: "珍珠鮮奶茶", enName: "Pearl Milk Tea", content: "香醇的阿薩姆紅茶搭配義美鮮奶。", price: "45", priceL: "60"), DrinkData(imageName: "drink06", drinkName: "桑椹鮮奶", enName: "Art Director", content: "鮮奶加入有大顆果粒的桑椹汁。", price: "50", priceL: "60")]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setImageBanner()
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        db = Firestore.firestore()
       
    }
    
    // MARK: Banner
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = -scrollView.contentOffset.y
        if y > 0 {
            self.bannerImageView.frame = CGRect(x: 0, y: scrollView.contentOffset.y+90, width: self.cachedImageViewSize.size.width + y, height: self.cachedImageViewSize.size.height + y - 130)
            self.bannerImageView.center = CGPoint(x: self.view.center.x, y: self.bannerImageView.center.y)
        }
    }
    
    
    func setImageBanner() {
        self.bannerImageView = UIImageView(image: UIImage(named: "imageBanner"))
        bannerImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 250)
        self.bannerImageView.contentMode = .scaleAspectFill
        self.cachedImageViewSize = bannerImageView.frame
        self.menuTableView.addSubview(self.bannerImageView)
        self.bannerImageView.center = CGPoint(x: self.view.center.x, y: self.bannerImageView.center.y)
        self.menuTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 240))
    }
    
    
    // 設定Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    // MARK: TableViewDataSourceDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menucell", for: indexPath) as! MenuTableViewCell
        let cellData = cellContents[indexPath.row]
        cell.update(with: cellData)
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            if let orderTVC = segue.destination as? OrderTableViewController,
               let indexPath = self.menuTableView.indexPathForSelectedRow {
                orderTVC.cellData = self.cellContents[indexPath.row]
            }
            
//            if let controller = segue.destination as? OrderViewController,
//               let _ = menuTableView.indexPathForSelectedRow?.section,
//               let row = menuTableView.indexPathForSelectedRow?.row {
//                controller.cellData = cellContents[row]
//            }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.menuTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    //        db.collection("drinks").getDocuments { (querySnapshot, error) in
    //            if let error = error {
    //                print("append error \(error)")
    //            }
    //            guard let snapshot = querySnapshot else {return}
    //            var data = newDrinkData()
    //            for document in snapshot.documents {
    //
    //                data.content = document.data()["content"] as? String
    //                data.drinkName = document.data()["drinkName"] as? String
    //                data.enName = document.data()["enName"] as? String
    //                data.imageName = document.data()["imageName"] as? String
    //                data.price = document.data()["price"] as? String
    //                data.priceL = document.data()["priceL"] as? String
    //                data.documentID = document.documentID
    //                //print(data)
    //                self.sss.append(data)
    //                //print(self.sss)
    //            }
    //
    //        }

}
