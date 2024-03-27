//
//  Credential.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/27.
//

import Foundation

public class Credential  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    public func array() {
        tool?.tool?.bluetoothService?.V3getCredientialArray()
    }
    
    public func data(model: SearchCredentialRequestModel) {
        tool?.tool?.bluetoothService?.V3searchCredential(model: model)
    }
    
    public func createorEdit(model: CredentialRequestModel) {
        tool?.tool?.bluetoothService?.V3credentialAction(model: model)
    }

    public func delete(position: Int) {
        tool?.tool?.bluetoothService?.V3delCredential(position: position)
    }
    


}
