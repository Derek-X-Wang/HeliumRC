//
//  WifiViewController.swift
//  HeliumRC
//
//  Created by Xinzhe Wang on 3/11/17.
//  Copyright © 2017 IntBridge. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSocket

class WifiViewController: UIViewController {

    @IBOutlet weak var ssidInput: UITextField!
    @IBOutlet weak var psdInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WifiViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func setExtendedNetwork(_ sender: Any) {
        let parameters: Parameters = [
            "action": 2,
            "id": "base",
            "option": 0,
            "essid": ssidInput.text ?? "ssid",
            "epsd": psdInput.text ?? "psd"
        ]
        fireRequest(parameters)
        toast("configuring extended nerwork...")
    }
    
    @IBAction func enableWiFi(_ sender: Any) {
        let parameters: Parameters = [
            "action": 2,
            "id": "base",
            "option": 1,
            "isOn": true
        ]
        fireRequest(parameters)
        toast("turning on wifi...")
    }
    
    @IBAction func disableWiFi(_ sender: Any) {
        let parameters: Parameters = [
            "action": 2,
            "id": "base",
            "option": 1,
            "isOn": false
        ]
        fireRequest(parameters)
        toast("turning off wifi...")
    }
    
    @IBAction func connectLocalWiFi(_ sender: Any) {
        let client = TCPClient(address: setupServerAddress, port: Int32(setupServerPort))
        switch client.connect(timeout: 10) {
        case .success:
            print("Connected")
            let ssid = ssidInput.text
            let psd = psdInput.text
            let wifiData = "wifi:connect:" + ssid! + ":" + psd!
            print("Local wifi is "+wifiData)
            switch client.send(string: wifiData ) {
            case .success:
                print("Successfully sent")
                client.close();
            case .failure(let error):
                print(error)
                client.close();
            }
        case .failure(let error):
            print(error)
        }
        toast("connecting local wifi...")
    }

    @IBAction func startMqttClient(_ sender: Any) {
        let client = TCPClient(address: setupServerAddress, port: Int32(setupServerPort))
        switch client.connect(timeout: 10) {
        case .success:
            print("Connected")
            let cmd = "mqtt:connect"
            print("Mqtt is "+cmd)
            switch client.send(string: cmd ) {
            case .success:
                print("Successfully sent")
                client.close();
            case .failure(let error):
                print(error)
                client.close();
            }
        case .failure(let error):
            print(error)
        }
        toast("Starting mqtt client...")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
