//
//  Name.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class Name  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    public func data() {
        tool?.tool?.bluetoothService?.V3getDeviceName()
    }
    
    public func set(value: String) {
        tool?.tool?.bluetoothService?.V3setDeviceName(name: value)
    }



}
