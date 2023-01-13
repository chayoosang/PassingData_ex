//
//  DetailViewController.swift
//  PassingData_ex
//
//  Created by 유상 on 2023/01/12.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var ageLabel: UILabel?
    
    var detailClosure: ((String) -> Void)?
    
    var detailName = ""
    var detailAge = 0
    
    // instance를 받기위한 변수
    var mainVC: ViewController?
    
    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateLabel()
        
    }
    
    
    func updateLabel() {
        nameLabel?.text = detailName
        ageLabel?.text = detailAge.description
    }
    
    
    
    
    @IBAction func backInstance(_ sender: Any) {
        mainVC?.myName = "kim"
        mainVC?.nameLabel.text = mainVC?.myName
        self.dismiss(animated: true)
    }
    
    
    @IBAction func backDelegate(_ sender: Any) {
        delegate?.rightLabelString(str: "yoo sang")
        self.dismiss(animated: true)
    }
    
    @IBAction func backClosure(_ sender: Any) {
//        detailClosure?("ruby")
        self.dismiss(animated: true)
    }
    
    
    
    
    func closureWithFunc(completion: (String) -> Void) {
        completion("closure func")
    }
    
    func closureWithFunc() async -> String{
        await withCheckedContinuation { continuation in
            closureWithFunc { str in
                continuation.resume(returning: str)
            }
        }
    }
    
    
    
    @IBAction func postNotification(_ sender: Any) {
        let notiName = Notification.Name("changeName")
        
        NotificationCenter.default.post(name: notiName, object: nil, userInfo: ["name" : "noti name"])
    }
    
    

}
