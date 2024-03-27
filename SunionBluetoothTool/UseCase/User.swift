//
//  User.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/27.
//

import Foundation

public class User  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    
    public func able() {
        tool?.tool?.bluetoothService?.V3userAble()
    }
    
    public func supportCount() {
        tool?.tool?.bluetoothService?.V3getUserSupportedCount()
    }
    
    public func array() {
        tool?.tool?.bluetoothService?.V3getUserArray()
    }
    
    public func data(position: Int) {
        tool?.tool?.bluetoothService?.V3getUserData(position: position)
    }
    
    public func createorEdit(model: UserCredentialRequestModel) {
        tool?.tool?.bluetoothService?.V3userAction(model: model)
    }

    public func delete(position: Int) {
        tool?.tool?.bluetoothService?.V3delUserAction(position: position)
    }

}
