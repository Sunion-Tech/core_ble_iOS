//
//  main.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//

import Foundation
import SwiftyJSON

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
    
    public func remoteDisconnect() {
        remoteBleService?.disconnect()
    }
    
    public func remoteResponse(base64String: String) {
        remoteBleService?.responseData(base64String: base64String)
    }
    
    public func remoteSetupDeviceName(name: String) -> String? {
        return remoteBleService?.setupDeviceName(name: name)
    }
    
    
    public func remoteIsAdminCode() -> String? {
        return remoteBleService?.isAdminCode()
    }
    
    public func remoteSetupAdminCode(Code: String) -> String? {
        return remoteBleService?.setupAdminCode(Code: Code)
    }
    
    public func remoteEditAdminCode(oldCode: String, newCode: String) -> String? {
        return remoteBleService?.editAdminCode(oldCode: oldCode, newCode: newCode)
    }
    
    public func remoteSetupTimeZone(timezone: String) -> String? {
        return remoteBleService?.setupTimeZone(timezone: timezone)
    }
    
    public func remoteSetupDeviceTime() -> String? {
        return remoteBleService?.setupDeviceTime()
    }
    

    
    public func remoteGetDeviceName() -> String? {
        return remoteBleService?.getDeviceName()
    }
    
    public func remoteEditToken(model: EditTokenModel) -> String? {
        return remoteBleService?.editToken(model: model)
    }
    
    public func remoteGetDeviceConfigD4() -> String? {
        return remoteBleService?.getDeviceConfigKD0()
    }
    
    public func remoteGetDeviceConfigA0() -> String? {
        return remoteBleService?.getDeviceConfigTLR0()
    }
    
    public func remoteSetupDeviceConfig(data: DeviceSetupModel) -> String? {
        return remoteBleService?.setupDeviceConfig(model: data)
    }
    

    public func remoteBlotCheck() -> String? {
        return remoteBleService?.boltCheck()
    }
    
    public func remoteGetDeviceStatus() -> String? {
        return remoteBleService?.getDeviceStatus()
    }
    
    public func remoteSwitchDevice(mode: CommandService.DeviceMode) -> String? {
        return remoteBleService?.switchDevice(mode: mode)
    }
    
    public func remoteSwitchPlug(mode: CommandService.plugMode) -> String? {
        return remoteBleService?.switchPlug(mode: mode)
    }
    
    public func remoteSwitchSecurity(mode: CommandService.SecurityboltMode) -> String? {
        return remoteBleService?.switchSecurity(mode: mode)
    }
    
    public func remoteGetLogCount() -> String? {
        return remoteBleService?.getLogCount()
    }
    
    public func remoteGetLog(count: Int) -> String? {
        return remoteBleService?.getLog(count: count)
    }
    
    public func remoteSetupDeviceStatus01(status: CommandService.deviceMode00Status, audio: CommandService.deviceMode00Audio) -> String? {
        return remoteBleService?.setupDeviceStatus01(status: status, audio: audio)
    }
    
    public func remoteGetTokenArray() -> String? {
        return remoteBleService?.getTokenArray()
    }
    
    public func remoteGetToken(position: Int) -> String? {
        return remoteBleService?.getToken(position: position)
    }
    
    public func remoteCreateToken(model: AddTokenModel) -> String? {
        return remoteBleService?.createToken(model: model)
    }
    
    public func remoteDelToken(model: TokenModel, ownerPinCode: String? = nil) -> String? {
        return remoteBleService?.delToken(model: model, ownerPinCode: ownerPinCode)
    }
    
    public func remoteGetTokenQrCode(barcodeKey: String, tokenIndex: Int, aes1Key: Data, macAddress: String, userName: String, modelName: String, deviceName: String) -> String? {
        return remoteBleService?.getTokenQrCode(barcodeKey: barcodeKey, tokenIndex: tokenIndex, aes1Key: aes1Key, macAddress: macAddress, userName: userName, modelName: modelName, deviceName: deviceName)
    }
    
    public func remoteGetPinCodeArray() -> String? {
        return remoteBleService?.getPinCodeArray()
    }
    
    public func remoteGetPinCode(position: Int) -> String? {
        return remoteBleService?.getPinCode(position: position)
    }
    
    public func remotePinCodeOption(model: PinCodeManageModel) -> String? {
        return remoteBleService?.pinCodeOption(model: model)
    }
    
    public func remoteDelPinCode(position: Int)  -> String? {
        return remoteBleService?.delPinCode(position: position)
    }

    public  func remoteFactoryReset(adminCode: [Int]) -> String? {
        return remoteBleService?.factoryReset(adminCode: adminCode)
    }
    
    public func remotePlugFactoryReset() -> String? {
        return remoteBleService?.plugFactoryReset()
    }
    
    
    // MARK: - TLR0
    public func remoteGetSupportType() -> String? {
        return remoteBleService?.getSupportType()
    }
    
    public func remoteGetAccessArray(type: CommandService.AccessTypeMode) -> String? {
        return remoteBleService?.getAccessArray(type: type)
    }
    
    public func remoteSearchAccess(model: SearchAccessRequestModel) -> String? {
        return remoteBleService?.searchAccess(model: model)
    }
    
    public func remoteAccessAction(model: AccessRequestModel) -> String? {
        return remoteBleService?.accessAction(model: model)
    }
    
    public func remoteSetupAccess(model: SetupAccessRequestModel) -> String? {
        return remoteBleService?.setupAccess(model: model)
    }
    
    public func remoteDelAccess(model: DelAccessRequestModel) -> String? {
        return remoteBleService?.delAccess(model: model)
    }
    
    // MARK: - wifi
    public func remoteWifiList() -> String? {
        return remoteBleService?.wifiList()
    }
    
    public func remoteConnectWifi(SSIDName: String, passwrod: String) -> String? {
        return remoteBleService?.setSSID(SSIDName: SSIDName, password: passwrod)
    }
    
    public func remoteOtaStatus(req: OTAStatusRequestModel) -> String? {
        return remoteBleService?.otaStatus(req: req)
    }
    
    public func remoteOtaData(req: OTADataRequestModel) -> String? {
        return remoteBleService?.otaData(req: req)
    }
    
    public func remoteWifiAutounLock( identity: String) -> String? {
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
            delegate?.remoteDeviceStatus(value: optional)
        case .config(let bool):
            delegate?.remoteConfig(bool: bool)
        case .updateName(let bool):
            delegate?.remoteDeviceName(bool: bool)
        case .isAdminCode(let bool):
            delegate?.remoteAdminCodeExist(bool: bool)
        case .setupAdminCode(let bool):
            delegate?.remoteAdminCode(bool: bool)
        case .editAdminCode(let bool):
            delegate?.remoteEditAdminCode(bool: bool)
        case .setupTimeZone(let bool):
            delegate?.remoteTimeZone(bool: bool)
        case .DeviceName(let value):
            delegate?.remoteDeviceNameData(value: value)
        case .editToken(let bool):
            delegate?.remoteEditToken(bool: bool)
        case .deviceSetting(let model):
            delegate?.remoteDeviceConfig(value: model)
        case .logCount(let optional):
            delegate?.remoteLogCount(value: optional)
        case .log(let optional):
            delegate?.remoteLogData(value: optional)
        case .getTokenArray(let ary):
            delegate?.remoteTokenArray(value: ary)
        case .getToken(let model):
            delegate?.remoteTokenData(value: model)
        case .createToken(let model):
            delegate?.remoteTokenOption(value: model)
        case .delToken(let bool):
            delegate?.remoteToken(bool: bool)
        case .getTokenQrCode(let value):
            delegate?.remoteTokenQrCode(value: value)
        case .getPinCodeArray(let model):
            delegate?.remotePinCodeArray(value: model)
        case .getPinCode(let data):
            delegate?.remotePinCodeData(value: data)
        case .pinCodeoption(let bool):
            delegate?.remotePinCode(bool: bool)
        case .delPinCode(let bool):
            delegate?.remotePinCode(bool: bool)
        case .factoryReset(let bool):
            delegate?.remoteFactoryReset(bool: bool)
        case .supportType(let value):
            delegate?.remoteSupportType(value: value)
        case .accessArray(let value):
            delegate?.remoteAccessArray(value: value)
        case .searchAccess(let value):
            delegate?.remoteSearchAccess(value: value)
        case .accessAction(let value):
            delegate?.remoteAccessAction(value: value)
        case .setupAccess(let value):
            delegate?.remoteSetupAccess(value: value)
        case .delAccess(let value):
            delegate?.remoteDelAccess(value: value)
        case .wifiList(let value):
            delegate?.remotewifiList(value: value)
        case .connectWifi(let bool):
            delegate?.remoteconnectWifi(bool: bool)
        case .connectMQTT(let bool):
            delegate?.remoteconnectMQTT(bool: bool)
        case .connectClould(let bool):
            delegate?.remoteconnectClould(bool: bool)
        case .OTAData(let model):
            delegate?.remoteOTAData(value: model)
        case .OTAStatus(let model):
            delegate?.remoteOTAStatus(value: model)
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
