//
//  ViewController.swift
//  PassingData_ex
//
//  Created by 유상 on 2023/01/12.
//

import UIKit

// ------------ 목적지의 instance를 알고 있어함 ------------
// 1. property (instance)
// 2. segue (unwind segue)
// 3. self instance
// 4. delegate (pattern)
// 5. closure

// ------------ 목적지의 instance의 정보를 몰라도 됨 ------------
// 6. notification (NotificationCenter) broadcast -> 한쪽에서 일방적으로 데이터 전달

// 7. closure -> async await (withCheckedContinuation)
class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var callbackDataLabel: UILabel!
    
    var myAge = 20
    var myName = "cha"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = myName
        
        createObserver()
    }
    
    func createObserver() {
        let notiName = Notification.Name("changeName")
        NotificationCenter.default.addObserver(self, selector: #selector(changeName), name: notiName, object: nil)
    }
    
    @objc func changeName(notification: Notification) {
        if let hasName = notification.userInfo?["name"] as? String {
            callbackDataLabel.text =  hasName
        }
    }

    
    @IBAction func moveToDetail(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
       
        
        self.present(detailVC, animated: true)
        
        detailVC.detailName = myName
        detailVC.detailAge = myAge
        detailVC.updateLabel()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail" {
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.detailName = myName
                detailVC.detailAge = myAge
            }
        }
    }
    
    // unwindSegue -> 되돌아가면서 데이터 전달
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        if let detailVC = segue.source as? DetailViewController{
            self.callbackDataLabel.text = detailVC.detailName
        }
    }
    
    
    @IBAction func selfInstanceMoveToDetail(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.mainVC = self
        
        self.present(detailVC, animated: true)
        
    }
    
    
    @IBAction func delegateMoveToDetail(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.delegate = self
        
        self.present(detailVC, animated: true)
    }
    
    func rightTopName(str: String){
        self.callbackDataLabel.text = str
    }
    
    
    @IBAction func closureMoveToDetail(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
//        detailVC.detailClosure = { str in
//            self.callbackDataLabel.text = str
//        }
        
//        detailVC.detailClosure = rightTopName
        
//        detailVC.closureWithFunc { str in
//            self.callbackDataLabel.text = str
//        }
        Task{
            self.callbackDataLabel.text = await detailVC.closureWithFunc()
        }
        
        self.present(detailVC, animated: true)
    }
    
    
}

extension ViewController: ViewControllerDelegate {
    func rightLabelString(str: String) {
        callbackDataLabel.text = str
    }
}


protocol ViewControllerDelegate: AnyObject {
    func rightLabelString(str: String)
}
