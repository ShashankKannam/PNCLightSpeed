//
//  BaseService.swift
//  PNCLightSpeed
//
//  Created by Shashank Kannam on 4/19/18.
//  Copyright © 2018 pnc. All rights reserved.
//

import Alamofire
import SwiftyJSON

class BaseService {
    
    static let sharedInstance = BaseService()
    
    let user = "bb8"
    let password = "ilovelamp"
    
    let listEndpoint = "https://pncmelliniumfalcon.service-now.com/api/now/table/sysapproval_approver?sysparm_query=approver%3Djavascript%3AgetMyApprovals()&sysparm_limit=4"
    //"https://pncmelliniumfalcon.service-now.com/api/now/table/sysapproval_approver?sysparm_query=approver%3Djavascript%3AgetMyApprovals()&sysparm_limit=4"
    //"https://pncmelliniumfalcon.service-now.com/api/now/table/sysapproval_approver?sysparm_limit=4&Approver=Bb8"
    //
    
    private var request: DataRequest!
    
    func getHeaders() -> HTTPHeaders {
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials)",
            "X-UserToken": "692544c2dba11b00e00e78dabf9619e0e32f02557453d797b588e3b99e9335e6413ef467",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        return headers
    }
    
    class func  getMockData() -> [ServiceNowRequest] {
        //        let mock1 = ServiceNowRequest(requestedPersonName: "A", id: "1234", status: .pending, createdDate: "10/12/18", description: "qwertqwertyu")
        //        let mock2 = ServiceNowRequest(requestedPersonName: "B", id: "12345", status: .pending, createdDate: "10/13/18", description: "qwertqwertyu 1")
        return []
    }
    
    func changeStatus(request: ServiceNowRequest, status: SNStatusType, comments: String, completion: @escaping (ServiceNowRequest?, Error?) -> ()) {
        let parameters: [String: String] = ["state":"\(status.description)", "comments":"\(comments)"]
        let endpoint = "https://pncmelliniumfalcon.service-now.com/api/now/table/sysapproval_approver/\(request.id ?? "")"
        
        Alamofire.request(endpoint,
                          method: .put,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers:getHeaders())
            .validate().responseJSON { response in
                DispatchQueue.main.async {
                    if let json = response.result.value as? [String: Any] {
                        completion(request, response.error)
                    }
                }
        }
    }
    
    func getChangeRequest(request: ServiceNowRequest, completion: @escaping (ServiceNowRequest?, Error?) -> ()) {
        let endpoint = "https://pncmelliniumfalcon.service-now.com/api/now/table/\(request.sourceTable ?? "")?sysparm_limit=4&sys_id=\(request.documentID ?? "")"
        Alamofire.request(endpoint, headers: getHeaders()).responseJSON { response in
            DispatchQueue.main.async {
                if let json = response.result.value as? [String: Any] {
                    completion(self.getChangeRequestData(request: request, json: json), (nil))
                } else if let error = response.error {
                    completion(nil, (error))
                }
            }
        }
    }
    
    fileprivate func getChangeRequestData(request: ServiceNowRequest , json: [String: Any]) -> ServiceNowRequest {
        var requestD = request
        if let result = json["result"] as? [Any] {
            for data in result {
                if let data1 = data as? [String: Any] {
                    if let number = data1["number"] as? String {
                        requestD.changeNumber = number
                    }
                    if let description = data1["description"] as? String {
                        requestD.description = description
                    }
                }
            }
        }
        return requestD
    }
    
    func getRequestsList(completion: @escaping ([ServiceNowRequest]?, (Error?)) -> ()) {
        
        if request != nil {
            request.delegate.queue.cancelAllOperations()
        }
        
        request = Alamofire.request(listEndpoint, headers: getHeaders()).responseJSON { response in
            DispatchQueue.main.async {
                if let json = response.result.value as? [String: Any] {
                    completion(self.getRequests(json: json), (nil))
                } else if let error = response.error {
                    completion(nil, (error))
                }
            }
        }
    }
    
    fileprivate func getRequests(json: [String: Any]) -> [ServiceNowRequest] {
        var requests: [ServiceNowRequest] = []
        if let result = json["result"] as? [Any] {
            for data in result {
                if let data1 = data as? [String: Any] {
                    var requestdata = ServiceNowRequest()
                    // state
                    if let state = data1["state"] as? String {
                        if state == "requested" {
                            requestdata.status = .pending
                        }
                        if state == "approved" {
                            requestdata.status = .approved
                        }
                        if state == "rejected" {
                            requestdata.status = .declined
                        }
                    }
                    
                    // Source Table
                    if let table = data1["source_table"] as? String {
                        requestdata.sourceTable = table
                    }
                    
                    // name
                    if let createdBy = data1["sys_created_by"] as? String {
                        requestdata.requestedPersonName = createdBy
                    }
                    
                    // Date
                    
                    if let date = data1["sys_created_on"] as? String {
                        requestdata.createdDate = date
                    }
                    
                    if let id = data1["sys_id"] as? String {
                        requestdata.id = id
                    }
                    
                    if let documentID = data1["document_id"] as? [String: Any] {
                        if let value = documentID["value"] as? String {
                            requestdata.documentID = value
                        }
                    }
                    
                   // if requestdata.status == .pending {
                        requests.append(requestdata)
                    //}
                }
            }
            
        }
        return requests
    }
    
}
