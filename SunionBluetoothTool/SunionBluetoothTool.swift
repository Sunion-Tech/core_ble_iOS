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

    public var status: bluetoothState?
    
    public lazy var UseCase: useCase = {
        return useCase(tool: self)
    }()

   
    // MARK: - QrCode
    public func decodeQrCode(barcodeKey: String, qrCode: String) -> BluetoothToolModel? {
        if let decodeConfig = AESModel.shared.decodeBase64String(qrCode, barcodeKey: barcodeKey)?.replacingOccurrences(of: "\0", with: "") {
            let jsonConfig = JSON(parseJSON: decodeConfig)
            let model = self.fetchPoolConfig(jsonConfig)
            return model
        }
        
        return nil
    }
    
    func qrCode(value: String) -> String? {
        return value.count == 16 ? value : nil
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
    
    
    // MARK: - BlueTooth
    public func initBluetooth(macAddress: String?, aes1Key: [UInt8], token: [UInt8], v3udid: String?) {
        bluetoothService = BluetoothService(delegate: self, mackAddress: macAddress, aes1Key: aes1Key, token: token, udid: v3udid)
     
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
    
    public func getDeviceConfig80() {
        bluetoothService?.getDeviceConfig80()
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
    
    public func iswifiAutoUnlock(identity: String) {
        bluetoothService?.iswifiAutoUnlock(Identity: identity)
    }
    
    // MARK: - 3.0
    public func getRFVersion() {
        bluetoothService?.getRFVersion()
    }
    
    public func getUserCredentialArray() {
        bluetoothService?.getUserCredentialArray()
    }
    
    public func getUserCredential(position: Int) {
        bluetoothService?.getUserCredential(position: position)
    }
    
    public func userCredentialAction(model: UserCredentialRequestModel) {
        bluetoothService?.userCredentialAction(model: model)
    }
    
    public func delUserCredentialAction(position: Int) {
        let model = IndexUserCredentialRequestModel(index: position)
        bluetoothService?.delUserCredentialAction(model: model)
    }
    
    public func getCredentialArray() {
        bluetoothService?.getCredientialArray()
    }
    
    public func searchCredential(model: SearchCredentialRequestModel) {
        bluetoothService?.searchCredential(model: model)
    }
    
    public func credentialAction(model: CredentialRequestModel) {
        bluetoothService?.credentialAction(model: model)
    }
    
    public func setupCredential(model: SetupCredentialRequestModel) {
        bluetoothService?.setupCrential(model: model)
    }
    
    public func delCredential(position: Int) {
        let model = IndexUserCredentialRequestModel(index: position)
        bluetoothService?.delCredential(model: model)
    }
    
    public func hashUserCredential(model: HashusercredentialRequestModel) {
        bluetoothService?.hashUserCredential(model: model)
    }
    
    public func syncUserCredential() {
        bluetoothService?.syncUserCredential()
    }
    
    public func finishSyncData() {
        bluetoothService?.finishSyncData()
    }
    
    public func isAutoUnLock() {
        bluetoothService?.isAutoUnlock()
    }
    
    public func userAble() {
        bluetoothService?.userAble()
    }
    
    public func isMatter() {
        bluetoothService?.isMatter()
    }
    
    public func getUserSupportedCount() {
        bluetoothService?.getUserSupportedCount()
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
        case .isWifiAutonunlock(let bool):
            delegate?.isWifAutounlock(bool: bool)
        case .getUserCredentialArray(let indexs):
            delegate?.userCredentialArray(value: indexs)
        case .getUserCredential(let model):
            delegate?.userCredentialData(value: model)
        case .userCredentialAction(let model):
            delegate?.userCredentialAction(value: model)
        case .getCredientialArray(let model):
            delegate?.getCredentialArray(value: model)
        case .searchCredential(let model):
            delegate?.searchCredential(value: model)
        case .delUserCredential(let model):
            delegate?.delUserCredentialAction(value: model)
        case .credentialAction(let model):
            delegate?.credentialAction(value: model)
        case .setupCredential(let model):
            delegate?.setupCredential(value: model)
        case .delCredential(let model):
            delegate?.delCredential(value: model)
        case .hashUserCredential(let model):
            delegate?.hashUserCredential(value: model)
        case .syncUserCredential(let model):
            delegate?.syncUserCredential(value: model)
        case .finishSyncData(let model):
            delegate?.finishSyncData(value: model)
        case .isAutoUnLock(let model):
            delegate?.isAutoUnLock(value: model)
        case .userAble(let model):
            delegate?.userAble(value: model)
        case .isMatter(let model):
            delegate?.isMatter(value: model)
        case .userSupportedCount(let model):
            delegate?.usersupportedCount(value: model)
            
            // MARK: -V3
        case.v3deviceStatus(let model):
            delegate?.v3deviceStatus(value: model)
        case .v3time(let model):
            delegate?.v3time(vlaue: model)
        case .v3adminCode(let model):
            delegate?.v3adminCode(vlaue: model)
        case .v3Direction(let model):
            delegate?.v3Direction(valu: model)
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
