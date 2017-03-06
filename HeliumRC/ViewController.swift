//
//  ViewController.swift
//  HeliumRC
//
//  Created by Xinzhe Wang on 1/2/17.
//  Copyright © 2017 IntBridge. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMessages
import SwiftSocket

class ViewController: UIViewController {

    @IBOutlet weak var led1Switch: UISwitch!
    @IBOutlet weak var led2Switch: UISwitch!
    @IBOutlet weak var led3Switch: UISwitch!
    @IBOutlet weak var led4Switch: UISwitch!
    @IBOutlet weak var led5Switch: UISwitch!
    
    @IBOutlet weak var ssidInput: UITextField!
    @IBOutlet weak var psdInput: UITextField!
    
    let setupServerAddress = "192.168.10.1"
    let setupServerPort = 8002
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
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
    
    func toast(_ msg: String) {
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        
        let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
        warning.configureContent(title: "Sent", body: msg, iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
    }

    @IBAction func toggleLed1(_ sender: UISwitch) {
        controlLeds(1, sender.isOn)
    }
    @IBAction func toggleLed2(_ sender: UISwitch) {
        controlLeds(2, sender.isOn)
    }
    @IBAction func toggleLed3(_ sender: UISwitch) {
        controlLeds(3, sender.isOn)
    }
    @IBAction func toggleLed4(_ sender: UISwitch) {
        controlLeds(4, sender.isOn)
    }
    @IBAction func toggleLed5(_ sender: UISwitch) {
        controlLeds(5, sender.isOn)
    }
    
    func controlLeds(_ id:Int, _ on:Bool) {
        let parameters: Parameters = [
            "code": 1,
            "id": "base",
            "isOn": on,
            "ledId": id
        ]
        let data = Alamofire.request("https://projecthelium-cloud.herokuapp.com/api/rc", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        print("send 1 " + data.description)
    
    }
    

    @IBAction func setExtendedNetwork(_ sender: Any) {
        
        let parameters: Parameters = [
            "code": 2,
            "id": "base",
            "wifioption": 0,
            "essid": ssidInput.text ?? "ssid",
            "epsd": psdInput.text ?? "psd"
        ]
        let data = Alamofire.request("https://projecthelium-cloud.herokuapp.com/api/rc", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        print("send 2:0 " + data.description)
        toast("configuring extended nerwork...")
    }
    @IBAction func enableWiFi(_ sender: Any) {
        let parameters: Parameters = [
            "code": 2,
            "id": "base",
            "wifioption": 1,
            "isExtenderOn": true
        ]
        let data = Alamofire.request("https://projecthelium-cloud.herokuapp.com/api/rc", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        print("send 2:1:1 " + data.description)
        toast("turning on wifi...")
    }
    @IBAction func disableWiFi(_ sender: Any) {
        let parameters: Parameters = [
            "code": 2,
            "id": "base",
            "wifioption": 1,
            "isExtenderOn": false
        ]
        let data = Alamofire.request("https://projecthelium-cloud.herokuapp.com/api/rc", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        print("send 2:1:0 " + data.description)
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

}

