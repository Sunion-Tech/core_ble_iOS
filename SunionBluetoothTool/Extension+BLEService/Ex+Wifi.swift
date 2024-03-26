//
//  Ex+Wifi.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

extension BluetoothService {
    
    func V3wifiList() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3Wifi(nil)
        let command =  CommandService.shared.createAction(with: .getWifiList, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3setSSID(SSIDName: String, password: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3Wifi(nil)
        wifiPassword = password
        let command =  CommandService.shared.createAction(with: .setSSID(SSIDName), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3setWifiPassword() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3Wifi(nil)
        let command =  CommandService.shared.createAction(with: .setPassword(wifiPassword), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3connectWifi() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3Wifi(nil)
        let command =  CommandService.shared.createAction(with: .setConnection, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3autoUnlockForWiFi(identity: String ) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3Wifi(nil)
        let command =  CommandService.shared.createAction(with: .F3(identity), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3waitForButtonThenAutoUnlockWiFi(Identity: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3Wifi(nil)
        let command =  CommandService.shared.createAction(with: .F4(Identity), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    
}
