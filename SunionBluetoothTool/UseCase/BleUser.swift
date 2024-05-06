//
//  Token.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation


public class BleUser  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    
    public func array() {
        tool?.tool?.bluetoothService?.V3bleUserArray()
    }
    
    public func data(position: Int) {
        tool?.tool?.bluetoothService?.V3getbleUser(position: position)
    }
    
    public func create(model: addBleUserModel) {
        tool?.tool?.bluetoothService?.V3createbleUser(model: model)
    }
    
    public func edit(model: EditBleUserModel) {
        tool?.tool?.bluetoothService?.V3editbleUser(model: model)
    }
    
    public func delete(model: BleUserModel) {
        tool?.tool?.bluetoothService?.V3delbleUser(model: model)
    }
    
    public func qrCode(barcodeKey: String, tokenIndex: Int, aes1Key: Data, macAddress: String?, uuid: String?, userName: String, modelName: String, deviceName: String) {
        tool?.tool?.bluetoothService?.V3getbleUserQrCode(barcodeKey: barcodeKey, tokenIndex: tokenIndex, aes1Key: aes1Key, macAddress: macAddress, uuid: uuid, userName: userName, modelName: modelName, deviceName: deviceName)
    }

}
