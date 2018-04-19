//
//  ViewController.swift
//  PNCLightSpeed
//
//  Created by Shashank Kannam on 4/19/18.
//  Copyright © 2018 pnc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var listTableview: UITableView!
    
    var serviceNowRequests: [ServiceNowRequest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTableViewUI()
        BaseService.sharedInstance.getRequestsList()
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.reuseID, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRequest = serviceNowRequests[indexPath.row]
    }
    
}

