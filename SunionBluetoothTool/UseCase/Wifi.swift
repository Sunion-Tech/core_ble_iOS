//
//  Wifi.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class Wifi  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    
    public func list() {
        tool?.tool?.bluetoothService?.V3wifiList()
    }
    
    
    public func configureWiFi(SSIDName: String, password: String) {
        tool?.tool?.bluetoothService?.V3setSSID(SSIDName: SSIDName, password: password)
    }
    
    public func autoUnlockForWiFi(identity: String) {
        tool?.tool?.bluetoothService?.V3autoUnlockForWiFi(identity: identity)
    }
    
    public func waitForButtonThenAutoUnlockWiFi(identity: String) {
        tool?.tool?.bluetoothService?.V3waitForButtonThenAutoUnlockWiFi(Identity: identity)
    }

}
