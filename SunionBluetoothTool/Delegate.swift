//
//  Delegate.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/11/24.
//

import Foundation

public protocol SunionBluetoothToolDelegate: AnyObject {
    
    
    // MARK: - Bluetooth
    func BluetoothState(State: bluetoothState)
    func DeviceStatus(value: DeviceStatusModel?)
    func Config(bool: Bool?)
    func AdminCodeExist(bool: Bool?)
    func AdminCode(bool: Bool?)
    func EditAdminCode(bool: Bool?)
    func TimeZone(bool: Bool?)
    func DeviceName(bool: Bool?)
    func DeviceNameData(value: String?)
    func EditToken(bool: Bool?)
    func TokenArray(value: [Int]?)
    func TokenData(value: TokenModel?)
    func TokenOption(value: AddTokenResult?)
    func Token(bool: Bool?)
    func TokenQrCode(value: String?)
    func DeviceConfig(value: DeviceSetupResultModel?)
    func LogCount(value: Int?)
    func LogData(value: LogModel?)
    func PinCodeArray(value: PinCodeArrayModel?)
    func PinCodeData(value: PinCodeModelResult?)
    func PinCode(bool: Bool?)
    func FactoryReset(bool: Bool?)
    func SupportType(value: SupportDeviceTypesResponseModel?)
    func AccessArray(value: AccessArrayResponseModel?)
    func SearchAccess(value: AccessDataResponseModel?)
    func AccessAction(value: AccessResponseModel?)
    func SetupAccess(value: SetupAccessResponseModel?)
    func DelAccess(value: DelAccessResponseModel?)
  
    
    // MARK: - V3
    
    func v3deviceStatus(value: DeviceStatusModelN82?)
    func v3time(value: resTimeUseCase?)
    func v3adminCode(value: resAdminCodeUseCase?)
    func v3Name(value: resNameUseCase?)
    func v3Config(value: resConfigUseCase?)
    func v3utility(value: resUtilityUseCase?)
    func v3BleUser(value: resTokenUseCase?)
    func v3Log(value: resLogUseCase?)
    func v3Wifi(value: resWifiUseCase?)
    func v3Plug(value: plugStatusResponseModel?)
    func v3OTA(value: resOTAUseCase?)
    func v3User(value: resUserUseCase?)
    func v3Credential(value: resCredentialUseCase?)
}


extension SunionBluetoothToolDelegate {
    
    
    //  bluetooth
    public func DeviceStatus(value: DeviceStatusModel?) {}
    public func Config(bool: Bool?) {}
    public func AdminCodeExist(bool: Bool?) {}
    public func AdminCode(bool: Bool?) {}
    public func EditAdminCode(bool: Bool?) {}
    public func TimeZone(bool: Bool?) {}
    public func DeviceName(bool: Bool?) {}
    public func DeviceNameData(value: String?) {}
    public func EditToken(bool: Bool?) {}
    public func TokenArray(value: [Int]?) {}
    public func TokenData(value: TokenModel?) {}
    public func TokenOption(value: AddTokenResult?) {}
    public func Token(bool: Bool?) {}
    public func TokenQrCode(value: String?) {}
    public func DeviceConfig(value: DeviceSetupResultModel?) {}
    public func LogCount(value: Int?) {}
    public func LogData(value: LogModel?) {}
    public func PinCodeArray(value: PinCodeArrayModel?) {}
    public func PinCodeData(value: PinCodeModelResult?) {}
    public func PinCode(bool: Bool?) {}
    public func FactoryReset(bool: Bool?) {}
    public func SupportType(value: SupportDeviceTypesResponseModel?) {}
    public func AccessArray(value: AccessArrayResponseModel?) {}
    public func SearchAccess(value: AccessDataResponseModel?) {}
    public func AccessAction(value: AccessResponseModel?) {}
    public func SetupAccess(value: SetupAccessResponseModel?) {}
    public func DelAccess(value: DelAccessResponseModel?) {}
  
    
    public func v3deviceStatus(value: DeviceStatusModelN82?) {}
    public func v3time(value: resTimeUseCase?) {}
    public func v3adminCode(value: resAdminCodeUseCase?) {}
    public func v3Name(value: resNameUseCase?) {}
    public func v3Config(value: resConfigUseCase?) {}
    public func v3utility(value: resUtilityUseCase?) {}
    public func v3BleUser(value: resTokenUseCase?) {}
    public func v3Log(value: resLogUseCase?) {}
    public func v3Wifi(value: resWifiUseCase?) {}
    public func v3Plug(value: plugStatusResponseModel?) {}
    public func v3OTA(value: resOTAUseCase?) {}
    public func v3User(value: resUserUseCase?) {}
    public func v3Credential(value: resCredentialUseCase?) {}
}
