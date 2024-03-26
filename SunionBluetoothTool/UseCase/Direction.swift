//
//  Direction.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class Direction  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    
    public func lockorUnlock(value: CommandService.DeviceMode) {
        tool?.tool?.bluetoothService?.V3lockorUnLock(mode: value)
    }
    
    public func checkDoorDirection() {
        tool?.tool?.bluetoothService?.V3checkDoorDirection()
    }



}
