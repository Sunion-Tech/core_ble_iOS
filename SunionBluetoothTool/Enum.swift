//
//  Enum.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/12/2.
//

import Foundation

public enum bluetoothState {
    case enable
    case disable
    case connecting
    case connected(String)
    case disconnect(disconnectState)
}

public enum disconnectState {
    case fail
    case discoverServices(String?)
    case discoverCharacteristics
    case deviceRefused
    case illegalToken
    case normal
}

public enum commandState {
    case none
    case deviceStatus(DeviceStatusModel?)
    case config(Bool?)
    case updateName(Bool?)
    case isAdminCode(Bool?)
    case setupAdminCode(Bool?)
    case editAdminCode(Bool?)
    case setupTimeZone(Bool?)
    case DeviceName(String?)
    case editToken(Bool?)
    case deviceSetting(DeviceSetupResultModel?)
    case logCount(Int?)
    case log(LogModel?)
    case getTokenArray([Int]?)
    case getToken(TokenModel?)
    case createToken(AddTokenResult?)
    case delToken(Bool?)
    case getTokenQrCode(String?)
    case getPinCodeArray(PinCodeArrayModel?)
    case getPinCode(PinCodeModelResult?)
    case pinCodeoption(Bool?)
    case delPinCode(Bool?)
    case factoryReset(Bool?)
    case supportType(SupportDeviceTypesResponseModel?)
    case accessArray(AccessArrayResponseModel?)
    case searchAccess(AccessDataResponseModel?)
    case accessAction(AccessResponseModel?)
    case setupAccess(SetupAccessResponseModel?)
    case delAccess(DelAccessResponseModel?)
    case wifiList(SSIDModel?)
    case connectWifi(Bool?)
    case connectMQTT(Bool?)
    case connectClould(Bool?)
    case OTAStatus(OTAResponseModel?)
    case OTAData(OTADataResponseModel?)
   
}
