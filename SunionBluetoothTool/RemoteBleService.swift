//
//  RemoteBleService.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/11/23.
//

import Foundation
import SwiftyJSON


protocol RemoteBleServiceDelegate: AnyObject {
    func remoteState(State: bluetoothState)
    func remotecommandState(value: commandState)
    func remoteupdateData(value: BluetoothToolModel)
    func remoteResponseData(value: String?)
    
}

extension RemoteBleServiceDelegate {
    func remotecommandState() {}
    func remoteupdateData() {}
}


class RemoteBleService: NSObject {
    
    weak var delegate: RemoteBleServiceDelegate?
    
    var mackAddress: String?
    var aes1key: [UInt8]?
    var aes2key: [UInt8]?
    var oneTimeToken: [UInt8]?
    var permanentToken: [UInt8]?
    
    var data: BluetoothToolModel = BluetoothToolModel()
    
    
    let c0RandomData = CommandService.shared.fillDataLength(with: .C0(nil))
    
    var qrcodeAes1Key: String = ""
    var qrcodeUserName: String = ""
    var qrcodeModelName: String = ""
    var qrcodeDeviceName: String = ""
    var qrcodeMacAddress: String = ""
    
    var barcodeKey: String = ""
    
    var wifiPassword: String = ""
    
    enum modelCommandType {
        case D
        case A
    }
    var commandType: modelCommandType = .A
    
    var action: commandState = .deviceStatus(nil)
    
    var keepC1Data: DeviceStatusModel? = nil
    
    
    init( delegate: RemoteBleServiceDelegate?, mackAddress: String, aes1Key: [UInt8], token: [UInt8]) {
        
        super.init()
        self.mackAddress = mackAddress
        self.delegate = delegate
        self.aes1key = aes1Key
        self.oneTimeToken = token
        
        
    }
    
    func deviceTokenExchange() -> String? {
        delegate?.remoteState(State: .connecting)
        let command = CommandService.shared.createAction(with: .C0(c0RandomData), key: aes1key!)
        return command?.base64EncodedString()
    }
    
    func disconnect() {
        delegate?.remoteState(State: .disconnect(.normal))
    }
    
    //MARK: -  設定名稱
    
