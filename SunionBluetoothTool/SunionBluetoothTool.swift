//
//  main.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//

import Foundation
import SwiftyJSON

public protocol SunionBluetoothToolDelegate: AnyObject {
    func BluetoothState(State: bluetoothState)
    func DeviceStatus(value: DeviceStatusModel?)
    func Config(bool: Bool?)
    func AdminCodeExist(bool: Bool?)
    func AdminCode(bool: Bool?)
    func EditAdminCode(bool: Bool?)
//    func DeviceTime(bool: Bool?)
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
    func remoteResponse(value: String?)
   
}

extension SunionBluetoothToolDelegate {
    public func DeviceStatus(value: DeviceStatusModel?) {}
    public func Config(bool: Bool?) {}
    public func AdminCodeExist(bool: Bool?) {}
    public func AdminCode(bool: Bool?) {}
    public func EditAdminCode(bool: Bool?) {}
//    public func DeviceTime(bool: Bool?) {}
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
    public  func connectWifi(bool: Bool?) {}
    public  func debug(value: String) {}
    public func connectMQTT(bool: Bool?) {}
    public func connectClould(bool: Bool?) {}
    public func OTAStatus(value: OTAResponseModel?) {}
    public func OTAData(value: OTADataResponseModel?) {}
    public func remoteResponse(value: String?) {}
}

public class SunionBluetoothTool: NSObject {
    

    public static let shared = SunionBluetoothTool()
    public var data: BluetoothToolModel?
    
    var bluetoothService: BluetoothService?
    public var delegate: SunionBluetoothToolDelegate?
    
    var remoteBleService: RemoteBleService?
 
    public var status: bluetoothState?

    
    
   
    // MARK: - QrCode
    public func decodeQrCode(barcodeKey: String, qrCode: String) -> BluetoothToolModel? {
        if let decodeConfig = AESModel.shared.decodeBase64String(qrCode, barcodeKey: barcodeKey)?.replacingOccurrences(of: "\0", with: "") {
            let jsonConfig = JSON(parseJSON: decodeConfig)
            let model = self.fetchPoolConfig(jsonConfig)
            return model
        }
        
        return nil
    }
    
    private func fetchPoolConfig(_ jsonConfig:JSON) -> BluetoothToolModel {
        let qrService = QrCodeService(data: jsonConfig)

        let model = BluetoothToolModel()
        model.token = Data.init(qrService.token.hexStringTobyteArray).bytes
        model.aes1Key = Data.init(qrService.aes1.hexStringTobyteArray).bytes
        model.macAddress = qrService.mac
        model.qrCodeShareFrom = qrService.shareFrom
        model.qrCodeDisplayName = qrService.displayName
        model.qrCodeSerialNumber = qrService.serialNumber
        model.modelName = qrService.modelName
        
        print("🔧🔧🔧decodeQrCode🔧🔧🔧")
        print("token: \(model.token?.toHexString())")
        print("aes1Key: \(model.aes1Key?.toHexString())")
        print("macAddress: \(model.macAddress)")
        print("qrCodeShareFrom: \(model.qrCodeShareFrom)")
        print("qrCodeDisplayName: \(model.qrCodeDisplayName)")
        print("qrCodeSerialNumber: \(model.qrCodeSerialNumber)")
        print("modelName: \(model.modelName)")
        print("🔧🔧🔧🔧🔧🔧")
        self.data = model
        return model
    }
    

    // MARK: - RemoteBle
    public func initRemoteBle(macAddress: String, aes1Key: [UInt8], token: [UInt8]) {
        remoteBleService = RemoteBleService(delegate: self, mackAddress: macAddress, aes1Key: aes1Key, token: token)
    }
    public func connectingRemote() -> String? {
       return remoteBleService?.deviceTokenExchange()
    }
    
    public func remoteResponse(base64String: String) {
        remoteBleService?.responseData(base64String: base64String)
    }
    
