//
//  DetailViewController.swift
//  PNCLightSpeed
//
//  Created by Shashank Kannam on 4/19/18.
//  Copyright © 2018 pnc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var request: ServiceNowRequest? {
        didSet {
            updateData()
        }
    }
    
    @IBOutlet weak var approval1: UILabel!
    
    @IBOutlet weak var requestor: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    fileprivate func updateData() {
        approval1.text = request?.changeNumber ?? ""
        requestor.text = "Requestor: \(request?.requestedPersonName ?? "")"
        statusLabel.text = "Status: \(request?.status.description ?? "")"
        dateLabel.text = "Date: \(request?.createdDate ?? "")"
        descriptionLabel.text = "Description: \(request?.description ?? "")"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Request Details"
        request = SelectedRequestCache.shared.getRequest()
    }
    
    @IBAction func approveAction(_ sender: Any) {
        changeStatus(status: .approved)
    }
    
    @IBAction func declineAction(_ sender: Any) {
        changeStatus(status: .declined)
    }
    
    func changeStatus(status: SNStatusType) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Submit", message: "Are you sure you want to modify the request", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            //
            textField.placeholder = "Please Enter comments, if any"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            //alert?.dismiss(animated: true, completion: {
                self.makeService(status: status, comments: textField?.text ?? "")
            //})
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {
                //self.makeService(status: status)
            })
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
       
    }
    
    func makeService(status: SNStatusType, comments: String) {
        guard let request = request else { return }
        ActivitySpinner.show("Loading", disableUI: true)
        BaseService.sharedInstance.changeStatus(request: request, status: status, comments: comments) { (response, error) in
            ActivitySpinner.hide()
            if response != nil {
                let controller = UIAlertController(title: "Successfully Updated", message: "\(request.changeNumber ?? "Request") is successfully \(status.description) ", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                })
                controller.addAction(action)
                self.navigationController?.present(controller, animated: true, completion: nil)
            }
        }
    }
    
}