    func setupDeviceName(name: String)  -> String? {
        
        action = .updateName(nil)
        let command = CommandService.shared.createAction(with: .D1(name), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - 是否有AdmonCode
    func isAdminCode() -> String? {
        
        action = .isAdminCode(nil)
        let command = CommandService.shared.createAction(with: .EF, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    
    // MARK: - 設定AdminCode
    func setupAdminCode(Code: String) -> String? {
        
        action = .setupAdminCode(nil)
        let adminCode = Code.compactMap{Int(String($0))}
        let command = CommandService.shared.createAction(with: .C7(adminCode), key: aes2key!)
        return command?.base64EncodedString()
    }
    // MARK: - 編輯AdminCode
    func editAdminCode(oldCode: String, newCode: String) -> String? {
        
        action = .editAdminCode(nil)
        let oldDigits = oldCode.compactMap{Int(String($0))}
        let newDigits = newCode.compactMap{Int(String($0))}
        let model = EditAdminCodeModel(oldCode: oldDigits, newCode: newDigits)
        let command = CommandService.shared.createAction(with: .C8(model), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - 設定TimeZone
    func setupTimeZone(timezone: String) -> String? {
        
        guard let timeZone = TimeZone(identifier: timezone),
              let abbreviation = timeZone.secondsFromGMT().toString.data(using: .utf8) else { return nil }
        
        action = .setupTimeZone(nil)
        
        let command = CommandService.shared.createAction(with: .D9(Int32(timeZone.secondsFromGMT()), abbreviation), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    
    
    // MARK: - 設定DeviceTime
    func setupDeviceTime() -> String? {
        
        let command = CommandService.shared.createAction(with: .D3(Date()), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    
    
    // MARK: - 取得DeviceName
    func getDeviceName() -> String? {
        
        action = .DeviceName(nil)
        let command = CommandService.shared.createAction(with: .D0, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - 編輯Token
    func editToken(model: EditTokenModel) -> String? {
        
        action = .editToken(nil)
        let command =  CommandService.shared.createAction(with: .E7(model), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - 查詢設定檔
    func getDeviceConfigKD0() -> String? {
        
        
        action = .deviceSetting(nil)
        let command =  CommandService.shared.createAction(with: .D4, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func getDeviceConfigTLR0() -> String? {
        
        
        action = .deviceSetting(nil)
        let command =  CommandService.shared.createAction(with: .A0, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - 設定設定檔
    func setupDeviceConfig(model: DeviceSetupModel) -> String? {
        
        
        action = .config(nil)
        
        let command =  CommandService.shared.createAction(with: commandType == .D ? .D5(model.D5!) : .A1(model.A1!), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    
    // MARK: - 門向判定
    func boltCheck() -> String? {
        
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: .CC, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - 取得裝置狀態
    func getDeviceStatus() -> String? {
        
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: commandType == .D ? .D6 : .A2, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - 開關鎖
    func switchDevice(mode: CommandService.DeviceMode) -> String? {
        
        action = .deviceStatus(nil)
        
        let command =  CommandService.shared.createAction(with: commandType == .D ? .D7(mode) : .A3(.lockstate, mode, nil), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func switchPlug(mode: CommandService.plugMode) -> String? {
        
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: .B1(mode), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func switchSecurity(mode: CommandService.SecurityboltMode?) -> String? {
        
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: .A3(.securitybolt, nil, mode), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK:  - Log
    // count
    func getLogCount() -> String? {
        
        action = .logCount(nil)
        let command =  CommandService.shared.createAction(with: .E0, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // data
    func getLog(count: Int) -> String? {
        
        action = .log(nil)
        let command =  CommandService.shared.createAction(with: .E1(count), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - 00 / 01
    
    func setupDeviceStatus01(status: CommandService.deviceMode00Status, audio: CommandService.deviceMode00Audio) -> String? {
        
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: .Z1(status, audio), key: aes2key!)
        return command?.base64EncodedString()
        
    }
    
    // MARK: - Share User
    // count
    func getTokenArray() -> String? {
        
        action = .getTokenArray(nil)
        let command =  CommandService.shared.createAction(with: .E4, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // data
    func getToken(position: Int) -> String?{
        
        action = .getToken(nil)
        let command =  CommandService.shared.createAction(with: .E5(position), key: aes2key!)
        return command?.base64EncodedString()
    }
    // create
    func createToken(model: AddTokenModel) -> String? {
        
        action = .createToken(nil)
        let command =  CommandService.shared.createAction(with: .E6(model), key: aes2key!)
        return command?.base64EncodedString()
    }
    // delete
    func delToken(model: TokenModel, ownerPinCode: String? = nil) -> String? {
        
        action = .delToken(nil)
        var digit: [UInt8]?
        if let ownerPinCode = ownerPinCode {
            digit = ownerPinCode.compactMap{Int(String($0))}.map{UInt8($0)}
        }
        let command =  CommandService.shared.createAction(with: .E8(model, digit), key: aes2key!)
        return command?.base64EncodedString()
    }
    // qrcode
    func getTokenQrCode(barcodeKey: String, tokenIndex: Int, aes1Key: Data, macAddress: String, userName: String, modelName: String, deviceName: String) -> String? {
        
        action = .getTokenQrCode(nil)
        qrcodeAes1Key = aes1Key.toHexString()
        qrcodeUserName = userName
        qrcodeModelName = modelName
        qrcodeDeviceName = deviceName
        qrcodeMacAddress = macAddress
        self.barcodeKey = barcodeKey
        let command =  CommandService.shared.createAction(with: .E5(tokenIndex), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - PinCode
    func getPinCodeArray() -> String? {
        
        action = .getPinCodeArray(nil)
        let command =  CommandService.shared.createAction(with: .EA, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func getPinCode(position: Int) -> String? {
        
        action = .getPinCode(nil)
        let command =  CommandService.shared.createAction(with: .EB(position), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // add / edit
    func pinCodeOption(model: PinCodeManageModel) -> String? {
        
        action = .pinCodeoption(nil)
        let command =  CommandService.shared.createAction(with: .EC(model), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func delPinCode(position: Int) -> String? {
        
        action = .delPinCode(nil)
        let command =  CommandService.shared.createAction(with: .EE(position), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK :- factory reset
    func factoryReset(adminCode: [Int]) -> String? {
        
        action = .factoryReset(nil)
        let command =  CommandService.shared.createAction(with: .CE(adminCode), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func plugFactoryReset() -> String? {
        
        action = .factoryReset(nil)
        let command =  CommandService.shared.createAction(with: .CF, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: TLR0
    // support type
    
    func getSupportType() -> String? {
        
        action = .supportType(nil)
        let command =  CommandService.shared.createAction(with: .A4, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func getAccessArray(type: CommandService.AccessTypeMode) -> String? {
        
        action = .accessArray(nil)
        let command =  CommandService.shared.createAction(with: .A5(type), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func searchAccess(model: SearchAccessRequestModel) -> String? {
        
        action = .searchAccess(nil)
        
        let command =  CommandService.shared.createAction(with: .A6(model), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func accessAction(model: AccessRequestModel) -> String? {
        
        action = .accessAction(nil)
        
        let command =  CommandService.shared.createAction(with: model.accessOption == .add  ? .A7(model) : .A8(model), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func setupAccess(model: SetupAccessRequestModel) -> String? {
        
        action = .setupAccess(nil)
        
        let command =  CommandService.shared.createAction(with: .A9(model), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func delAccess(model: DelAccessRequestModel) -> String? {
        
        action = .delAccess(nil)
        
        let command =  CommandService.shared.createAction(with: .AA(model), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - Wifi
    func wifiList() -> String? {
        
        action = .wifiList(nil)
        let command =  CommandService.shared.createAction(with: .getWifiList, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func setSSID(SSIDName: String, password: String) -> String? {
        
        action = .connectWifi(nil)
        wifiPassword = password
        let command =  CommandService.shared.createAction(with: .setSSID(SSIDName), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func setWifiPassword() -> String? {
        
        action = .connectWifi(nil)
        let command =  CommandService.shared.createAction(with: .setPassword(wifiPassword), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func connectWifi() -> String? {
        
        action = .connectWifi(nil)
        let command =  CommandService.shared.createAction(with: .setConnection, key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - OTA
    func otaStatus(req: OTAStatusRequestModel) -> String? {
        
        action = .OTAStatus(nil)
        let command =  CommandService.shared.createAction(with: .C3(req), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    func otaData(req: OTADataRequestModel)  -> String? {
        
        action = .OTAData(nil)
        let command =  CommandService.shared.createAction(with: .C4(req), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    // MARK: - wifi Autounlock
    func wifiAutoUnlock(identity: String ) -> String? {
        
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: .F1(identity), key: aes2key!)
        return command?.base64EncodedString()
    }
    
    private func getKey2(randomNum1: [UInt8], randomNum2: [UInt8]) -> [UInt8] {
        
        let last = randomNum1.count - 1
        let random1 = Array(randomNum1[2...last])
        let random2 = randomNum2
        let key2 = random1.enumerated().map { $0.element ^ random2[$0.offset] }
        return key2
    }
    
    // MARK: - Response
    func responseData(base64String: String) {
        
    
        if let characteristic = Data(base64Encoded: base64String) {
   
            let response = CommandService.shared.resolveAction(characteristic, key: self.aes2key ?? self.aes1key!)
          
            
            switch response {
            case .AF(let model):
                let data = DeviceStatusModel()
                data.AF = model
                self.delegate?.remotecommandState(value: .deviceStatus(data))
            default:
                break
            }
            
            
            // 根據不同action 做相對應處理
            switch action {
            case .deviceStatus:
                switch response {
                case .C0(let array):
                    keepC1Data = nil
                    self.aes2key = self.getKey2(randomNum1: c0RandomData, randomNum2: array)
                    self.data.aes2Key = self.aes2key!
                    let command = CommandService.shared.createAction(with: .C1(self.permanentToken ?? self.oneTimeToken!), key: self.aes2key!)
                    delegate?.remoteResponseData(value: command?.base64EncodedString())
                    
                case .C1(let tokenType, let tokenPermission):
                    print("🔧🔧🔧tokenType🔧🔧🔧\n \(tokenType)\n🔧🔧🔧🔧🔧🔧")
                    print("🔧🔧🔧tokenPermission🔧🔧🔧\n \(tokenPermission)\n🔧🔧🔧🔧🔧🔧")
                    
                    
                    self.data.permission = tokenPermission
                    delegate?.remoteState(State: .connected(""))
                    switch tokenType {
                    case .invalid, .reject:
                        delegate?.remoteState(State: .disconnect(.deviceRefused))
                    case .oneTimeToken:
                        break
                    case .valid:
                        // qr code 已經被用過，產生的一次性 token == 永久 token
                        self.permanentToken = self.oneTimeToken
                        self.data.permanentToken = self.oneTimeToken!
                        
                        // 保留藍芽資料
                        self.delegate?.remoteupdateData(value: self.data)
                        
                        // MQTT 可能 先回傳D6/A2 再回傳C1
                        if let data = keepC1Data {
                            self.delegate?.remotecommandState(value: .deviceStatus(data))

                        }
                    }
                    
                    
                case .D5(let bool):
                    
                    if !bool {
                        self.delegate?.remotecommandState(value: .deviceStatus(nil))
                    }
                case .A1(let bool):
                    if !bool {
                        self.delegate?.remotecommandState(value: .deviceStatus(nil))
                    }
                case .E5(let tokenModel):
                    guard let token = tokenModel.token else {
                        self.delegate?.remoteState(State: .disconnect(.fail))
                        
                        return
                    }
                    self.permanentToken = token
                    self.data.permanentToken = token
                    
                    self.data.permission = tokenModel.tokenPermission
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    
                    keepC1Data = data
                    
                    // MQTT 可能 先回傳D6/A2 再回傳C1
                    if self.permanentToken != nil , self.data.permanentToken != nil {
                        self.delegate?.remotecommandState(value: .deviceStatus(data))
                    }
                   
                case .A2(let model), .F1(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    
                    keepC1Data = data
                    // MQTT 可能 先回傳D6/A2 再回傳C1
                    if self.permanentToken != nil , self.data.permanentToken != nil {
                        self.delegate?.remotecommandState(value: .deviceStatus(data))
                    }
                 
                case .B0(let model):
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.B0 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .Z0(_):
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    // data.DeviceStatusModel00 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                    
                case .EF( _):
                    self.delegate?.remotecommandState(value: .deviceStatus(nil))
                default:
                    break
                    
                }
                
            case .config:
                switch response {
                case .D6(let model):
                    
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .D5(let bool):
                    var commandStateValue: commandState = .config(true)
                    if !bool {
                        commandStateValue = .config(false)
                    }
                    self.delegate?.remotecommandState(value: commandStateValue)
                case .A1(let bool):
                    var commandStateValue: commandState = .config(true)
                    if !bool {
                        commandStateValue = .config(false)
                    }
                    self.delegate?.remotecommandState(value: commandStateValue)
                case .EF( _):
                    self.delegate?.remotecommandState(value: .config(nil))
                default:
                    break
                }
            case .updateName:
                switch response {
                case .D6(let model):
                    
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .D1(let bool):
                    var commandStateValue: commandState = .updateName(true)
                    if !bool {
                        commandStateValue = .updateName(false)
                    }
                    self.delegate?.remotecommandState(value: commandStateValue)
                case .EF( _):
                    self.delegate?.remotecommandState(value:.updateName(nil))
                default:
                    break
                }
            case .isAdminCode:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .EF(let adminCodeMode):
                    
                    switch adminCodeMode {
                    case .setupSuccess:
                        self.delegate?.remotecommandState(value: .isAdminCode(true))
                    case .empty :
                        self.delegate?.remotecommandState(value: .isAdminCode(false))
                    default:
                        self.delegate?.remotecommandState(value: .isAdminCode(nil))
                    }
                    
                default:
                    break
                }
            case .setupAdminCode:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .C7(let bool):
                    var commandStateValue: commandState = .setupAdminCode(true)
                    if !bool {
                        commandStateValue = .setupAdminCode(false)
                    }
                    self.delegate?.remotecommandState(value: commandStateValue)
                case .EF( _):
                    self.delegate?.remotecommandState(value: .setupAdminCode(nil))
                default: break
                }
            case .editAdminCode:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .C8(let bool):
                    var commandStateValue: commandState = .editAdminCode(true)
                    if !bool {
                        commandStateValue = .editAdminCode(false)
                    }
                    self.delegate?.remotecommandState(value: commandStateValue)
                case .EF( _):
                    self.delegate?.remotecommandState(value: .editAdminCode(nil))
                default: break
                }
            case .setupTimeZone:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .D9(let bool):
                    var commandStateValue: commandState = .setupTimeZone(true)
                    if !bool {
                        commandStateValue = .setupTimeZone(false)
                    }
                    self.delegate?.remotecommandState(value: commandStateValue)
                case .EF( _):
                    self.delegate?.remotecommandState(value: .setupTimeZone(nil))
                default: break
                }
                
            case .DeviceName:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .D0(let value):
                    self.delegate?.remotecommandState(value: .DeviceName(value))
                case .EF( _):
                    self.delegate?.remotecommandState(value: .DeviceName(nil))
                default: break
                }
            case .editToken:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .E7(let bool):
                    var commandStateValue: commandState = .editToken(true)
                    if !bool {
                        commandStateValue = .editToken(false)
                    }
                    self.delegate?.remotecommandState(value: commandStateValue)
                case .EF( _):
                    self.delegate?.remotecommandState(value: .editToken(nil))
                default: break
                }
            case .deviceSetting:
                
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .D4(let model):
                    let res = DeviceSetupResultModel()
                    res.D4 = model
                    self.delegate?.remotecommandState(value: .deviceSetting(res))
                    
                case .A0(let model):
                    let res = DeviceSetupResultModel()
                    res.A0 = model
                    self.delegate?.remotecommandState(value: .deviceSetting(res))
                    
                case .EF( _):
                    self.delegate?.remotecommandState(value: .deviceSetting(nil))
                default: break
                }
                
            case .logCount:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .E0(let index):
                    self.delegate?.remotecommandState(value: .logCount(index))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .logCount(nil))
                default:
                    break
                }
            case .log:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .E1(let model):
                    self.delegate?.remotecommandState(value: .log(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .log(nil))
                default:
                    break
                }
            case .getTokenArray:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .E4(let index):
                    self.delegate?.remotecommandState(value: .getTokenArray(index))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .getTokenArray(nil))
                default:
                    break
                }
            case .getToken:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .E5(let model):
                    self.delegate?.remotecommandState(value: .getToken(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .getToken(nil))
                default:
                    break
                }
            case .createToken:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .E6(let model):
                    self.delegate?.remotecommandState(value: .createToken(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .createToken(nil))
                default:
                    break
                }
                
            case .delToken:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .E8(let bool):
                    var commandStateValue: commandState = .delToken(true)
                    if !bool {
                        commandStateValue = .delToken(false)
                    }
                    self.delegate?.remotecommandState(value: commandStateValue)
                case .EF(_):
                    self.delegate?.remotecommandState(value: .delToken(nil))
                default: break
                }
            case .getTokenQrCode:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .E5(let model):
                    let token = model.token?.toHexString() ?? ""
                    let dic = ["T": token,"K": qrcodeAes1Key,"A": qrcodeMacAddress, "F": qrcodeUserName, "L": qrcodeDeviceName, "M": qrcodeModelName]
                    let json = JSON(dic).rawString() ?? ""
                    let value = AESModel.shared.encodeBase64String(json, barcodeKey: barcodeKey) ?? ""
                    self.delegate?.remotecommandState(value: .getTokenQrCode(value))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .getTokenQrCode(nil))
                default:
                    break
                }
            case .getPinCodeArray:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .EA(let model):
                    self.delegate?.remotecommandState(value: .getPinCodeArray(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .getPinCodeArray(nil))
                default: break
                }
            case .getPinCode:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .EB(let model):
                    self.delegate?.remotecommandState(value: .getPinCode(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .getPinCode(nil))
                default: break
                }
                
            case .pinCodeoption:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .EC(let bool):
                    self.delegate?.remotecommandState(value: .pinCodeoption(bool))
                case .ED(let bool):
                    self.delegate?.remotecommandState(value: .pinCodeoption(bool))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .pinCodeoption(nil))
                default: break
                }
                
            case .delPinCode:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .EE(let bool):
                    self.delegate?.remotecommandState(value: .delPinCode(bool))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .delPinCode(nil))
                default: break
                }
                
            case .factoryReset:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .CE(let bool):
                    self.delegate?.remotecommandState(value: .factoryReset(bool))
                case .CF(let bool):
                    self.delegate?.remotecommandState(value: .factoryReset(bool))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .factoryReset(nil))
                default: break
                }
            case .supportType:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A4(let model):
                    self.delegate?.remotecommandState(value: .supportType(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .supportType(nil))
                default: break
                }
            case .accessArray:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A5(let model):
                    self.delegate?.remotecommandState(value: .accessArray(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .accessArray(nil))
                default: break
                }
            case .searchAccess:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A6(let model):
                    self.delegate?.remotecommandState(value: .searchAccess(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .searchAccess(nil))
                default: break
                }
            case .accessAction:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A7(let model):
                    self.delegate?.remotecommandState(value: .accessAction(model))
                case .A8(let model):
                    self.delegate?.remotecommandState(value: .accessAction(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .accessAction(nil))
                default: break
                }
            case .delAccess:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .AA(let model):
                    self.delegate?.remotecommandState(value: .delAccess(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .delAccess(nil))
                default: break
                }
                
            case .setupAccess:
                switch response {
                case .D6(let model):
                    commandType = .D
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    
                    let data = DeviceStatusModel()
                    data.D6 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A2(let model):
                    commandType = .A
                    // 保留藍芽資料
                    self.delegate?.remoteupdateData(value: self.data)
                    let data = DeviceStatusModel()
                    data.A2 = model
                    self.delegate?.remotecommandState(value: .deviceStatus(data))
                case .A9(let model):
                    self.delegate?.remotecommandState(value: .setupAccess(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .setupAccess(nil))
                default: break
                }
                
            case .wifiList:
                switch response {
                case .getWifiList(let model):
                    self.delegate?.remotecommandState(value: .wifiList(model))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .wifiList(nil))
                default:
                    break
                }
            case .connectWifi:
                switch response {
                case .setSSID:
                    let command =  CommandService.shared.createAction(with: .setPassword(wifiPassword), key: aes2key!)
                    self.delegate?.remoteResponseData(value: command?.base64EncodedString())
                case .setPassword:
                    let command =  CommandService.shared.createAction(with: .setConnection, key: aes2key!)
                    self.delegate?.remoteResponseData(value: command?.base64EncodedString())
                case .setConnection(let bool):
                    self.delegate?.remotecommandState(value: .connectWifi(bool))
                case .setMQTT(let bool):
                    self.delegate?.remotecommandState(value: .connectMQTT(bool))
                case .setCloud(let bool):
                    self.delegate?.remotecommandState(value: .connectClould(bool))
                case .EF(_):
                    self.delegate?.remotecommandState(value: .connectWifi(nil))
                default:
                    break
                }
                
            case .OTAStatus:
                switch response {
                case .C3(let model):
                    self.delegate?.remotecommandState(value: .OTAStatus(model))
                default:
                    break
                }
                
                
            case .OTAData:
                switch response {
                case .C4(let model):
                    self.delegate?.remotecommandState(value: .OTAData(model))
                default:
                    break
                }
                
            default:
                break
            }
        } else {
            // 转换失败
        }
        
        
    }
    
    
    
    
    
    
    
    
}
