//
//  AdminCode.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class AdminCode  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    public func set(value: String) {
        tool?.tool?.bluetoothService?.V3setAdminCode(Code: value)
    }
    
    public func edit(old: String, new: String) {
        tool?.tool?.bluetoothService?.V3editAdminCode(oldCode: old, newCode: new)
    }
    
    public func exists() {
        tool?.tool?.bluetoothService?.V3hasAdminCode()
    }


}
