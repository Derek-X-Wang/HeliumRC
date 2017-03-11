//
//  Utils.swift
//  HeliumRC
//
//  Created by Xinzhe Wang on 3/11/17.
//  Copyright © 2017 IntBridge. All rights reserved.
//

import Foundation
import Alamofire
import SwiftMessages

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

func fireRequest(_ parameters: Parameters) {
    let address = (debug == true) ? devHost : "https://projecthelium-cloud.herokuapp.com/api/v1"
    let data = Alamofire.request(address, method: .post, parameters: parameters, encoding: JSONEncoding.default)
    print("send " + data.description)
    
}
