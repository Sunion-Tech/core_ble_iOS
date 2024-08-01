//
//  Ex+Time.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation


extension BluetoothService {
    
    func V3setDeviceTime() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command = CommandService.shared.createAction(with: .D3(Date()), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3setTimeZone(timezone: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        guard let timeZone = TimeZone(identifier: timezone),
              let abbreviation = timeZone.secondsFromGMT().toString.data(using: .utf8) else { return }
        let command = CommandService.shared.createAction(with: .D9(Int32(timeZone.secondsFromGMT()), abbreviation), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3setTimeZoneForWIFIDevice(timezone: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let timezoneValue = timezone.utf8.map { UInt8($0) }
        guard let timeZone = TimeZone(identifier: timezone),
        timezoneValue.count < 40 else { return }
        
        let command = CommandService.shared.createAction(with: .F6(Int32(timeZone.secondsFromGMT()), timezoneValue), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
        
        
    }
    
    func V3getTimeZone() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command = CommandService.shared.createAction(with: .F5, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    
}
