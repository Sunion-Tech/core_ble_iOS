//
//  Log.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation



public class Log  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    
    public func count() {
        tool?.tool?.bluetoothService?.V3getLogCount()
    }
    
    public func data(position: Int) {
        tool?.tool?.bluetoothService?.V3getLog(position: position)
    }
    


}
