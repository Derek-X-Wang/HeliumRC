//
//  ViewController.swift
//  HeliumRC
//
//  Created by Xinzhe Wang on 1/2/17.
//  Copyright © 2017 IntBridge. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var led1Switch: UISwitch!
    @IBOutlet weak var led2Switch: UISwitch!
    @IBOutlet weak var led3Switch: UISwitch!
    @IBOutlet weak var led4Switch: UISwitch!
    @IBOutlet weak var led5Switch: UISwitch!
    
    @IBOutlet weak var ssidInput: UITextField!
    @IBOutlet weak var psdInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        Alamofire.request("https://projecthelium-cloud.herokuapp.com/api/rc", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        print("send");
    }
    

    @IBAction func setExtendedNetwork(_ sender: Any) {
    }
    @IBAction func enableWiFi(_ sender: Any) {
    }
    @IBAction func disableWiFi(_ sender: Any) {
    }
    @IBAction func connectLocalWiFi(_ sender: Any) {
    }

}

