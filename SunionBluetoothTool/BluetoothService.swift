//
//  BluetoothService.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//


import CoreBluetooth
import SwiftyJSON

protocol BluetoothServiceDelegate: AnyObject {
    func bluetoothState(State: bluetoothState)
    func commandState(value: commandState)
    func updateData(value: BluetoothToolModel)
    func debug(value: String)
}



extension BluetoothServiceDelegate {
    func commandState() {}
    func updateData() {}
}

class BluetoothService: NSObject {
    
    private let serviceUUID: [CBUUID] = [
        CBUUID(string: "fc3d8cf8-4ddc-7ade-1dd9-2497851131d7")
    ]
    
    private let notifyUUID: CBUUID = CBUUID(string: "DE915DCE-3539-61EA-ADE7-D44A2237601F")
    
    

    
    enum modelCommandType {
        case D
        case A
        case N8
    }
    
    
    weak var delegate: BluetoothServiceDelegate?
  
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var targetServices: [CBService]? = []
    var writableCharacteristic: CBCharacteristic?
    var mackAddress: String?
    var aes1key: [UInt8]?
    var aes2key: [UInt8]?
    var oneTimeToken: [UInt8]?
    var permanentToken: [UInt8]?
    let c0RandomData = CommandService.shared.fillDataLength(with: .C0(nil))
    var action: commandState = .none
    var data: BluetoothToolModel = BluetoothToolModel()
  
    var autoStartTime: Double = 0.0
    
    var qrcodeAes1Key: String = ""
    var qrcodeUserName: String = ""
    var qrcodeModelName: String = ""
    var qrcodeDeviceName: String = ""
    var qrcodeMacAddress: String = ""
    
    var barcodeKey: String = ""

   
    var commandType: modelCommandType = .A
    
    var workItem: DispatchWorkItem?
    
    var wifiPassword = ""
    
    var v3udid: String?
    
    
    init(delegate: BluetoothServiceDelegate?, mackAddress: String?, aes1Key: [UInt8], token: [UInt8], udid: String?) {
        
        super.init()
        self.mackAddress = mackAddress
        self.delegate = delegate
        self.aes1key = aes1Key
        self.oneTimeToken = token
        self.v3udid = udid
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    private func deviceTokenExchange() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        self.data.identifier = peripheral.identifier.uuidString
        print("aes1: \(aes1key?.toHexString())")
        print("aes2: \(aes2key?.toHexString())")
        let command = CommandService.shared.createAction(with: .C0(c0RandomData), key: aes1key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func disconnect() {
        if let connectedPeripheral = connectedPeripheral {
            delegate?.bluetoothState(State: .disconnect(.normal))
            self.centralManager.cancelPeripheralConnection(connectedPeripheral)
        }
    }
    
    func connectWithIdentifier(value: String) {
        
        action = .deviceStatus(nil)
        delegate?.bluetoothState(State: .connecting)
      
        if let uid = UUID(uuidString: value) {
            delegate?.debug(value: "retrievePeripherals")
            let cbs = centralManager.retrievePeripherals(withIdentifiers: [uid])

            if let first = cbs.first {
              
                delegate?.debug(value: "cbs first")
                self.autoStartTime = Date().timeIntervalSince1970
                self.connectedPeripheral = first
                delegate?.debug(value: ".connect")
                DispatchQueue.global().async {
                    self.centralManager.connect(self.connectedPeripheral!, options: nil)
                }
            }
            
            
        }

    }
    
    
    //MARK: - 連線 + 交換token
    func startConnecting() {
        // 获取当前日期和时间
        let now = Date()

        // 获取当前用户的日历
        let calendar = Calendar.current

        // 从当前日期中提取小时、分钟和秒
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        let second = calendar.component(.second, from: now)

        // 打印结果
        print("当前时间是：\(hour)时 \(minute)分 \(second)秒")
        print("🔧🔧🔧開始掃描🔧🔧🔧")

        action = .deviceStatus(nil)
        delegate?.bluetoothState(State: .connecting)
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
    
        
        workItem = DispatchWorkItem {
            if self.centralManager.isScanning {
                // Stop scanning
          
                self.centralManager.stopScan()
                
                self.delegate?.bluetoothState(State: .disconnect(.deviceRefused))
                print("Stopped scanning after 5 seconds")
            }
        }
        
        if let workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: workItem)
        }
    }
    
    //MARK: -  設定名稱
    
