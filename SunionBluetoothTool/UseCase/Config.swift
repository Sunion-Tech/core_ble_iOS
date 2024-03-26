//
//  Config.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class Config  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    
    public func data() {
        tool?.tool?.bluetoothService?.V3getConfig()
    }
    
    public func set(model: DeviceSetupModelN81) {
        tool?.tool?.bluetoothService?.V3setConfig(model: model)
    }

}