    public func remmoteSetupDeviceName(name: String) -> String? {
        return remoteBleService?.setupDeviceName(name: name)
    }
    
    
    public func remmoteIsAdminCode() -> String? {
        return remoteBleService?.isAdminCode()
    }
    
    public func remmoteSetupAdminCode(Code: String) -> String? {
        return remoteBleService?.setupAdminCode(Code: Code)
    }
    
    public func remmoteEditAdminCode(oldCode: String, newCode: String) -> String? {
        return remoteBleService?.editAdminCode(oldCode: oldCode, newCode: newCode)
    }
    
    public func remmoteSetupTimeZone(timezone: String) -> String? {
        return remoteBleService?.setupTimeZone(timezone: timezone)
    }
    
    public func remmoteSetupDeviceTime() -> String? {
        return remoteBleService?.setupDeviceTime()
    }
    

    
    public func remmoteGetDeviceName() -> String? {
        return remoteBleService?.getDeviceName()
    }
    
    public func remmoteEditToken(model: EditTokenModel) -> String? {
        return remoteBleService?.editToken(model: model)
    }
    
    public func remmoteGetDeviceConfigD4() -> String? {
        return remoteBleService?.getDeviceConfigKD0()
    }
    
    public func remmoteGetDeviceConfigA0() -> String? {
        return remoteBleService?.getDeviceConfigTLR0()
    }
    
    public func remmoteSetupDeviceConfig(data: DeviceSetupModel) -> String? {
        return remoteBleService?.setupDeviceConfig(model: data)
    }
    

    public func remmoteBlotCheck() -> String? {
        return remoteBleService?.boltCheck()
    }
    
    public func remmoteGetDeviceStatus() -> String? {
        return remoteBleService?.getDeviceStatus()
    }
    
    public func remmoteSwitchDevice(mode: CommandService.DeviceMode) -> String? {
        return remoteBleService?.switchDevice(mode: mode)
    }
    
    public func remmoteSwitchPlug(mode: CommandService.plugMode) -> String? {
        return remoteBleService?.switchPlug(mode: mode)
    }
    
    public func remmoteSwitchSecurity(mode: CommandService.SecurityboltMode) -> String? {
        return remoteBleService?.switchSecurity(mode: mode)
    }
    
    public func remmoteGetLogCount() -> String? {
        return remoteBleService?.getLogCount()
    }
    
    public func remmoteGetLog(count: Int) -> String? {
        return remoteBleService?.getLog(count: count)
    }
    
    public func remmoteSetupDeviceStatus01(status: CommandService.deviceMode00Status, audio: CommandService.deviceMode00Audio) -> String? {
        return remoteBleService?.setupDeviceStatus01(status: status, audio: audio)
    }
    
    public func remmoteGetTokenArray() -> String? {
        return remoteBleService?.getTokenArray()
    }
    
    public func remmoteGetToken(position: Int) -> String? {
        return remoteBleService?.getToken(position: position)
    }
    
    public func remmoteCreateToken(model: AddTokenModel) -> String? {
        return remoteBleService?.createToken(model: model)
    }
    
    public func remmoteDelToken(model: TokenModel, ownerPinCode: String? = nil) -> String? {
        return remoteBleService?.delToken(model: model, ownerPinCode: ownerPinCode)
    }
    
    public func remmoteGetTokenQrCode(barcodeKey: String, tokenIndex: Int, aes1Key: Data, macAddress: String, userName: String, modelName: String, deviceName: String) -> String? {
        return remoteBleService?.getTokenQrCode(barcodeKey: barcodeKey, tokenIndex: tokenIndex, aes1Key: aes1Key, macAddress: macAddress, userName: userName, modelName: modelName, deviceName: deviceName)
    }
    
    public func remmoteGetPinCodeArray() -> String? {
        return remoteBleService?.getPinCodeArray()
    }
    
    public func remmoteGetPinCode(position: Int) -> String? {
        return remoteBleService?.getPinCode(position: position)
    }
    
