//
//  ViewController.swift
//  ordertracking
//
//  Created by Lincoln Nguyen on 4/8/21.
//

import UIKit
import Foundation



class TrackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var trackInfo = [[String:Any]]()
    var trackingNum = "";
    var carrier = "";
    
    func setTrackingNumAndCarrier(_ trackNum: String?, _ carrier: String?) {
        self.trackingNum = trackNum!
        self.carrier = carrier!
    }
    
    func sendRequest(completion: @escaping ([[String:Any]])->()) {
        var returnData = [[String:Any]]()
        let headers = [
            "content-type": "application/json",
            "x-rapidapi-key": "c6e12970f5msh258f9543aba75efp155d01jsn8923c7e612e6",
            "x-rapidapi-host": "order-tracking.p.rapidapi.com"
        ]
        let parameters = [
            "tracking_number": trackingNum,
            "carrier_code": carrier
        ] as [String : Any]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: "https://order-tracking.p.rapidapi.com/trackings/realtime")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            let session = URLSession.shared
            session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                if (error != nil) {
                    print(error)
                } else if let data = data {
                    let httpResponse = response as? HTTPURLResponse
                    // print(httpResponse)
                    // let trackingData = String(decoding: data!, as: UTF8.self)
                    // print(trackingData)
                    // if (trackingData != nil) {
                    //     returnValue = trackingData
                    // }
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    // print(dataDictionary)
                    let packageInfo = dataDictionary["data"] as! [String : Any]
                    // print(packageInfo)
                    if packageInfo["items"] == nil {
                        return completion([])
                    }
                    let items = packageInfo["items"] as! [[String:Any]]
                    // print(items)
                    let lastEvent = items[0]["lastEvent"] as! String
                    // print(lastEvent)
                    let lastUpdateTime = items[0]["lastUpdateTime"] as! String
                    // print(lastUpdateTime)
                    let originInfo = items[0]["origin_info"] as! [String:Any]
                    // print(originInfo)
                    let trackInfo = originInfo["trackinfo"] as! [[String:Any]]
                        
                    // print(trackInfo)
                    returnData = trackInfo
                    // returnData["lastEvent"] = lastEvent
                    // returnData["lastUpdateTime"] = lastUpdateTime
                    // print(returnData)
                    return completion(returnData)
                }
            }).resume()
        } catch {
            print(error)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.title = "Tracking Number: \(trackingNum)"
        self.title = "Loading..."
        // DispatchQueue.main.async {
        //     print(returnData)
        // }
        // print(getTrackingData())
        // print(self.trackingData)
        // label.text = self.trackingData["lastEvent"] as? String
        
        
        // let trackingData = getTrackingData()
        // if trackingData != nil{
        //     label.text = trackingData
        // }
        sendRequest() { data in
            DispatchQueue.main.async {
                print(data)
                if (data.count <= 0) {
                    self.title = "No package found."
                    return
                }
                self.trackInfo = data;
                self.tableView.reloadData()
                self.title = "Tracking Number: \(self.trackingNum)"
            }
            // if (self.trackInfo.count <= 0) {
            //     self.title = "No package found."
            // }
        }
        tableView.dataSource = self
        tableView.delegate = self
        let newButton = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TrackViewController.close(sender:)))
        self.navigationItem.rightBarButtonItem = newButton
    }
    
    @objc func close(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageCell") as! PackageCell
        let locations = trackInfo[indexPath.row]
        let statusDescription = locations["StatusDescription"] as! String
        let date = locations["Date"] as! String
        let details = locations["Details"] as! String
        let checkpointStatus = locations["checkpoint_status"] as! String
        if !statusDescription.isEmpty {
            cell.statusDescription.text = statusDescription
        }
        if !date.isEmpty {
            cell.date.text = date
        }
        if !details.isEmpty {
            cell.details.text = details
        }
        if !checkpointStatus.isEmpty {
            cell.checkpointStatus.text = checkpointStatus
        }
        cell.orderNum.text = String(trackInfo.count - indexPath.row)
        return cell
    }
}
