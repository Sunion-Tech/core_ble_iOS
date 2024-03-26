//
//  Time.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class Time  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    public func syncCurrentTime() {
        tool?.tool?.bluetoothService?.V3setDeviceTime()
    }
    
    public func setTimeZone(value: String) {
        tool?.tool?.bluetoothService?.V3setTimeZone(timezone: value)
    }


}
