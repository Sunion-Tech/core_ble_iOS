//
//  Token.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation


public class Token  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    
    public func array() {
        tool?.tool?.bluetoothService?.V3getTokenArray()
    }
    
    public func data(position: Int) {
        tool?.tool?.bluetoothService?.V3getToken(position: position)
    }
    
    public func create(model: AddTokenModel) {
        tool?.tool?.bluetoothService?.V3createToken(model: model)
    }
    
    public func edit(model: EditTokenModel) {
        tool?.tool?.bluetoothService?.V3editToken(model: model)
    }
    
    public func delete(model: TokenModel) {
        tool?.tool?.bluetoothService?.V3delToken(model: model)
    }

}