    public func remmotePinCodeOption(model: PinCodeManageModel) -> String? {
        return remoteBleService?.pinCodeOption(model: model)
    }
    
    public func remmoteDelPinCode(position: Int)  -> String? {
        return remoteBleService?.delPinCode(position: position)
    }

    public  func remmoteFactoryReset(adminCode: [Int]) -> String? {
        return remoteBleService?.factoryReset(adminCode: adminCode)
    }
    
    public func remmotePlugFactoryReset() -> String? {
        return remoteBleService?.plugFactoryReset()
    }
    
    
    // MARK: - TLR0
    public func remmoteGetSupportType() -> String? {
        return remoteBleService?.getSupportType()
    }
    
    public func remmoteGetAccessArray(type: CommandService.AccessTypeMode) -> String? {
        return remoteBleService?.getAccessArray(type: type)
    }
    
    public func remmoteSearchAccess(model: SearchAccessRequestModel) -> String? {
        return remoteBleService?.searchAccess(model: model)
    }
    
    public func remmoteAccessAction(model: AccessRequestModel) -> String? {
        return remoteBleService?.accessAction(model: model)
    }
    
    public func remmoteSetupAccess(model: SetupAccessRequestModel) -> String? {
        return remoteBleService?.setupAccess(model: model)
    }
    
    public func remmoteDelAccess(model: DelAccessRequestModel) -> String? {
        return remoteBleService?.delAccess(model: model)
    }
    
    // MARK: - wifi
    public func remmoteWifiList() -> String? {
        return remoteBleService?.wifiList()
    }
    
    public func remmoteConnectWifi(SSIDName: String, passwrod: String) -> String? {
        return remoteBleService?.setSSID(SSIDName: SSIDName, password: passwrod)
    }
    
    public func remmoteOtaStatus(req: OTAStatusRequestModel) -> String? {
        return remoteBleService?.otaStatus(req: req)
    }
    
    public func remmoteOtaData(req: OTADataRequestModel) -> String? {
        return remoteBleService?.otaData(req: req)
    }
    
    public func remmoteWifiAutounLock( identity: String) -> String? {
        return remoteBleService?.wifiAutoUnlock(identity: identity)
    }
    
    
    
    // MARK: - BlueTooth
    public func initBluetooth(macAddress: String, aes1Key: [UInt8], token: [UInt8]) {
        bluetoothService = BluetoothService(delegate: self, mackAddress: macAddress, aes1Key: aes1Key, token: token)
    }
    
    public func connectWithIdentifier(value: String) {
        bluetoothService?.connectWithIdentifier(value: value)
    }
    
    public func disconnectBluetooth() {
        bluetoothService?.disconnect()
    }
    
    public func connectingBluetooth() {
        bluetoothService?.startConnecting()
    }
    
    public func setupDeviceName(name: String) {
        bluetoothService?.setupDeviceName(name: name)
    }
    
    public func isAdminCode() {
        bluetoothService?.isAdminCode()
    }
    
    public func setupAdminCode(Code: String) {
        bluetoothService?.setupAdminCode(Code: Code)
    }
    
    public func editAdminCode(oldCode: String, newCode: String) {
        bluetoothService?.editAdminCode(oldCode: oldCode, newCode: newCode)
    }
    
    public func setupTimeZone(timezone: String) {
        bluetoothService?.setupTimeZone(timezone: timezone)
    }
    
    public func setupDeviceTime() {
        bluetoothService?.setupDeviceTime()
    }
    

    
    public func getDeviceName() {
        bluetoothService?.getDeviceName()
    }
    
    public func editToken(model: EditTokenModel) {
        bluetoothService?.editToken(model: model)
    }
    
    public func getDeviceConfigD4() {
        bluetoothService?.getDeviceConfigKD0()
    }
    
    public func getDeviceConfigA0() {
        bluetoothService?.getDeviceConfigTLR0()
    }
    
    public func setupDeviceConfig(data: DeviceSetupModel) {
        bluetoothService?.setupDeviceConfig(model: data)
    }
    

