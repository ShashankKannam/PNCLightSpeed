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
        request = SelectedRequestCache.shared.getRequest()
    }
    
    @IBAction func approveAction(_ sender: Any) {
        changeStatus(status: .approved)
    }
    
    @IBAction func declineAction(_ sender: Any) {
        changeStatus(status: .declined)
    }
    
    func changeStatus(status: SNStatusType) {
        guard let request = request else { return }
        ActivitySpinner.show("Loading", disableUI: true)
        BaseService.sharedInstance.changeStatus(request: request, status: status) { (response, error) in
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
