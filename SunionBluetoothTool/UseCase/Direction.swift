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
    
    

    
    public func checkDoorDirection() {
        tool?.tool?.bluetoothService?.V3checkDoorDirection()
    }



}
