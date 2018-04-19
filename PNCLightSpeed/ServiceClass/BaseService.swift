//
//  BaseService.swift
//  PNCLightSpeed
//
//  Created by Shashank Kannam on 4/19/18.
//  Copyright © 2018 pnc. All rights reserved.
//

import Alamofire

class BaseService {
    
    static let sharedInstance = BaseService()
    
    let listEndpoint = "https://pncmelliniumfalcon.service-now.com/api/now/table/sysapproval_approver?sysparm_query=state%3Drequested%5Eapprover.user_nameSTARTSWITHbb8&sysparm_limit=1"
    
    let headers: HTTPHeaders = [
        "X-UserToken": "5a1297fddb6dd700e00e78dabf96198515a023891e81616633949e932db669dae72801c2",
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    func getRequestsList() {
       Alamofire.request(listEndpoint, headers: headers).responseJSON { response in
        
        }
    }
}