    public func blotCheck() {
        bluetoothService?.boltCheck()
    }
    
    public func getDeviceStatus() {
        bluetoothService?.getDeviceStatus()
    }
    
    public func switchDevice(mode: CommandService.DeviceMode) {
        bluetoothService?.switchDevice(mode: mode)
    }
    
    public func switchPlug(mode: CommandService.plugMode) {
        bluetoothService?.switchPlug(mode: mode)
    }
    
    public func switchSecurity(mode: CommandService.SecurityboltMode) {
        bluetoothService?.switchSecurity(mode: mode)
    }
    
    public func getLogCount() {
        bluetoothService?.getLogCount()
    }
    
    public func getLog(count: Int) {
        bluetoothService?.getLog(count: count)
    }
    
    public func setupDeviceStatus01(status: CommandService.deviceMode00Status, audio: CommandService.deviceMode00Audio) {
        bluetoothService?.setupDeviceStatus01(status: status, audio: audio)
    }
    
    public func getTokenArray() {
        bluetoothService?.getTokenArray()
    }
    
    public func getToken(position: Int) {
        bluetoothService?.getToken(position: position)
    }
    
    public func createToken(model: AddTokenModel) {
        bluetoothService?.createToken(model: model)
    }
    
    public func delToken(model: TokenModel, ownerPinCode: String? = nil) {
        bluetoothService?.delToken(model: model, ownerPinCode: ownerPinCode)
    }
    
    public func getTokenQrCode(barcodeKey: String, tokenIndex: Int, aes1Key: Data, macAddress: String, userName: String, modelName: String, deviceName: String) {
        bluetoothService?.getTokenQrCode(barcodeKey: barcodeKey, tokenIndex: tokenIndex, aes1Key: aes1Key, macAddress: macAddress, userName: userName, modelName: modelName, deviceName: deviceName)
    }
    
    public func getPinCodeArray() {
        bluetoothService?.getPinCodeArray()
    }
    
    public func getPinCode(position: Int) {
        bluetoothService?.getPinCode(position: position)
    }
    
    public func pinCodeOption(model: PinCodeManageModel) {
        bluetoothService?.pinCodeOption(model: model)
    }
    
    public func delPinCode(position: Int)  {
        bluetoothService?.delPinCode(position: position)
    }

    public  func factoryReset(adminCode: [Int]) {
        bluetoothService?.factoryReset(adminCode: adminCode)
    }
    
    public func plugFactoryReset() {
        bluetoothService?.plugFactoryReset()
    }
    
    
    // MARK: - TLR0
    public func getSupportType() {
        bluetoothService?.getSupportType()
    }
    
    public func getAccessArray(type: CommandService.AccessTypeMode) {
        bluetoothService?.getAccessArray(type: type)
    }
    
    public func searchAccess(model: SearchAccessRequestModel) {
        bluetoothService?.searchAccess(model: model)
    }
    
    public func accessAction(model: AccessRequestModel) {
        bluetoothService?.accessAction(model: model)
    }
    
    public func setupAccess(model: SetupAccessRequestModel) {
        bluetoothService?.setupAccess(model: model)
    }
    
    public func delAccess(model: DelAccessRequestModel) {
        bluetoothService?.delAccess(model: model)
    }
    
    // MARK: - wifi
    public func wifiList() {
        bluetoothService?.wifiList()
    }
    
    public func connectWifi(SSIDName: String, passwrod: String) {
        bluetoothService?.setSSID(SSIDName: SSIDName, password: passwrod)
    }
    
    public func otaStatus(req: OTAStatusRequestModel) {
        bluetoothService?.otaStatus(req: req)
    }
    
    public func otaData(req: OTADataRequestModel) {
        bluetoothService?.otaData(req: req)
    }
    
    public func wifiAutounLock( identity: String) {
        bluetoothService?.wifiAutoUnlock(identity: identity)
    }
}

