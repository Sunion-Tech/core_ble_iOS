//
//  Ex+User.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/27.
//

import Foundation


extension BluetoothService {
    
    func V3userAble() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        let command =  CommandService.shared.createAction(with:  .N85, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3getUserSupportedCount() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        let command =  CommandService.shared.createAction(with:  .N86, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3getUserArray() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        let command =  CommandService.shared.createAction(with: .N90, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    
    func V3getUserData(position: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        let model = IndexUserCredentialRequestModel(index: position)
        let command =  CommandService.shared.createAction(with: .N91(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3userAction(model: UserCredentialRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        let command =  CommandService.shared.createAction(with: .N92(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3delUserAction(position: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        
        let model = IndexUserCredentialRequestModel(index: position)
        let command =  CommandService.shared.createAction(with: .N93(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
}
