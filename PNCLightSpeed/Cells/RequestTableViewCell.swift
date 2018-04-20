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
    
    @IBOutlet weak var serviceTypeLabel: UILabel!
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
//        let attr1 = [NSAttributedStringKey.foregroundColor: UIColor.green,
//                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)
//                     ]
//        let attr2 = [NSAttributedStringKey.foregroundColor: UIColor.black,
//                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)
//        ]
        
        approvalForLabel.text = "Requestor: \(request.requestedPersonName?.capitalized ?? "")"
        dateCreatedLabel.text = "Created on: \(request.createdDate ?? "")"
        serviceTypeLabel.text = request.sourceTable == "change_request" ? "ServiceNow CR" : "ServiceNow REQ"
        
//        let attrDesc1 = NSMutableAttributedString(string: "Status: ", attributes: attr2)
//        let attrDesc2 = NSMutableAttributedString(string: request.status.description, attributes: attr1)
//        attrDesc1.append(attrDesc2)
        statusLabel.text = "Status: \(request.status.description)"
        //statusLabel.attributedText = attrDesc1
    }
    
    class var reuseID: String {
        return "RequestTableViewCell"
    }
    
    class var nibID: String {
        return "RequestTableViewCell"
    }
    
}
