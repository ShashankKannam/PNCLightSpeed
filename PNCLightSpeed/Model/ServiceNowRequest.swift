//
//  ServiceNowRequest.swift
//  PNCLightSpeed
//
//  Created by Shashank Kannam on 4/19/18.
//  Copyright © 2018 pnc. All rights reserved.
//

import Foundation
import SwiftyJSON

class SelectedRequestCache {
    static var shared = SelectedRequestCache()
    
    var request = ServiceNowRequest()
    
    func setRequest(request: ServiceNowRequest) {
        self.request = request
    }
    
    func getRequest() -> ServiceNowRequest {
        return request
    }
}

enum SNStatusType {
    case pending
    case approved
    case declined
    
    var description: String {
        switch self {
        case .approved:
            return "Approved"
        case .pending:
            return "pending"
        case .declined:
            return "Rejected"
        }
    }
}

struct ServiceNowRequest {
    
    var requestedPersonName: String?
    var id: String?
    var status: SNStatusType = .pending
    var createdDate: String?
    var description: String?
    var changeNumber: String?
    
    var documentID: String?
    
    var sourceTable:String?
    
    init() {
       requestedPersonName = ""
        id = ""
        createdDate = ""
        description = ""
        status = .pending
        changeNumber = ""
        sourceTable = ""
        documentID = ""
    }
}
