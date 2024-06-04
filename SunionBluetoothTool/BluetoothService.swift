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
    var qrcodeuuid: String = ""
    
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
           
            let cbs = centralManager.retrievePeripherals(withIdentifiers: [uid])

            if let first = cbs.first {
              
              
                self.autoStartTime = Date().timeIntervalSince1970
                self.connectedPeripheral = first
         
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
        
        let command =  CommandService.shared.createAction(with: commandType == .D ? .D5(model.D5!) :  .A1(model.A1!), key: aes2key!)
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
    func getTokenQrCode(barcodeKey: String, tokenIndex: Int, aes1Key: Data, macAddress: String?, uuid: String?, userName: String, modelName: String, deviceName: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .getTokenQrCode(nil)
        qrcodeAes1Key = aes1Key.toHexString()
        qrcodeUserName = userName
        qrcodeModelName = modelName
        qrcodeDeviceName = deviceName
        qrcodeMacAddress = macAddress ?? ""
        qrcodeuuid = uuid ?? ""
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
        
        

        
        
        if let mac = mackAddress, mac != "" {
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
            print("manu uuidData: \(uuidData.toHexString())")
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
            var res = resUtilityUseCase()
            res.alert = model
            self.delegate?.commandState(value: .v3utility(res))
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
        case .A2(let model):
            commandType = .A
            // 保留藍芽資料
            self.delegate?.updateData(value: self.data)
            let data = DeviceStatusModel()
            data.A2 = model
            self.delegate?.commandState(value: .deviceStatus(data))
            // deviceStatus\direction
        case .N82(let model):
            // 保留藍芽資料
            self.delegate?.updateData(value: self.data)
            self.delegate?.commandState(value: .v3deviceStatus(model))
        case .B0(let model):
            // 保留藍芽資料
            self.delegate?.updateData(value: self.data)
            self.delegate?.commandState(value: .v3Plug(model))
            // time
        case .D3(let model):
            let res = resTimeUseCase()
            res.isSavedTime = model
            self.delegate?.commandState(value: .v3time(res))
        case .D9(let model):
            let res = resTimeUseCase()
            res.isSavedTimeZone = model
            self.delegate?.commandState(value: .v3time(res))
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
            case .N8B(let tokenModel):
                guard let token = tokenModel.token else {
                    self.delegate?.bluetoothState(State: .disconnect(.fail))
                    self.centralManager.cancelPeripheralConnection(self.connectedPeripheral!)
                    return
                }
                self.permanentToken = token
                self.data.permanentToken = token
   
                self.data.permission = tokenModel.tokenPermission
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
            case .EF(let bool):
                self.delegate?.commandState(value: .isAdminCode(bool))
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
                let dic = ["T": token,"K": qrcodeAes1Key,"A": qrcodeMacAddress, "F": qrcodeUserName, "L": qrcodeDeviceName, "M": qrcodeModelName, "U": qrcodeuuid]
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
            

        default:
            break
        }
        
        // MARK: - V3
        switch action {
        case .v3adminExist:
            switch response {
            case .EF(let model):
                let res = resAdminCodeUseCase()
                res.isExisted = model
                self.delegate?.commandState(value: .v3adminCode(res))
            default:
                break
            }
        case .v3:
            
            switch response {
   
                // admincode
            case .C7(let model):
                let res = resAdminCodeUseCase()
                res.isCreated = model
                self.delegate?.commandState(value: .v3adminCode(res))
            case .C8(let model):
                let res = resAdminCodeUseCase()
                res.isEdited = model
                self.delegate?.commandState(value: .v3adminCode(res))
                // name
            case .D0(let model):
                let res = resNameUseCase()
                res.data = model
                self.delegate?.commandState(value: .v3Name(res))
            case .D1(let model):
                let res = resNameUseCase()
                res.isConfigured = model
                self.delegate?.commandState(value: .v3Name(res))
                // config
            case .N80(let model):
                let res  = resConfigUseCase()
                res.data = model
                self.delegate?.commandState(value: .v3Config(res))
            case .N81(let model):
                let res =  resConfigUseCase()
                res.isConfigured = model.isSuccess
                self.delegate?.commandState(value: .v3Config(res))
                // utility
            case .C2(let model):
                let res  = resUtilityUseCase()
                res.version = model
                self.delegate?.commandState(value: .v3utility(res))
            case .CE(let model):
                let res  = resUtilityUseCase()
                res.isFactoryReset = model
                self.delegate?.commandState(value: .v3utility(res))
            case .CF(let model):
                let res  = resUtilityUseCase()
                res.isPlugFactoryReset = model
                self.delegate?.commandState(value: .v3utility(res))
            case .N87(let model):
                let res  = resUtilityUseCase()
                res.isMatter = model
                self.delegate?.commandState(value: .v3utility(res))
                // token
            case .N8A(let model):
                let res  = resTokenUseCase()
                res.array = model
                self.delegate?.commandState(value: .v3Token(res))
            case .N8B(let model):
                
                if qrcodeAes1Key != "" {
                    let token = model.token?.toHexString() ?? ""
                    let dic = ["T": token,"K": qrcodeAes1Key,"A": qrcodeMacAddress, "F": qrcodeUserName, "L": qrcodeDeviceName, "M": qrcodeModelName, "U": qrcodeuuid]
                    let json = JSON(dic).rawString() ?? ""
                    let value = AESModel.shared.encodeBase64String(json, barcodeKey: barcodeKey) ?? ""
                    
                    qrcodeAes1Key = ""
                    qrcodeUserName = ""
                    qrcodeModelName = ""
                    qrcodeDeviceName = ""
                    qrcodeMacAddress =  ""
                    qrcodeuuid = ""
                    barcodeKey = ""

                    self.delegate?.commandState(value: .getTokenQrCode(value))
                } else {
                    let res  = resTokenUseCase()
                    res.data = model
                    self.delegate?.commandState(value: .v3Token(res))
                }
              
            case .N8C(let model):
                let res  = resTokenUseCase()
                res.created = model
                self.delegate?.commandState(value: .v3Token(res))
            case .N8D(let model):
                let res  = resTokenUseCase()
                res.isEdited = model
                self.delegate?.commandState(value: .v3Token(res))
            case .N8E(let model):
                let res = resTokenUseCase()
                res.isDeleted = model
                self.delegate?.commandState(value: .v3Token(res))
                // log
            case .E0(let model):
                let res  = resLogUseCase()
                res.count = model
                self.delegate?.commandState(value: .v3Log(res))
            case .E1(let model):
                let res  = resLogUseCase()
                res.data = model
                self.delegate?.commandState(value: .v3Log(res))
                // wifi
            case .getWifiList(let model):
                let res = resWifiUseCase()
                res.list = model
                self.delegate?.commandState(value: .v3Wifi(res))
            case .setSSID:
                self.V3setWifiPassword()
            case .setPassword:
                self.V3connectWifi()
            case .setConnection(let bool):
                let res = resWifiUseCase()
                res.isWifi = bool
                self.delegate?.commandState(value: .v3Wifi(res))
            case .setMQTT(let bool):
                let res = resWifiUseCase()
                res.isMQTT = bool
                self.delegate?.commandState(value: .v3Wifi(res))
            case .setCloud(let bool):
                let res = resWifiUseCase()
                res.isClould = bool
                self.delegate?.commandState(value: .v3Wifi(res))
            case .F3(let model):
                self.delegate?.updateData(value: self.data)
                let res = resWifiUseCase()
                res.status = model
                self.delegate?.commandState(value: .v3Wifi(res))
            case .F4(let bool):
                let res = resWifiUseCase()
                res.isAutoUnlock = bool
                self.delegate?.commandState(value: .v3Wifi(res))
                // plug
         
            case .B1(let model):
                self.delegate?.commandState(value: .v3Plug(model))
                // ota
            case .C3(let model):
                let res = resOTAUseCase()
                res.status = model
                self.delegate?.commandState(value: .v3OTA(res))
            case .C4(let model):
                let res = resOTAUseCase()
                res.data = model
                self.delegate?.commandState(value: .v3OTA(res))
                // user
            case .N85(let model):
                let res = resUserUseCase()
                res.able = model
                self.delegate?.commandState(value: .v3User(res))
            case .N86(let model):
                let res = resUserUseCase()
                res.supportedCounts = model
                self.delegate?.commandState(value: .v3User(res))
            case .N90(let model):
                let res = resUserUseCase()
                res.array = model
                self.delegate?.commandState(value: .v3User(res))
            case .N91(let model):
                let res = resUserUseCase()
                res.data = model
                self.delegate?.commandState(value: .v3User(res))
            case .N92(let model):
                let res = resUserUseCase()
                res.isCreatedorEdited = model.isSuccess
                self.delegate?.commandState(value: .v3User(res))
            case .N93(let model):
                let res = resUserUseCase()
                res.isDeleted = model.isSuccess
                self.delegate?.commandState(value: .v3User(res))
            case .N94(let model):
                let res = resCredentialUseCase()
                res.array = model
                self.delegate?.commandState(value: .v3Credential(res))
            case .N95(let model):
                let res = resCredentialUseCase()
                res.data = model
                self.delegate?.commandState(value: .v3Credential(res))
            case .N96(let model):
                let res = resCredentialUseCase()
                res.isCreatedorEdited = model.isSuccess
                self.delegate?.commandState(value: .v3Credential(res))
            case .N97(let model):
                let res = resCredentialUseCase()
                res.setup = model
                self.delegate?.commandState(value: .v3Credential(res))
            case .N98(let model):
                let res = resCredentialUseCase()
                res.isDeleted = model.isSuccess
                self.delegate?.commandState(value: .v3Credential(res))
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




