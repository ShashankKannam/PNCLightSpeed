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
        cell.updatedata(request: serviceNowRequests[indexPath.row])
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRequest = serviceNowRequests[indexPath.row]
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
    
    //    func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    //        if segue.identifier == "detail" {
    //            if let request = sender as? ServiceNowRequest {
    //                if let vc = segue.destination as? DetailViewController {
    //                    vc.request = request
    //                }
    //            }
    //        }
    //    }
}