// MARK: - Delegate
// MARK: - RemoteBleServiceDelegate
extension SunionBluetoothTool: RemoteBleServiceDelegate {
    func remoteState(State: bluetoothState) {
        delegate?.BluetoothState(State: State)
        self.status = State
    }
    
    func remoteResponseData(value: String?) {
        delegate?.remoteResponse(value: value)
    }
    
    func remotecommandState(value: commandState) {
        switch value {
        case .none:
            break
        case .deviceStatus(let optional):
            delegate?.DeviceStatus(value: optional)
        case .config(let bool):
            delegate?.Config(bool: bool)
        case .updateName(let bool):
            delegate?.DeviceName(bool: bool)
        case .isAdminCode(let bool):
            delegate?.AdminCodeExist(bool: bool)
        case .setupAdminCode(let bool):
            delegate?.AdminCode(bool: bool)
        case .editAdminCode(let bool):
            delegate?.EditAdminCode(bool: bool)
        case .setupTimeZone(let bool):
            delegate?.TimeZone(bool: bool)
//        case .setupDeviceTime(let bool):
//            delegate?.DeviceTime(bool: bool)
        case .DeviceName(let value):
            delegate?.DeviceNameData(value: value)
        case .editToken(let bool):
            delegate?.EditToken(bool: bool)
        case .deviceSetting(let model):
            delegate?.DeviceConfig(value: model)
        case .logCount(let optional):
            delegate?.LogCount(value: optional)
        case .log(let optional):
            delegate?.LogData(value: optional)
        case .getTokenArray(let ary):
            delegate?.TokenArray(value: ary)
        case .getToken(let model):
            delegate?.TokenData(value: model)
        case .createToken(let model):
            delegate?.TokenOption(value: model)
        case .delToken(let bool):
            delegate?.Token(bool: bool)
        case .getTokenQrCode(let value):
            delegate?.TokenQrCode(value: value)
        case .getPinCodeArray(let model):
            delegate?.PinCodeArray(value: model)
        case .getPinCode(let data):
            delegate?.PinCodeData(value: data)
        case .pinCodeoption(let bool):
            delegate?.PinCode(bool: bool)
        case .delPinCode(let bool):
            delegate?.PinCode(bool: bool)
        case .factoryReset(let bool):
            delegate?.FactoryReset(bool: bool)
        case .supportType(let value):
            delegate?.SupportType(value: value)
        case .accessArray(let value):
            delegate?.AccessArray(value: value)
        case .searchAccess(let value):
            delegate?.SearchAccess(value: value)
        case .accessAction(let value):
            delegate?.AccessAction(value: value)
        case .setupAccess(let value):
            delegate?.SetupAccess(value: value)
        case .delAccess(let value):
            delegate?.DelAccess(value: value)
        case .wifiList(let value):
            delegate?.wifiList(value: value)
        case .connectWifi(let bool):
            delegate?.connectWifi(bool: bool)
        case .connectMQTT(let bool):
            delegate?.connectMQTT(bool: bool)
        case .connectClould(let bool):
            delegate?.connectClould(bool: bool)
        case .OTAData(let model):
            delegate?.OTAData(value: model)
        case .OTAStatus(let model):
            delegate?.OTAStatus(value: model)
        }
    }
    
    func remoteupdateData(value: BluetoothToolModel) {
        if let data = data {
            data.permanentToken = value.permanentToken
            data.permission = value.permission
            data.aes2Key = value.aes2Key
            data.FirmwareVersion = value.FirmwareVersion
            data.bleName = value.bleName
            data.identifier = value.identifier
        } else {
            let model = BluetoothToolModel()
            model.permanentToken = value.permanentToken
            model.permission = value.permission
            model.aes2Key = value.aes2Key
            model.FirmwareVersion = value.FirmwareVersion
            model.bleName = value.bleName
            model.identifier = value.identifier
            data = model
        }
    }
    