    func setupDeviceName(name: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .updateName(nil)
        let command = CommandService.shared.createAction(with: .D1(name), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: - 是否有AdmonCode
    func isAdminCode() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .isAdminCode(nil)
        let command = CommandService.shared.createAction(with: .EF, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: - 設定AdminCode
    func setupAdminCode(Code: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .setupAdminCode(nil)
        let adminCode = Code.compactMap{Int(String($0))}
        let command = CommandService.shared.createAction(with: .C7(adminCode), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    // MARK: - 編輯AdminCode
    func editAdminCode(oldCode: String, newCode: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .editAdminCode(nil)
        let oldDigits = oldCode.compactMap{Int(String($0))}
        let newDigits = newCode.compactMap{Int(String($0))}
        let model = EditAdminCodeModel(oldCode: oldDigits, newCode: newDigits)
        let command = CommandService.shared.createAction(with: .C8(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: - 設定TimeZone
    func setupTimeZone(timezone: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        guard let timeZone = TimeZone(identifier: timezone),
        let abbreviation = timeZone.secondsFromGMT().toString.data(using: .utf8) else { return }
        
        action = .setupTimeZone(nil)
        
        let command = CommandService.shared.createAction(with: .D9(Int32(timeZone.secondsFromGMT()), abbreviation), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    


    // MARK: - 設定DeviceTime
    func setupDeviceTime() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        let command = CommandService.shared.createAction(with: .D3(Date()), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    

    
    // MARK: - 取得DeviceName
    func getDeviceName() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .DeviceName(nil)
        let command = CommandService.shared.createAction(with: .D0, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: - 編輯Token
    func editToken(model: EditTokenModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .editToken(nil)
        let command =  CommandService.shared.createAction(with: .E7(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: - 查詢設定檔
    func getDeviceConfigKD0() {
    
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .deviceSetting(nil)
        let command =  CommandService.shared.createAction(with: .D4, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func getDeviceConfigTLR0() {
     
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .deviceSetting(nil)
        let command =  CommandService.shared.createAction(with: .A0, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func getDeviceConfig80() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .deviceSetting(nil)
        let command =  CommandService.shared.createAction(with: .N80, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: - 設定設定檔
    func setupDeviceConfig(model: DeviceSetupModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        
        action = .config(nil)
        
        let command =  CommandService.shared.createAction(with: commandType == .D ? .D5(model.D5!) : commandType == .A ? .A1(model.A1!) : .N81(model.N81!), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }

    
    // MARK: - 門向判定
    func boltCheck() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: .CC, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: - 取得裝置狀態
    func getDeviceStatus() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: commandType == .D ? .D6 : commandType == .A ? .A2: .N82, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: - 開關鎖
    func switchDevice(mode: CommandService.DeviceMode) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .deviceStatus(nil)
        
        let command =  CommandService.shared.createAction(with: commandType == .D ? .D7(mode) : commandType == .A ? .A3(.lockstate, mode, nil) : .N83(.lockstate, mode, nil), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func switchPlug(mode: CommandService.plugMode) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: .B1(mode), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func switchSecurity(mode: CommandService.SecurityboltMode?) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: .A3(.securitybolt, nil, mode), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func switch83Security(mode: CommandService.SecurityboltMode?) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: .N83(.securitybolt, nil, mode), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK:  - Log
    // count
    func getLogCount() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .logCount(nil)
        let command =  CommandService.shared.createAction(with: .E0, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }

    // data
    func getLog(count: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .log(nil)
        let command =  CommandService.shared.createAction(with: .E1(count), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    

    // MARK: - Share User
    // count
    func getTokenArray() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .getTokenArray(nil)
        let command =  CommandService.shared.createAction(with: .E4, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // data
    func getToken(position: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .getToken(nil)
        let command =  CommandService.shared.createAction(with: .E5(position), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    // create
    func createToken(model: AddTokenModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .createToken(nil)
        let command =  CommandService.shared.createAction(with: .E6(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    // delete
    func delToken(model: TokenModel, ownerPinCode: String? = nil) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .delToken(nil)
        var digit: [UInt8]?
        if let ownerPinCode = ownerPinCode {
            digit = ownerPinCode.compactMap{Int(String($0))}.map{UInt8($0)}
        }
        let command =  CommandService.shared.createAction(with: .E8(model, digit), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    // qrcode
    func getTokenQrCode(barcodeKey: String, tokenIndex: Int, aes1Key: Data, macAddress: String, userName: String, modelName: String, deviceName: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .getTokenQrCode(nil)
        qrcodeAes1Key = aes1Key.toHexString()
        qrcodeUserName = userName
        qrcodeModelName = modelName
        qrcodeDeviceName = deviceName
        qrcodeMacAddress = macAddress
        self.barcodeKey = barcodeKey
        let command =  CommandService.shared.createAction(with: .E5(tokenIndex), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }

    // MARK: - PinCode
    func getPinCodeArray() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .getPinCodeArray(nil)
        let command =  CommandService.shared.createAction(with: .EA, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func getPinCode(position: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .getPinCode(nil)
        let command =  CommandService.shared.createAction(with: .EB(position), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // add / edit
    func pinCodeOption(model: PinCodeManageModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .pinCodeoption(nil)
        let command =  CommandService.shared.createAction(with: .EC(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func delPinCode(position: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .delPinCode(nil)
        let command =  CommandService.shared.createAction(with: .EE(position), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK :- factory reset
    func factoryReset(adminCode: [Int]) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .factoryReset(nil)
        let command =  CommandService.shared.createAction(with: .CE(adminCode), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func plugFactoryReset() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .factoryReset(nil)
        let command =  CommandService.shared.createAction(with: .CF, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: TLR0
    // support type
    
    func getSupportType() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .supportType(nil)
        let command =  CommandService.shared.createAction(with: .A4, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func getAccessArray(type: CommandService.AccessTypeMode) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .accessArray(nil)
        let command =  CommandService.shared.createAction(with: .A5(type), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func searchAccess(model: SearchAccessRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .searchAccess(nil)
       
        let command =  CommandService.shared.createAction(with: .A6(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func accessAction(model: AccessRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .accessAction(nil)
        
        let command =  CommandService.shared.createAction(with: model.accessOption == .add  ? .A7(model) : .A8(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func setupAccess(model: SetupAccessRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .setupAccess(nil)
        
        let command =  CommandService.shared.createAction(with: .A9(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func delAccess(model: DelAccessRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .delAccess(nil)
        
        let command =  CommandService.shared.createAction(with: .AA(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: - Wifi
    func wifiList() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .wifiList(nil)
        let command =  CommandService.shared.createAction(with: .getWifiList, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func setSSID(SSIDName: String, password: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .connectWifi(nil)
        wifiPassword = password
        let command =  CommandService.shared.createAction(with: .setSSID(SSIDName), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func setWifiPassword() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .connectWifi(nil)
        let command =  CommandService.shared.createAction(with: .setPassword(wifiPassword), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func connectWifi() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .connectWifi(nil)
        let command =  CommandService.shared.createAction(with: .setConnection, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func wifiAutoUnlock(identity: String ) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .deviceStatus(nil)
        let command =  CommandService.shared.createAction(with: .F1(identity), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func iswifiAutoUnlock(Identity: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .connectWifi(nil)
        let command =  CommandService.shared.createAction(with: .F2(Identity), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: - OTA {
    func otaStatus(req: OTAStatusRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .OTAStatus(nil)
        let command =  CommandService.shared.createAction(with: .C3(req), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func otaData(req: OTADataRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .OTAData(nil)
        let command =  CommandService.shared.createAction(with: .C4(req), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    

    
    // MARK: - 3.0
    public func getRFVersion() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .config(nil)
        let type: RFMCURequestModel = RFMCURequestModel(type: .RF)
        
        let command =  CommandService.shared.createAction(with: .C2(type), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    // MARK: -  UserCredential
    
    func getUserCredentialArray() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .getUserCredentialArray(nil)
        let command =  CommandService.shared.createAction(with: .N90, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    
    func getUserCredential(position: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .getUserCredential(nil)
        let model = IndexUserCredentialRequestModel(index: position)
        let command =  CommandService.shared.createAction(with: .N91(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func userCredentialAction(model: UserCredentialRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .userCredentialAction(nil)
        let command =  CommandService.shared.createAction(with: .N92(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func delUserCredentialAction(model: IndexUserCredentialRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .getUserCredential(nil)
        let command =  CommandService.shared.createAction(with: .N93(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func getCredientialArray() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .getCredientialArray(nil)
        let command =  CommandService.shared.createAction(with: .N94, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func searchCredential(model: SearchCredentialRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .searchCredential(nil)
        let command =  CommandService.shared.createAction(with: .N95(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func credentialAction(model: CredentialRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .credentialAction(nil)
        let command =  CommandService.shared.createAction(with: .N96(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func setupCrential(model: SetupCredentialRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .setupCredential(nil)
        let command =  CommandService.shared.createAction(with: .N97(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func delCredential(model: IndexUserCredentialRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .delCredential(nil)
        let command =  CommandService.shared.createAction(with: .N98(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func hashUserCredential(model: HashusercredentialRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .hashUserCredential(nil)
        let command =  CommandService.shared.createAction(with: .N99(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func syncUserCredential() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .syncUserCredential(nil)
        let command =  CommandService.shared.createAction(with: .N9A, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func finishSyncData() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .finishSyncData(nil)
        let command =  CommandService.shared.createAction(with: .N9D, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func isAutoUnlock() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .isAutoUnLock(nil)
        
        let command =  CommandService.shared.createAction(with:  .N84(.lockstate, CommandService.DeviceMode.unlock, nil), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func userAble() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .userAble(nil)
        
        let command =  CommandService.shared.createAction(with:  .N85, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func isMatter() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .isMatter(nil)
        
        let command =  CommandService.shared.createAction(with:  .N87, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func getUserSupportedCount() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .userSupportedCount(nil)
        
        let command =  CommandService.shared.createAction(with:  .N86, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
 
    
        
    
    

}

extension BluetoothService: CBCentralManagerDelegate {
    
    // step 1
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == .poweredOn {
            delegate?.bluetoothState(State: .enable)
        } else {
            delegate?.bluetoothState(State: .disable)
        }
    }
    
    
    
    // step 2
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
 
        if let mac = mackAddress {
            guard let name = peripheral.name else { return }
            
            let macAddressSuffix = mac.subString(start: 6, end: 11).uppercased()
            if name.hasPrefix("BT_Lock") || name.hasPrefix("Gateway_"),
               name.lockNameToMacAddress.uppercased().hasSuffix(macAddressSuffix) {
                print("🔧🔧🔧找到裝置🔧🔧🔧 \n \(name) \n🔧🔧🔧🔧🔧🔧")
                self.data.bleName = name
                self.data.identifier = peripheral.identifier.uuidString
                self.delegate?.updateData(value: self.data)
                connectedPeripheral = peripheral
                DispatchQueue.global().async {
                    self.centralManager.connect(self.connectedPeripheral!, options: nil)
                }
            }
        }
        
        if let udid = v3udid,
            let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data ,
           manufacturerData.starts(with: [0xE3, 0x0C]) {
            let range = 2..<10
            let uuidData = manufacturerData.subdata(in: range)
        
            // 與udid 一樣的裝置
            if uuidData.toHexString().lowercased() == udid.lowercased() {
                print("🔧🔧🔧找到V3裝置🔧🔧🔧 \n \(udid) \n🔧🔧🔧🔧🔧🔧")
                self.data.identifier = peripheral.identifier.uuidString
                self.delegate?.updateData(value: self.data)
                connectedPeripheral = peripheral
                
                
                DispatchQueue.global().async {
                    self.centralManager.connect(self.connectedPeripheral!, options: nil)
                }
            }
            
        }
        
        workItem = DispatchWorkItem {
            if self.centralManager.isScanning {
                // Stop scanning
          
                self.centralManager.stopScan()
                
                self.delegate?.bluetoothState(State: .disconnect(.deviceRefused))
                print("Stopped scanning after 5 seconds")
            }
        }
        
        if let workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: workItem)
        }
        
     
        
    }

    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect: \(peripheral.name)")
        if let name = peripheral.name {
            delegate?.bluetoothState(State: .connected(name))
        } else {
            delegate?.bluetoothState(State: .connected("v3"))
        }
  
        connectedPeripheral = peripheral
        connectedPeripheral?.delegate = self
        
        workItem?.cancel()
        workItem = nil
        centralManager.stopScan()
        peripheral.discoverServices(nil)
 
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.debug(value: "didDisconnectPeripheral")
        print("🔧🔧🔧didDisconnectPeripheral error🔧🔧🔧\n \(error.debugDescription) \n🔧🔧🔧🔧🔧🔧")
        if error != nil  {
            delegate?.bluetoothState(State: .disconnect(.fail))
        }

    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("🔧🔧🔧didFailToConnect🔧🔧🔧")
        delegate?.bluetoothState(State: .disconnect(.fail))
    }
    

    

    
    
    
}

extension BluetoothService: CBPeripheralDelegate {
    // setp 1
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("didDiscoverServices")
        
        if (error != nil) {
            
            delegate?.bluetoothState(State: .disconnect(.discoverServices(error.debugDescription)))
            return
        }
        
        guard let services = peripheral.services else {
            delegate?.bluetoothState(State: .disconnect(.discoverServices(nil)))
            return
        }
        
        let info = services.first { service in
            return service.uuid.uuidString == "180A"
        }
        
     
        for service in services {
            print(service)
        }
        
        let custom = services.first { service in
            
            return service.uuid.uuidString == serviceUUID.first?.uuidString
        }
      
     

        // [Device Information, customserviceUUID]
        targetServices = [ info!, custom!]
       
        // Device Information -> get firewareVersion
        let service = self.data.FirmwareVersion == nil ? targetServices?.first : targetServices?.last
      
        peripheral.discoverCharacteristics(nil, for: service!)

    }
    
    // step 2
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("didDiscoverCharacteristicsFor")
        guard let characteristics = service.characteristics else {
            delegate?.bluetoothState(State: .disconnect(.discoverCharacteristics))
            return
        }
        

        
        
        for characteristic in characteristics {
            print(characteristic)
       
            
            let propertie = characteristic.properties
            
            if propertie.contains(.notify), characteristic.uuid == notifyUUID {
                print("setNotifyValue: \(characteristic)")
                peripheral.setNotifyValue(true, for: characteristic)
                
            }
            
            if propertie.contains(.write)  || propertie.contains(.writeWithoutResponse){
         
                
            }
            
            if propertie.contains(.writeWithoutResponse), characteristic.uuid == notifyUUID {
         
                writableCharacteristic = characteristic
            }
            
            
            
            if propertie.contains(.read) {
               
                if characteristic.uuid.uuidString == "2A26" {
                    peripheral.readValue(for: characteristic)
                    
                }
            }
            
        }
    }
    
    // step 4
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("🔧🔧🔧通知註冊成功🔧🔧🔧\n \(characteristic)\n🔧🔧🔧🔧🔧🔧")
        deviceTokenExchange()
        
    }
    
    
    // step 5
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        print("🔧🔧🔧BLE RESPONSE🔧🔧🔧")
        print("action: \(action)")
        print("value: \(String(data: characteristic.value!, encoding: .utf8))")
        print("🔧🔧🔧🔧🔧🔧")
        // get Firmware version
        if self.data.FirmwareVersion == nil {
           
  
            let str = String(data: characteristic.value!, encoding: .utf8)
            self.data.FirmwareVersion = str
            print("🔧🔧🔧FirmwareVersion🔧🔧🔧\n \(str)\n🔧🔧🔧🔧🔧🔧")
        
            self.connectedPeripheral!.discoverCharacteristics(nil, for: self.targetServices!.last!)
            return
        }
        
        
        
        let response = CommandService.shared.resolveAction(characteristic, key: self.aes2key ?? self.aes1key!)
        
        // 錯誤處理
        switch response {
        case .error(_):
            self.delegate?.bluetoothState(State: .disconnect(.fail))
            self.centralManager.cancelPeripheralConnection(self.connectedPeripheral!)
        default:
            break
        }
        
        switch response {
        case .AF(let model):
            let data = DeviceStatusModel()
            data.AF = model
            self.delegate?.commandState(value: .deviceStatus(data))
        default:
            break
        }
        
        // 共同處理
        
        switch response {
        case .D6(let model):
            commandType = .D
            // 保留藍芽資料
            self.delegate?.updateData(value: self.data)
            
            let data = DeviceStatusModel()
            data.D6 = model
            self.delegate?.commandState(value: .deviceStatus(data))
        case .A2(let model), .F1(let model):
            commandType = .A
            // 保留藍芽資料
            self.delegate?.updateData(value: self.data)
            let data = DeviceStatusModel()
            data.A2 = model
            self.delegate?.commandState(value: .deviceStatus(data))
            
        case .N82(let model):
            commandType = .N8
            self.delegate?.updateData(value: self.data)
            let data = DeviceStatusModel()
            data.N82 = model
            self.delegate?.commandState(value: .deviceStatus(data))
            
        default:
            break
        }
        
        
        // 根據不同action 做相對應處理
        switch action {
        case .deviceStatus:
            switch response {
            case .C0(let array):
                self.aes2key = self.getKey2(randomNum1: c0RandomData, randomNum2: array)
                self.data.aes2Key = self.aes2key!
                let command = CommandService.shared.createAction(with: .C1(self.permanentToken ?? self.oneTimeToken!), key: self.aes2key!)
                guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
                    self.delegate?.bluetoothState(State: .disconnect(.fail))
                    return
                }
                peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
            case .C1(let tokenType, let tokenPermission):
                print("🔧🔧🔧tokenType🔧🔧🔧\n \(tokenType)\n🔧🔧🔧🔧🔧🔧")
                print("🔧🔧🔧tokenPermission🔧🔧🔧\n \(tokenPermission)\n🔧🔧🔧🔧🔧🔧")
                guard let peripheral = connectedPeripheral else {
                    self.delegate?.bluetoothState(State: .disconnect(.fail))
                    return
                }
                if tokenPermission == .none || tokenPermission == .error {
                    self.delegate?.bluetoothState(State: .disconnect(.illegalToken))
                    return
                }
            
                self.data.permission = tokenPermission
               
                switch tokenType {
                case .invalid, .reject:
                    delegate?.bluetoothState(State: .disconnect(.deviceRefused))
                    self.centralManager.cancelPeripheralConnection(peripheral)
                case .oneTimeToken:
                    break
                case .valid:
                    // qr code 已經被用過，產生的一次性 token == 永久 token
                    self.permanentToken = self.oneTimeToken
                    self.data.permanentToken = self.oneTimeToken!
                }
                

            case .D5(let bool):
                
                if !bool {
                    self.delegate?.commandState(value: .deviceStatus(nil))
                }
            case .A1(let bool):
                if !bool {
                    self.delegate?.commandState(value: .deviceStatus(nil))
                }
            case .N81(let model):
                if !model.isSuccess {
                    self.delegate?.commandState(value: .deviceStatus(nil))
                }
            case .E5(let tokenModel):
                guard let token = tokenModel.token else {
                    self.delegate?.bluetoothState(State: .disconnect(.fail))
                    self.centralManager.cancelPeripheralConnection(self.connectedPeripheral!)
                    return
                }
                self.permanentToken = token
                self.data.permanentToken = token
   
                self.data.permission = tokenModel.tokenPermission

      
            case .B0(let model):
                // 保留藍芽資料
                self.delegate?.updateData(value: self.data)
                let data = DeviceStatusModel()
                data.B0 = model
                self.delegate?.commandState(value: .deviceStatus(data))
  
            case .EF( _):
                self.delegate?.commandState(value: .deviceStatus(nil))
            default:
                break
                
            }
     
        case .config:
            switch response {
            case .D5(let bool):
                var commandStateValue: commandState = .config(true)
                if !bool {
                    commandStateValue = .config(false)
                }
                self.delegate?.commandState(value: commandStateValue)
            case .A1(let bool):
                var commandStateValue: commandState = .config(true)
                if !bool {
                    commandStateValue = .config(false)
                }
                self.delegate?.commandState(value: commandStateValue)
            case .N81(let model):
                var commandStateValue: commandState = .config(true)
                if !model.isSuccess {
                    commandStateValue = .config(false)
                }
                self.delegate?.commandState(value: commandStateValue)
            case .C2(let model):
                self.data.RFVersion = model.version
            case .EF( _):
                self.delegate?.commandState(value: .config(nil))
            default:
                break
            }
        case .updateName:
            switch response {
            case .D1(let bool):
                var commandStateValue: commandState = .updateName(true)
                if !bool {
                    commandStateValue = .updateName(false)
                }
                self.delegate?.commandState(value: commandStateValue)
            case .EF( _):
                self.delegate?.commandState(value:.updateName(nil))
            default:
                break
            }
        case .isAdminCode:
            switch response {
            case .EF(let adminCodeMode):
                
                switch adminCodeMode {
                case .setupSuccess:
                    self.delegate?.commandState(value: .isAdminCode(true))
                case .empty :
                    self.delegate?.commandState(value: .isAdminCode(false))
                default:
                    self.delegate?.commandState(value: .isAdminCode(nil))
                }
            
            default:
                break
            }
        case .setupAdminCode:
            switch response {
            case .C7(let bool):
                var commandStateValue: commandState = .setupAdminCode(true)
                if !bool {
                    commandStateValue = .setupAdminCode(false)
                }
                self.delegate?.commandState(value: commandStateValue)
            case .EF( _):
                self.delegate?.commandState(value: .setupAdminCode(nil))
            default: break
            }
        case .editAdminCode:
            switch response {
            case .C8(let bool):
                var commandStateValue: commandState = .editAdminCode(true)
                if !bool {
                    commandStateValue = .editAdminCode(false)
                }
                self.delegate?.commandState(value: commandStateValue)
            case .EF( _):
                self.delegate?.commandState(value: .editAdminCode(nil))
            default: break
            }
        case .setupTimeZone:
            switch response {
            case .D9(let bool):
                var commandStateValue: commandState = .setupTimeZone(true)
                if !bool {
                    commandStateValue = .setupTimeZone(false)
                }
                self.delegate?.commandState(value: commandStateValue)
            case .EF( _):
                self.delegate?.commandState(value: .setupTimeZone(nil))
            default: break
            }

        case .DeviceName:
            switch response {
            case .D0(let value):
                self.delegate?.commandState(value: .DeviceName(value))
            case .EF( _):
                self.delegate?.commandState(value: .DeviceName(nil))
            default: break
            }
        case .editToken:
            switch response {
            case .E7(let bool):
                var commandStateValue: commandState = .editToken(true)
                if !bool {
                    commandStateValue = .editToken(false)
                }
                self.delegate?.commandState(value: commandStateValue)
            case .EF( _):
                self.delegate?.commandState(value: .editToken(nil))
            default: break
            }
        case .deviceSetting:
            
            switch response {
            case .D4(let model):
                let res = DeviceSetupResultModel()
                res.D4 = model
                self.delegate?.commandState(value: .deviceSetting(res))
   
            case .A0(let model):
                let res = DeviceSetupResultModel()
                res.A0 = model
                self.delegate?.commandState(value: .deviceSetting(res))
            
            case .N80(let model):
                let res = DeviceSetupResultModel()
                res.N80 = model
                self.delegate?.commandState(value: .deviceSetting(res))
            case .EF( _):
                self.delegate?.commandState(value: .deviceSetting(nil))
            default: break
            }
            
        case .logCount:
            switch response {
            case .E0(let index):
                self.delegate?.commandState(value: .logCount(index))
            case .EF(_):
                self.delegate?.commandState(value: .logCount(nil))
            default:
                break
            }
        case .log:
            switch response {
            case .E1(let model):
                self.delegate?.commandState(value: .log(model))
            case .EF(_):
                self.delegate?.commandState(value: .log(nil))
            default:
                break
            }
        case .getTokenArray:
            switch response {
            case .E4(let index):
                self.delegate?.commandState(value: .getTokenArray(index))
            case .EF(_):
                self.delegate?.commandState(value: .getTokenArray(nil))
            default:
                break
            }
        case .getToken:
            switch response {
            case .E5(let model):
                self.delegate?.commandState(value: .getToken(model))
            case .EF(_):
                self.delegate?.commandState(value: .getToken(nil))
            default:
                break
            }
        case .createToken:
            switch response {
            case .E6(let model):
                self.delegate?.commandState(value: .createToken(model))
            case .EF(_):
                self.delegate?.commandState(value: .createToken(nil))
            default:
                break
            }
            
        case .delToken:
            switch response {
            case .E8(let bool):
                var commandStateValue: commandState = .delToken(true)
                if !bool {
                    commandStateValue = .delToken(false)
                }
                self.delegate?.commandState(value: commandStateValue)
            case .EF(_):
                self.delegate?.commandState(value: .delToken(nil))
            default: break
            }
        case .getTokenQrCode:
            switch response {
            case .E5(let model):
                let token = model.token?.toHexString() ?? ""
                let dic = ["T": token,"K": qrcodeAes1Key,"A": qrcodeMacAddress, "F": qrcodeUserName, "L": qrcodeDeviceName, "M": qrcodeModelName]
                let json = JSON(dic).rawString() ?? ""
                let value = AESModel.shared.encodeBase64String(json, barcodeKey: barcodeKey) ?? ""
                self.delegate?.commandState(value: .getTokenQrCode(value))
            case .EF(_):
                self.delegate?.commandState(value: .getTokenQrCode(nil))
            default:
                break
            }
        case .getPinCodeArray:
            switch response {
          
      
            case .EA(let model):
                self.delegate?.commandState(value: .getPinCodeArray(model))
            case .EF(_):
                self.delegate?.commandState(value: .getPinCodeArray(nil))
            default: break
            }
        case .getPinCode:
            switch response {
        
         
            case .EB(let model):
                self.delegate?.commandState(value: .getPinCode(model))
            case .EF(_):
                self.delegate?.commandState(value: .getPinCode(nil))
            default: break
            }
            
        case .pinCodeoption:
            switch response {
     
        
            case .EC(let bool):
                self.delegate?.commandState(value: .pinCodeoption(bool))
            case .ED(let bool):
                self.delegate?.commandState(value: .pinCodeoption(bool))
            case .EF(_):
                self.delegate?.commandState(value: .pinCodeoption(nil))
            default: break
            }
            
        case .delPinCode:
            switch response {
         
 
            case .EE(let bool):
                self.delegate?.commandState(value: .delPinCode(bool))
            case .EF(_):
                self.delegate?.commandState(value: .delPinCode(nil))
            default: break
            }
            
        case .factoryReset:
            switch response {
    
         
            case .CE(let bool):
                self.delegate?.commandState(value: .factoryReset(bool))
            case .CF(let bool):
                self.delegate?.commandState(value: .factoryReset(bool))
            case .EF(_):
                self.delegate?.commandState(value: .factoryReset(nil))
            default: break
            }
        case .supportType:
            switch response {
          
      
            case .A4(let model):
                self.delegate?.commandState(value: .supportType(model))
            case .EF(_):
                self.delegate?.commandState(value: .supportType(nil))
            default: break
            }
        case .accessArray:
            switch response {
 
     
            case .A5(let model):
                self.delegate?.commandState(value: .accessArray(model))
            case .EF(_):
                self.delegate?.commandState(value: .accessArray(nil))
            default: break
            }
        case .searchAccess:
            switch response {
       
           
            case .A6(let model):
                self.delegate?.commandState(value: .searchAccess(model))
            case .EF(_):
                self.delegate?.commandState(value: .searchAccess(nil))
            default: break
            }
        case .accessAction:
            switch response {
       
            case .A7(let model):
                self.delegate?.commandState(value: .accessAction(model))
            case .A8(let model):
                self.delegate?.commandState(value: .accessAction(model))
            case .EF(_):
                self.delegate?.commandState(value: .accessAction(nil))
            default: break
            }
        case .delAccess:
            switch response {
      
          
            case .AA(let model):
                self.delegate?.commandState(value: .delAccess(model))
            case .EF(_):
                self.delegate?.commandState(value: .delAccess(nil))
            default: break
            }
            
        case .setupAccess:
            switch response {
  
           
            case .A9(let model):
                self.delegate?.commandState(value: .setupAccess(model))
            case .EF(_):
                self.delegate?.commandState(value: .setupAccess(nil))
            default: break
            }
            
        case .wifiList:
            switch response {
            case .getWifiList(let model):
                self.delegate?.commandState(value: .wifiList(model))
            case .EF(_):
                self.delegate?.commandState(value: .wifiList(nil))
            default:
                break
            }
        case .connectWifi:
            switch response {
            case .setSSID:
                self.setWifiPassword()
            case .setPassword:
                self.connectWifi()
            case .setConnection(let bool):
                self.delegate?.commandState(value: .connectWifi(bool))
            case .setMQTT(let bool):
                self.delegate?.commandState(value: .connectMQTT(bool))
            case .setCloud(let bool):
                self.delegate?.commandState(value: .connectClould(bool))
            case .F2(let bool):
                self.delegate?.commandState(value: .isWifiAutonunlock(bool))
            case .EF(_):
                self.delegate?.commandState(value: .connectWifi(nil))
            default:
                break
            }

        case .OTAStatus:
            switch response {
            case .C3(let model):
                self.delegate?.commandState(value: .OTAStatus(model))
            case .EF(_):
                self.delegate?.commandState(value: .OTAStatus(nil))
            default:
                break
            }
        
            
        case .OTAData:
            switch response {
            case .C4(let model):
                self.delegate?.commandState(value: .OTAData(model))
            case .EF(_):
                self.delegate?.commandState(value: .OTAData(nil))
            default:
                break
            }
        case .getUserCredentialArray:
            switch response {
            case .N90(let model):
                self.delegate?.commandState(value: .getUserCredentialArray(model))
            case .EF(_):
                self.delegate?.commandState(value: .getUserCredentialArray(nil))
            default:
                break
            }
            
        case .getUserCredential:
            
            switch response {
            case .N91(let model):
                self.delegate?.commandState(value: .getUserCredential(model))
            case .EF(_):
                self.delegate?.commandState(value: .getUserCredential(nil))
            default:
                break
            }
            
        case .userCredentialAction:
            switch response {
            case .N92(let model):
                self.delegate?.commandState(value: .userCredentialAction(model))
            case .EF(_):
                self.delegate?.commandState(value: .userCredentialAction(nil))
            default:
                break
            }
            
        case .delUserCredential:
            switch response {
            case .N93(let model):
                self.delegate?.commandState(value: .delUserCredential(model))
            case .EF(_):
                self.delegate?.commandState(value: .delUserCredential(nil))
            default:
                break
            }
            
        case .getCredientialArray:
            switch response {
            case .N94(let model):
                self.delegate?.commandState(value: .getCredientialArray(model))
            case .EF(_):
                self.delegate?.commandState(value: .getCredientialArray(nil))
            default:
                break
            }
            
        case .searchCredential:
            switch response {
            case .N95(let model):
                self.delegate?.commandState(value: .searchCredential(model))
            case .EF(_):
                self.delegate?.commandState(value: .searchCredential(nil))
            default:
                break
            }
            
        case .credentialAction:
            switch response {
            case .N96(let model):
                self.delegate?.commandState(value: .credentialAction(model))
            case .EF(_):
                self.delegate?.commandState(value: .credentialAction(nil))
            default:
                break
            }
        case .setupCredential:
            switch response {
            case .N97(let model):
                self.delegate?.commandState(value: .setupCredential(model))
            case .EF(_):
                self.delegate?.commandState(value: .setupCredential(nil))
            default:
                break
            }
            
        case .delCredential:
            switch response {
            case .N98(let model):
                self.delegate?.commandState(value: .delCredential(model))
            case .EF(_):
                self.delegate?.commandState(value: .delCredential(nil))
            default:
                break
            }
            
        case .hashUserCredential:
            switch response {
            case .N99(let model):
                self.delegate?.commandState(value: .hashUserCredential(model))
            case .EF(_):
                self.delegate?.commandState(value: .hashUserCredential(nil))
            default:
                break
            }
            
        case .syncUserCredential:
            switch response {
            case .N9A(let model):
                self.delegate?.commandState(value: .syncUserCredential(model))
            case .EF(_):
                self.delegate?.commandState(value: .syncUserCredential(nil))
            default:
                break
            }
        case .finishSyncData:
            switch response {
            case .N9D(let model):
                self.delegate?.commandState(value: .finishSyncData(model))
            case .EF(_):
                self.delegate?.commandState(value: .finishSyncData(nil))
            default:
                break
            }
            
        case .isAutoUnLock:
            switch response {
            case .N84(let model):
                self.delegate?.commandState(value: .isAutoUnLock(model))
            case .EF(_):
                self.delegate?.commandState(value: .isAutoUnLock(nil))
            default:
                break
            }
        case .userAble:
            switch response {
            case .N85(let model):
                self.delegate?.commandState(value: .userAble(model))
            case .EF(_):
                self.delegate?.commandState(value: .userAble(nil))
            default:
                break
            }
            
        case .isMatter:
            switch response {
            case .N87(let model):
                self.delegate?.commandState(value: .isMatter(model))
            case .EF(_):
                self.delegate?.commandState(value: .isMatter(nil))
            default:
                break
            }
        case .userSupportedCount:
            switch response {
            case .N86(let model):
                self.delegate?.commandState(value: .userSupportedCount(model))
            case .EF(_):
                self.delegate?.commandState(value: .userSupportedCount(nil))
            default:
                break
            }
            
        // MARK: - V3
        case .v3deviceStatus:
            switch response {
            case .N82(let model):
                self.delegate?.commandState(value: .v3deviceStatus(model))
            case .EF(_):
                self.delegate?.commandState(value: .v3deviceStatus(nil))
            default:
                break
            }
            
        case .v3time:
            
            switch response {
            case .D3(let model):
                self.delegate?.commandState(value: .v3time(model))
            case .D9(let model):
                self.delegate?.commandState(value: .v3time(model))
            case .EF(_):
                self.delegate?.commandState(value: .v3time(nil))
            default:
                break
            }
            
        case .v3Name:
            switch response {
            case .D0(let model):
                let res = resNameUseCase()
                res.data = model
                self.delegate?.commandState(value: .v3Name(res))
            case .D1(let model):
                let res = resNameUseCase()
                res.set = model
                self.delegate?.commandState(value: .v3Name(res))
            case .EF(_):
                self.delegate?.commandState(value: .v3Name(nil))
            default:
                break
            }
            
        case .v3Direction:
            switch response {
            case .N82(let model):
                self.delegate?.commandState(value: .v3Direction(model))
            case .EF(_):
                self.delegate?.commandState(value: .v3Direction(nil))
            default:
                break
            }
          
        default:
            break
        }

    }
    
    
    
    private func getKey2(randomNum1: [UInt8], randomNum2: [UInt8]) -> [UInt8] {
        
        let last = randomNum1.count - 1
        let random1 = Array(randomNum1[2...last])
        let random2 = randomNum2
        let key2 = random1.enumerated().map { $0.element ^ random2[$0.offset] }
        return key2
    }
    
}




