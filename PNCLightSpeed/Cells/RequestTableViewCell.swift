//
//  RequestTableViewCell.swift
//  PNCLightSpeed
//
//  Created by Shashank Kannam on 4/19/18.
//  Copyright © 2018 pnc. All rights reserved.
//

import UIKit

@IBDesignable
class CustomUIButton: UIButton {
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var approvalForLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updatedata(request: ServiceNowRequest) {
        approvalForLabel.text = "Approval For: \(request.requestedPersonName?.capitalized ?? "")"
        statusLabel.text = "Status: \(request.status.description)"
        dateCreatedLabel.text = "Created on: \(request.createdDate ?? "")"
    }
    
    class var reuseID: String {
        return "RequestTableViewCell"
    }
    
    class var nibID: String {
        return "RequestTableViewCell"
    }
    
}
