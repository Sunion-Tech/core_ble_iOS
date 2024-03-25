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
    func wifiList(value: SSIDModel?)
    func connectWifi(bool: Bool?)
    func connectMQTT(bool: Bool?)
    func connectClould(bool: Bool?)
    func debug(value: String)
    func OTAStatus(value: OTAResponseModel?)
    func OTAData(value: OTADataResponseModel?)
    func isWifAutounlock( bool: Bool?)
    func userCredentialArray(value: [Int]?)
    func userCredentialData(value: UserCredentialModel?)
    func userCredentialAction(value: N9ResponseModel?)
    func delUserCredentialAction(value: N9ResponseModel?)
    func getCredentialArray(value: [Int]?)
    func searchCredential(value: CredentialModel?)
    func credentialAction(value: N9ResponseModel?)
    func setupCredential(value: SetupCredentialModel?)
    func delCredential(value: N9ResponseModel?)
    func hashUserCredential(value: HashusercredentialModel?)
    func syncUserCredential(value: Bool?)
    func finishSyncData(value: Bool?)
    func isAutoUnLock(value: Bool?)
    func userAble(value: UserableResponseModel?)
    func isMatter(value: Bool?)
    func usersupportedCount(value: resUserSupportedCountModel?)
   
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
    public func wifiList(value: SSIDModel?) {}
    public func connectWifi(bool: Bool?) {}
    public func debug(value: String) {}
    public func connectMQTT(bool: Bool?) {}
    public func connectClould(bool: Bool?) {}
    public func OTAStatus(value: OTAResponseModel?) {}
    public func OTAData(value: OTADataResponseModel?) {}
    public func isWifAutounlock( bool: Bool?) {}
    public func userCredentialArray(value: [Int]?) {}
    public func userCredentialData(value: UserCredentialModel?) {}
    public func userCredentialAction(value: N9ResponseModel?) {}
    public func delUserCredentialAction(value: N9ResponseModel?) {}
    public func getCredentialArray(value: [Int]?) {}
    public func searchCredential(value: CredentialModel?) {}
    public func credentialAction(value: N9ResponseModel?) {}
    public func setupCredential(value: SetupCredentialModel?) {}
    public func delCredential(value: N9ResponseModel?) {}
    public func hashUserCredential(value: HashusercredentialModel?) {}
    public func syncUserCredential(value: Bool?) {}
    public func finishSyncData(value: Bool?) {}
    public func isAutoUnLock(value: Bool?) {}
    public func userAble(value: UserableResponseModel?) {}
    public func isMatter(value: Bool?) {}
    public func usersupportedCount(value: resUserSupportedCountModel?) {}
}
