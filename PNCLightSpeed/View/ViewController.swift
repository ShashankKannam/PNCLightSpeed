//
//  ViewController.swift
//  PNCLightSpeed
//
//  Created by Shashank Kannam on 4/19/18.
//  Copyright © 2018 pnc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isInitialLoad: Bool = true
    
    var archiveIndex = 0
    
    @IBAction func refresh(_ sender: Any) {
        
        listTableview.isHidden = false
        ActivitySpinner.hide()
        downloadData()
    }
    
    @IBOutlet weak var listTableview: UITableView!
    
    var serviceNowRequests: [ServiceNowRequest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTableViewUI()
        downloadData()
        isInitialLoad = false
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isInitialLoad {
            listTableview.isHidden = false
            ActivitySpinner.hide()
            downloadData()
        }
    }
    
    fileprivate func downloadData() {
        
        self.serviceNowRequests.removeAll()
        
        listTableview.isHidden = true
        ActivitySpinner.show("Loading", disableUI: true)
        BaseService.sharedInstance.getRequestsList(completion: { (requests, error)  in
            
            //            if error == nil {
            //                ActivitySpinner.hide()
            //                let controller = UIAlertController(title: "Error", message: "Can't retrieve data", preferredStyle: .alert)
            //                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            //                controller.addAction(action)
            //                self.navigationController?.present(controller, animated: true, completion: nil)
            //                self.serviceNowRequests = requests ??BaseService.getMockData()
            //                self.listTableview.isHidden = false
            //                self.listTableview.reloadData()
            //                return
            //            }
            
            self.serviceNowRequests = requests ?? []
            
            // Archive
            let archive = ServiceNowRequest()
            self.serviceNowRequests.append(archive)
            self.archiveIndex = self.serviceNowRequests.indices.last ?? 0
            
            ActivitySpinner.hide()
            self.listTableview.isHidden = false
            self.listTableview.reloadData()
        })
    }
    
    fileprivate func setupTableViewUI() {
        listTableview.delegate = self
        listTableview.dataSource = self
        listTableview.rowHeight = UITableViewAutomaticDimension
        let nib = UINib.init(nibName: RequestTableViewCell.nibID, bundle: nil)
        self.listTableview.register(nib, forCellReuseIdentifier: RequestTableViewCell.reuseID)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceNowRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.reuseID, for: indexPath) as? RequestTableViewCell else { return UITableViewCell() }
        
        //if indexPath.row == archiveIndex {
            cell.isArchive = indexPath.row == archiveIndex
        //}
        
        cell.updatedata(request: serviceNowRequests[indexPath.row])
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRequest = serviceNowRequests[indexPath.row]
        
        if indexPath.row == archiveIndex {
            var request = selectedRequest
            request.changeNumber = "IRR - 012165"
            request.requestedPersonName = "Paul Smith"
            request.createdDate = "2018-12-13"
            request.description = "Secondary Impact certification instance. To be resolved by Clarity Project PRJ31405"
            SelectedRequestCache.shared.setRequest(request: request)
            self.performSegue(withIdentifier: "detail", sender: request)
            return
        }
        
        listTableview.isHidden = true
        ActivitySpinner.show("Loading", disableUI: true)
        BaseService.sharedInstance.getChangeRequest(request: selectedRequest) { (request, error) in
            if let request = request {
                self.listTableview.isHidden = false
                ActivitySpinner.hide()
                SelectedRequestCache.shared.setRequest(request: request)
                self.performSegue(withIdentifier: "detail", sender: request)
            }
        }
    }
    
}

