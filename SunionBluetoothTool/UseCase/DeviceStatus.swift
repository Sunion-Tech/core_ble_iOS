//
//  UseCase.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class DeviceStatus  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    public func data() {
        tool?.tool?.bluetoothService?.V3deviceStatus()
    }
    
    public func lockorUnlock(value: CommandService.DeviceMode) {
        tool?.tool?.bluetoothService?.V3lockorUnLock(mode: value)
    }

}