    func remotedebug(value: String) {
        print("💞💞💞remotedebug💞💞💞")
        print("\(value)")
        print("💞💞💞💞💞💞")
    }
    
    
}

// MARK: - BluetoothServiceDelegate

extension SunionBluetoothTool: BluetoothServiceDelegate {
    func updateData(value: BluetoothToolModel) {
       
        if let data = data {
            data.permanentToken = value.permanentToken
            data.permission = value.permission
            data.aes2Key = value.aes2Key
            data.FirmwareVersion = value.FirmwareVersion
            data.bleName = value.bleName
            data.identifier = value.identifier
        } else {
            let model = BluetoothToolModel()
            model.permanentToken = value.permanentToken
            model.permission = value.permission
            model.aes2Key = value.aes2Key
            model.FirmwareVersion = value.FirmwareVersion
            model.bleName = value.bleName
            model.identifier = value.identifier
            data = model
        }
     
    }

    func commandState(value: commandState) {
        switch value {
        case .none:
            break
        case .deviceStatus(let optional):
            delegate?.DeviceStatus(value: optional)
        case .config(let bool):
            delegate?.Config(bool: bool)
        case .updateName(let bool):
            delegate?.DeviceName(bool: bool)
        case .isAdminCode(let bool):
            delegate?.AdminCodeExist(bool: bool)
        case .setupAdminCode(let bool):
            delegate?.AdminCode(bool: bool)
        case .editAdminCode(let bool):
            delegate?.EditAdminCode(bool: bool)
        case .setupTimeZone(let bool):
            delegate?.TimeZone(bool: bool)
//        case .setupDeviceTime(let bool):
//            delegate?.DeviceTime(bool: bool)
        case .DeviceName(let value):
            delegate?.DeviceNameData(value: value)
        case .editToken(let bool):
            delegate?.EditToken(bool: bool)
        case .deviceSetting(let model):
            delegate?.DeviceConfig(value: model)
        case .logCount(let optional):
            delegate?.LogCount(value: optional)
        case .log(let optional):
            delegate?.LogData(value: optional)
        case .getTokenArray(let ary):
            delegate?.TokenArray(value: ary)
        case .getToken(let model):
            delegate?.TokenData(value: model)
        case .createToken(let model):
            delegate?.TokenOption(value: model)
        case .delToken(let bool):
            delegate?.Token(bool: bool)
        case .getTokenQrCode(let value):
            delegate?.TokenQrCode(value: value)
        case .getPinCodeArray(let model):
            delegate?.PinCodeArray(value: model)
        case .getPinCode(let data):
            delegate?.PinCodeData(value: data)
        case .pinCodeoption(let bool):
            delegate?.PinCode(bool: bool)
        case .delPinCode(let bool):
            delegate?.PinCode(bool: bool)
        case .factoryReset(let bool):
            delegate?.FactoryReset(bool: bool)
        case .supportType(let value):
            delegate?.SupportType(value: value)
        case .accessArray(let value):
            delegate?.AccessArray(value: value)
        case .searchAccess(let value):
            delegate?.SearchAccess(value: value)
        case .accessAction(let value):
            delegate?.AccessAction(value: value)
        case .setupAccess(let value):
            delegate?.SetupAccess(value: value)
        case .delAccess(let value):
            delegate?.DelAccess(value: value)
        case .wifiList(let value):
            delegate?.wifiList(value: value)
        case .connectWifi(let bool):
            delegate?.connectWifi(bool: bool)
        case .connectMQTT(let bool):
            delegate?.connectMQTT(bool: bool)
        case .connectClould(let bool):
            delegate?.connectClould(bool: bool)
        case .OTAData(let model):
            delegate?.OTAData(value: model)
        case .OTAStatus(let model):
            delegate?.OTAStatus(value: model)
        }
    }
    

    func bluetoothState(State: bluetoothState) {
      
        delegate?.BluetoothState(State: State)
        self.status = State
    }
    
    func debug(value: String) {
        delegate?.debug(value: value)
    }
    
}
