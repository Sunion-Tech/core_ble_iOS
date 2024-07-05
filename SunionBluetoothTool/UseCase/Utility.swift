//
//  Utility.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class Utility  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    
    public func version(type: RFMCURequestModel.versionType) {
        tool?.tool?.bluetoothService?.V3getVersion(type: type)
    }
    
    public func factoryResetDevice(adminCode: String) {
   
        tool?.tool?.bluetoothService?.V3factoryReset(adminCode: adminCode)
    }
    
    public func factoryResetPlug() {
        tool?.tool?.bluetoothService?.V3plugFactoryReset()
    }
    
    public func isMatter() {
        tool?.tool?.bluetoothService?.V3isMatter()
    }

}
