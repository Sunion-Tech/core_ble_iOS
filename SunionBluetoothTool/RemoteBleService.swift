//
//  RemoteBleService.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/11/23.
//

import Foundation


protocol RemoteBleServiceDelegate: AnyObject {
 
    func remotecommandState(value: commandState)
    func remoteupdateData(value: BluetoothToolModel)
    func remotedebug(value: String)
}

extension RemoteBleServiceDelegate {
    func remotecommandState() {}
    func remomteupdateData() {}
}


class RemoteBleService: NSObject {
    
    weak var delegate: RemoteBleServiceDelegate?
    
    var mackAddress: String?
    var aes1key: [UInt8]?
    var aes2key: [UInt8]?
    var oneTimeToken: [UInt8]?
    var permanentToken: [UInt8]?
    
    var data: BluetoothToolModel = BluetoothToolModel()
    
    var action: commandState = .none
    let c0RandomData = CommandService.shared.fillDataLength(with: .C0(nil))
    
    
    init( delegate: RemoteBleServiceDelegate?, mackAddress: String, aes1Key: [UInt8], token: [UInt8]) {
        
        super.init()
        self.mackAddress = mackAddress
        self.delegate = delegate
        self.aes1key = aes1Key
        self.oneTimeToken = token
        

    }
    
