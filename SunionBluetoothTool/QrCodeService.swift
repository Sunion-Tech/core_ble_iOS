//
//  QrCodeService.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/12/9.
//

import Foundation
import SwiftyJSON

class QrCodeService: NSObject {
    
    private var data: JSON?
    
    init(data: JSON) {
        self.data = data
    }
    var token: String {
        return data!["T"].stringValue
    }
    
    var aes1: String {
        return data!["K"].stringValue
    }
    
    var mac: String {
        return data!["A"].stringValue
    }
    
    var modelName: String {
        return data?["M"].stringValue ?? ""
    }
    
    var serialNumber: String {
        return data?["S"].stringValue ?? ""
    }
    
    var shareFrom: String {
        return data?["F"].stringValue ?? ""
    }
    
    var displayName: String {
        return data?["L"].stringValue ?? ""
    }
    

    
}
