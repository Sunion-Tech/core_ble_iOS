//
//  Delegate.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/11/24.
//

import Foundation

public protocol SunionBluetoothToolDelegate: AnyObject {
    func remoteBluetoothState(State: bluetoothState)
    func remoteDeviceStatus(value: DeviceStatusModel?)
    func remoteConfig(bool: Bool?)
    func remoteAdminCodeExist(bool: Bool?)
    func remoteAdminCode(bool: Bool?)
    func remoteEditAdminCode(bool: Bool?)
    func remoteTimeZone(bool: Bool?)
    func remoteDeviceName(bool: Bool?)
    func remoteDeviceNameData(value: String?)
    func remoteEditToken(bool: Bool?)
    func remoteTokenArray(value: [Int]?)
    func remoteTokenData(value: TokenModel?)
    func remoteTokenOption(value: AddTokenResult?)
    func remoteToken(bool: Bool?)
    func remoteTokenQrCode(value: String?)
    func remoteDeviceConfig(value: DeviceSetupResultModel?)
    func remoteLogCount(value: Int?)
    func remoteLogData(value: LogModel?)
    func remotePinCodeArray(value: PinCodeArrayModel?)
    func remotePinCodeData(value: PinCodeModelResult?)
    func remotePinCode(bool: Bool?)
    func remoteFactoryReset(bool: Bool?)
    func remoteSupportType(value: SupportDeviceTypesResponseModel?)
    func remoteAccessArray(value: AccessArrayResponseModel?)
    func remoteSearchAccess(value: AccessDataResponseModel?)
    func remoteAccessAction(value: AccessResponseModel?)
    func remoteSetupAccess(value: SetupAccessResponseModel?)
    func remoteDelAccess(value: DelAccessResponseModel?)
    func remotewifiList(value: SSIDModel?)
    func remoteconnectWifi(bool: Bool?)
    func remoteconnectMQTT(bool: Bool?)
    func remoteconnectClould(bool: Bool?)
    func remoteOTAStatus(value: OTAResponseModel?)
    func remoteOTAData(value: OTADataResponseModel?)
    func remoteResponse(value: String?)
    
    
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
    func wifiList(value: SSIDModel?)
    func connectWifi(bool: Bool?)
    func connectMQTT(bool: Bool?)
    func connectClould(bool: Bool?)
    func debug(value: String)
    func OTAStatus(value: OTAResponseModel?)
    func OTAData(value: OTADataResponseModel?)

   
}

extension SunionBluetoothToolDelegate {
    
    public func remoteDeviceStatus(value: DeviceStatusModel?) {}
    public func remoteConfig(bool: Bool?) {}
    public func remoteAdminCodeExist(bool: Bool?) {}
    public func remoteAdminCode(bool: Bool?) {}
    public func remoteEditAdminCode(bool: Bool?) {}
    public func remoteTimeZone(bool: Bool?) {}
    public func remoteDeviceName(bool: Bool?) {}
    public func remoteDeviceNameData(value: String?) {}
    public func remoteEditToken(bool: Bool?) {}
    public func remoteTokenArray(value: [Int]?) {}
    public func remoteTokenData(value: TokenModel?) {}
    public func remoteTokenOption(value: AddTokenResult?) {}
    public func remoteToken(bool: Bool?) {}
    public func remoteTokenQrCode(value: String?) {}
    public func remoteDeviceConfig(value: DeviceSetupResultModel?) {}
    public func remoteLogCount(value: Int?) {}
    public func remoteLogData(value: LogModel?) {}
    public func remotePinCodeArray(value: PinCodeArrayModel?) {}
    public func remotePinCodeData(value: PinCodeModelResult?) {}
    public func remotePinCode(bool: Bool?) {}
    public func remoteFactoryReset(bool: Bool?) {}
    public func remoteSupportType(value: SupportDeviceTypesResponseModel?) {}
    public func remoteAccessArray(value: AccessArrayResponseModel?) {}
    public func remoteSearchAccess(value: AccessDataResponseModel?) {}
    public func remoteAccessAction(value: AccessResponseModel?) {}
    public func remoteSetupAccess(value: SetupAccessResponseModel?) {}
    public func remoteDelAccess(value: DelAccessResponseModel?) {}
    public func remotewifiList(value: SSIDModel?) {}
    public func remoteconnectWifi(bool: Bool?) {}
    public func remoteconnectMQTT(bool: Bool?) {}
    public func remoteconnectClould(bool: Bool?) {}
    public func remoteOTAStatus(value: OTAResponseModel?) {}
    public func remoteOTAData(value: OTADataResponseModel?) {}
    public func remoteResponse(value: String?) {}
    
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
    public func wifiList(value: SSIDModel?) {}
    public func connectWifi(bool: Bool?) {}
    public func debug(value: String) {}
    public func connectMQTT(bool: Bool?) {}
    public func connectClould(bool: Bool?) {}
    public func OTAStatus(value: OTAResponseModel?) {}
    public func OTAData(value: OTADataResponseModel?) {}
   
}