    // MARK: - C0
    func deviceTokenExchange() -> String? {
        print("aes1: \(aes1key?.toHexString())")
        print("aes2: \(aes2key?.toHexString())")
        let command = CommandService.shared.createAction(with: .C0(c0RandomData), key: aes1key!)
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
            
            print("💞💞💞responseData💞💞💞")
            print("\(response)")
            print("💞💞💞💞💞💞")
            // 根據不同action 做相對應處理
//            switch action {
//            case .deviceStatus:
//                switch response {
//                case .C0(let array):
//                    self.aes2key = self.getKey2(randomNum1: c0RandomData, randomNum2: array)
//                    self.data.aes2Key = self.aes2key!
//                    let command = CommandService.shared.createAction(with: .C1(self.permanentToken ?? self.oneTimeToken!), key: self.aes2key!)
//
//                    peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
//                case .C1(let tokenType, let tokenPermission):
//                    print("🔧🔧🔧tokenType🔧🔧🔧\n \(tokenType)\n🔧🔧🔧🔧🔧🔧")
//                    print("🔧🔧🔧tokenPermission🔧🔧🔧\n \(tokenPermission)\n🔧🔧🔧🔧🔧🔧")
//                    guard let peripheral = connectedPeripheral else {
//                        self.delegate?.bluetoothState(State: .disconnect(.fail))
//                        return
//                    }
//                    if tokenPermission == .none || tokenPermission == .error {
//                        self.delegate?.bluetoothState(State: .disconnect(.illegalToken))
//                        return
//                    }
//                
//                    self.data.permission = tokenPermission
//                   
//                    switch tokenType {
//                    case .invalid, .reject:
//                        delegate?.bluetoothState(State: .disconnect(.deviceRefused))
//                        self.centralManager.cancelPeripheralConnection(peripheral)
//                    case .oneTimeToken:
//                        break
//                    case .valid:
//                        // qr code 已經被用過，產生的一次性 token == 永久 token
//                        self.permanentToken = self.oneTimeToken
//                        self.data.permanentToken = self.oneTimeToken!
//                    }
//                    
//
//                case .D5(let bool):
//                    
//                    if !bool {
//                        self.delegate?.commandState(value: .deviceStatus(nil))
//                    }
//                case .A1(let bool):
//                    if !bool {
//                        self.delegate?.commandState(value: .deviceStatus(nil))
//                    }
//                case .E5(let tokenModel):
//                    guard let token = tokenModel.token else {
//                        self.delegate?.bluetoothState(State: .disconnect(.fail))
//                        self.centralManager.cancelPeripheralConnection(self.connectedPeripheral!)
//                        return
//                    }
//                    self.permanentToken = token
//                    self.data.permanentToken = token
//       
//                    self.data.permission = tokenModel.tokenPermission
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model), .F1(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .B0(let model):
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.B0 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .Z0(_):
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//               
//                    let data = DeviceStatusModel()
//                   // data.DeviceStatusModel00 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//      
//                case .EF( _):
//                    self.delegate?.commandState(value: .deviceStatus(nil))
//                default:
//                    break
//                    
//                }
//         
//            case .config:
//                switch response {
//                case .D6(let model):
//                
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//              
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .D5(let bool):
//                    var commandStateValue: commandState = .config(true)
//                    if !bool {
//                        commandStateValue = .config(false)
//                    }
//                    self.delegate?.commandState(value: commandStateValue)
//                case .A1(let bool):
//                    var commandStateValue: commandState = .config(true)
//                    if !bool {
//                        commandStateValue = .config(false)
//                    }
//                    self.delegate?.commandState(value: commandStateValue)
//                case .EF( _):
//                    self.delegate?.commandState(value: .config(nil))
//                default:
//                    break
//                }
//            case .updateName:
//                switch response {
//                case .D6(let model):
//              
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//            
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .D1(let bool):
//                    var commandStateValue: commandState = .updateName(true)
//                    if !bool {
//                        commandStateValue = .updateName(false)
//                    }
//                    self.delegate?.commandState(value: commandStateValue)
//                case .EF( _):
//                    self.delegate?.commandState(value:.updateName(nil))
//                default:
//                    break
//                }
//            case .isAdminCode:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .EF(let adminCodeMode):
//                    
//                    switch adminCodeMode {
//                    case .setupSuccess:
//                        self.delegate?.commandState(value: .isAdminCode(true))
//                    case .empty :
//                        self.delegate?.commandState(value: .isAdminCode(false))
//                    default:
//                        self.delegate?.commandState(value: .isAdminCode(nil))
//                    }
//                
//                default:
//                    break
//                }
//            case .setupAdminCode:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .C7(let bool):
//                    var commandStateValue: commandState = .setupAdminCode(true)
//                    if !bool {
//                        commandStateValue = .setupAdminCode(false)
//                    }
//                    self.delegate?.commandState(value: commandStateValue)
//                case .EF( _):
//                    self.delegate?.commandState(value: .setupAdminCode(nil))
//                default: break
//                }
//            case .editAdminCode:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .C8(let bool):
//                    var commandStateValue: commandState = .editAdminCode(true)
//                    if !bool {
//                        commandStateValue = .editAdminCode(false)
//                    }
//                    self.delegate?.commandState(value: commandStateValue)
//                case .EF( _):
//                    self.delegate?.commandState(value: .editAdminCode(nil))
//                default: break
//                }
//            case .setupTimeZone:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .D9(let bool):
//                    var commandStateValue: commandState = .setupTimeZone(true)
//                    if !bool {
//                        commandStateValue = .setupTimeZone(false)
//                    }
//                    self.delegate?.commandState(value: commandStateValue)
//                case .EF( _):
//                    self.delegate?.commandState(value: .setupTimeZone(nil))
//                default: break
//                }
//
//            case .DeviceName:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .D0(let value):
//                    self.delegate?.commandState(value: .DeviceName(value))
//                case .EF( _):
//                    self.delegate?.commandState(value: .DeviceName(nil))
//                default: break
//                }
//            case .editToken:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .E7(let bool):
//                    var commandStateValue: commandState = .editToken(true)
//                    if !bool {
//                        commandStateValue = .editToken(false)
//                    }
//                    self.delegate?.commandState(value: commandStateValue)
//                case .EF( _):
//                    self.delegate?.commandState(value: .editToken(nil))
//                default: break
//                }
//            case .deviceSetting:
//                
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .D4(let model):
//                    let res = DeviceSetupResultModel()
//                    res.D4 = model
//                    self.delegate?.commandState(value: .deviceSetting(res))
//       
//                case .A0(let model):
//                    let res = DeviceSetupResultModel()
//                    res.A0 = model
//                    self.delegate?.commandState(value: .deviceSetting(res))
//         
//                case .EF( _):
//                    self.delegate?.commandState(value: .deviceSetting(nil))
//                default: break
//                }
//                
//            case .logCount:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .E0(let index):
//                    self.delegate?.commandState(value: .logCount(index))
//                case .EF(_):
//                    self.delegate?.commandState(value: .logCount(nil))
//                default:
//                    break
//                }
//            case .log:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .E1(let model):
//                    self.delegate?.commandState(value: .log(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .log(nil))
//                default:
//                    break
//                }
//            case .getTokenArray:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .E4(let index):
//                    self.delegate?.commandState(value: .getTokenArray(index))
//                case .EF(_):
//                    self.delegate?.commandState(value: .getTokenArray(nil))
//                default:
//                    break
//                }
//            case .getToken:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .E5(let model):
//                    self.delegate?.commandState(value: .getToken(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .getToken(nil))
//                default:
//                    break
//                }
//            case .createToken:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .E6(let model):
//                    self.delegate?.commandState(value: .createToken(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .createToken(nil))
//                default:
//                    break
//                }
//                
//            case .delToken:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .E8(let bool):
//                    var commandStateValue: commandState = .delToken(true)
//                    if !bool {
//                        commandStateValue = .delToken(false)
//                    }
//                    self.delegate?.commandState(value: commandStateValue)
//                case .EF(_):
//                    self.delegate?.commandState(value: .delToken(nil))
//                default: break
//                }
//            case .getTokenQrCode:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .E5(let model):
//                    let token = model.token?.toHexString() ?? ""
//                    let dic = ["T": token,"K": qrcodeAes1Key,"A": qrcodeMacAddress, "F": qrcodeUserName, "L": qrcodeDeviceName, "M": qrcodeModelName]
//                    let json = JSON(dic).rawString() ?? ""
//                    let value = AESModel.shared.encodeBase64String(json, barcodeKey: barcodeKey) ?? ""
//                    self.delegate?.commandState(value: .getTokenQrCode(value))
//                case .EF(_):
//                    self.delegate?.commandState(value: .getTokenQrCode(nil))
//                default:
//                    break
//                }
//            case .getPinCodeArray:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .EA(let model):
//                    self.delegate?.commandState(value: .getPinCodeArray(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .getPinCodeArray(nil))
//                default: break
//                }
//            case .getPinCode:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .EB(let model):
//                    self.delegate?.commandState(value: .getPinCode(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .getPinCode(nil))
//                default: break
//                }
//                
//            case .pinCodeoption:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .EC(let bool):
//                    self.delegate?.commandState(value: .pinCodeoption(bool))
//                case .ED(let bool):
//                    self.delegate?.commandState(value: .pinCodeoption(bool))
//                case .EF(_):
//                    self.delegate?.commandState(value: .pinCodeoption(nil))
//                default: break
//                }
//                
//            case .delPinCode:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .EE(let bool):
//                    self.delegate?.commandState(value: .delPinCode(bool))
//                case .EF(_):
//                    self.delegate?.commandState(value: .delPinCode(nil))
//                default: break
//                }
//                
//            case .factoryReset:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .CE(let bool):
//                    self.delegate?.commandState(value: .factoryReset(bool))
//                case .CF(let bool):
//                    self.delegate?.commandState(value: .factoryReset(bool))
//                case .EF(_):
//                    self.delegate?.commandState(value: .factoryReset(nil))
//                default: break
//                }
//            case .supportType:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A4(let model):
//                    self.delegate?.commandState(value: .supportType(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .supportType(nil))
//                default: break
//                }
//            case .accessArray:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A5(let model):
//                    self.delegate?.commandState(value: .accessArray(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .accessArray(nil))
//                default: break
//                }
//            case .searchAccess:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A6(let model):
//                    self.delegate?.commandState(value: .searchAccess(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .searchAccess(nil))
//                default: break
//                }
//            case .accessAction:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A7(let model):
//                    self.delegate?.commandState(value: .accessAction(model))
//                case .A8(let model):
//                    self.delegate?.commandState(value: .accessAction(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .accessAction(nil))
//                default: break
//                }
//            case .delAccess:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .AA(let model):
//                    self.delegate?.commandState(value: .delAccess(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .delAccess(nil))
//                default: break
//                }
//                
//            case .setupAccess:
//                switch response {
//                case .D6(let model):
//                    commandType = .D
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                  
//                    let data = DeviceStatusModel()
//                    data.D6 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A2(let model):
//                    commandType = .A
//                    // 保留藍芽資料
//                    self.delegate?.updateData(value: self.data)
//                    let data = DeviceStatusModel()
//                    data.A2 = model
//                    self.delegate?.commandState(value: .deviceStatus(data))
//                case .A9(let model):
//                    self.delegate?.commandState(value: .setupAccess(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .setupAccess(nil))
//                default: break
//                }
//                
//            case .wifiList:
//                switch response {
//                case .getWifiList(let model):
//                    self.delegate?.commandState(value: .wifiList(model))
//                case .EF(_):
//                    self.delegate?.commandState(value: .wifiList(nil))
//                default:
//                    break
//                }
//            case .connectWifi:
//                switch response {
//                case .setSSID:
//                    self.setWifiPassword()
//                case .setPassword:
//                    self.connectWifi()
//                case .setConnection(let bool):
//                    self.delegate?.commandState(value: .connectWifi(bool))
//                case .setMQTT(let bool):
//                    self.delegate?.commandState(value: .connectMQTT(bool))
//                case .setCloud(let bool):
//                    self.delegate?.commandState(value: .connectClould(bool))
//                case .EF(_):
//                    self.delegate?.commandState(value: .connectWifi(nil))
//                default:
//                    break
//                }
//
//            case .OTAStatus:
//                switch response {
//                case .C3(let model):
//                    self.delegate?.commandState(value: .OTAStatus(model))
//                default:
//                    break
//                }
//            
//                
//            case .OTAData:
//                switch response {
//                case .C4(let model):
//                    self.delegate?.commandState(value: .OTAData(model))
//                default:
//                    break
//                }
//              
//            default:
//                break
//            }
        } else {
            // 转换失败
        }
        
     
    }
    

    
    
    
    
    
    
}
