//
//  Plug.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation


public class Plug  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    
    public func status() {
        tool?.tool?.bluetoothService?.V3PlugStatus()
    }
    
    public func set(mode: CommandService.plugMode) {
        tool?.tool?.bluetoothService?.V3PlugtogglePowerState(mode: mode)
    }
    


}
