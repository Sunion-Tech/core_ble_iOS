//
//  Ex+Token.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

extension BluetoothService {
    
    func V3bleUserArray() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command =  CommandService.shared.createAction(with: .N8A, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    

    func V3getbleUser(position: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command =  CommandService.shared.createAction(with: .N8B(position), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }

    func V3createbleUser(model: addBleUserModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command =  CommandService.shared.createAction(with: .N8C(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3editbleUser(model: EditBleUserModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command =  CommandService.shared.createAction(with: .N8D(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3delbleUser(model: BleUserModel, ownerPinCode: String? = nil) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        var digit: [UInt8]?
        if let ownerPinCode = ownerPinCode {
            digit = Array(ownerPinCode.utf8)
        }
        let command =  CommandService.shared.createAction(with: .N8E(model, digit), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3getbleUserQrCode(barcodeKey: String, tokenIndex: Int, aes1Key: Data, macAddress: String?, uuid: String?, userName: String, modelName: String, deviceName: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        qrcodeAes1Key = aes1Key.toHexString()
        qrcodeUserName = userName
        qrcodeModelName = modelName
        qrcodeDeviceName = deviceName
        qrcodeMacAddress = macAddress ?? ""
        qrcodeuuid = uuid ?? ""
        self.barcodeKey = barcodeKey
        let command =  CommandService.shared.createAction(with: .N8B(tokenIndex), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
}
