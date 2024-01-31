//
//  CommandService.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//



import Foundation
import CoreBluetooth

public class CommandService {
    static let shared = CommandService()

    var counter: Int = 0

    public enum DeviceMode: UInt8 {
        case lock = 0x01
        case unlock = 0x00
    }
    
    public enum plugMode: UInt8 {
        case on = 0x01
        case off = 0x00
    }
    
    
    public enum SecurityboltMode: UInt8 {
        case protrude = 0x01
        case unprotrude = 0x00
    }
    
    public enum deviceStatusMode: UInt8 {
        case lockstate = 0x01
        case securitybolt = 0x02
    }
    

    
    public enum AccessTypeMode: UInt8 {
        case AccessCode = 0x00
        case AccessCard = 0x01
        case Fingerprint = 0x02
        case Face = 0x03
    }

    enum tokenType {
        case oneTimeToken
        case reject
        case valid
        case invalid
    }

    public enum TokenPermission: String {
        case owner
        case manager
        case user
        case none
        case error
    }
    
    public enum alertType: String {
        case errorAccess
        case correctButErrortime
        case correctButVacationMode
        case activelyPressClearKey
        case moreError
        case broken
    }

    enum AdminCodeMode {
        case setupSuccess
        case empty
        case error
    }

    enum ActionOption {
        case getWifiList
        case setSSID(String)
        case setPassword(String)
        case setConnection
        case C0([UInt8]?)
        case C1([UInt8])
        case C2(RFMCURequestModel)
        case C3(OTAStatusRequestModel)
        case C4(OTADataRequestModel)
        case C7([Int])
        case C8(EditAdminCodeModel)
        case CC
        case CB
        case CE([Int])
        case CF
        case B0
        case B1(plugMode)
        case D0
        case D1(String)
        case D2
        case D3(Date)
        case D4
        case A0 // same D4
        case D5(DeviceSetupModelD5)
        case A1(DeviceSetupModelA1) // same D5
        case D6
        case A2 // same D6
        case D7(DeviceMode)
        case A3(deviceStatusMode, DeviceMode?, SecurityboltMode?) // same D7
        case D9(Int32, Data)
        case E0
        case E1(Int)
        case E2
        case E3
        case E4
        case E5(Int)
        case E6(AddTokenModel)
        case E7(EditTokenModel)
        case E8(TokenModel, [UInt8]?)
        case E9
        case EA
        case EB(Int)
        case EC(PinCodeManageModel)
        case ED(PinCodeManageModel)
        case EE(Int)
        case EF
        case F1(String)
        case F2(String)
        case N90
        case N91(Int)
        case N92(UserCredentialModel)
        case N93(DelUserCredentialRequestModel)
        case N94
        case A4
        case A5(AccessTypeMode)
        case A6(SearchAccessRequestModel)
        case A7(AccessRequestModel)
        case A8(AccessRequestModel)
        case A9(SetupAccessRequestModel)
        case AA(DelAccessRequestModel)
 
    

        var command: [UInt8] {
            switch self {
            case .getWifiList:
                guard let data = "L".data(using: .utf8) else { return [0x00] }
                return [0xF0, UInt8(data.count)] + data.map{$0}
            case .setSSID(let ssidName):
                guard let data = ("S" + ssidName).data(using: .utf8) else { return [0x00] }
                return [0xF0, UInt8(data.count)] + data.map{$0}
            case .setPassword(let ssidPassword):
                guard let data = ("P" + ssidPassword).data(using: .utf8) else { return [0x00] }
                return [0xF0, UInt8(data.count)] + data.map{$0}
            case .setConnection:
                guard let data = "C".data(using: .utf8) else { return [0x00] }
                return [0xF0, UInt8(data.count)] + data.map{$0}
            case .B0:
                return [0xB0, 0x03]
            case .B1(let data):
                return [0xB1, 0x01, data.rawValue]
            case .C0:
                return [0xC0, 0x10]
            case .C1(let token):
                var byteArray:[UInt8] = [0xC1, 0x08]
                token.forEach{byteArray.append($0)}
                return byteArray
            case .C2(let model):
                return model.command
            case .C3(let data):
                let length = UInt8(data.command.count)
                var byteArray:[UInt8] = [0xC3, length]
                data.command.forEach{byteArray.append($0)}
                return byteArray
            case .C4(let data):
                let length = UInt8(data.command.count)
                var byteArray:[UInt8] = [0xC4, length]
                data.command.forEach{byteArray.append($0)}
                return byteArray
            case .C7(let adminCode):
                let length = UInt8(adminCode.count)
                var byteArray:[UInt8] = [0xC7, length + 1, length]
                adminCode.forEach{byteArray.append(UInt8($0))}
                return byteArray

            case .C8(let model):
                return model.command
            case .CC:
                return [0xCC, 0x00]
            case .CB:
                return [0xCB, 0x00]
            case .CE(let adminCode):
                let length = UInt8(adminCode.count)
                var byteArray = [0xCE, length + 1, length]
                adminCode.forEach{byteArray.append(UInt8($0))}
                return byteArray
            case .CF:
                return [0xCF, 0x00]
            case .D0:
                return [0xD0, 0x00]
            case .D1(let lockName):
                guard let data = lockName.data(using: .utf8) else {
                    return [0xD1]
                }
                let count = UInt8(data.count)
                var byteArray:[UInt8] = [0xD1, count]
                data.forEach{byteArray.append($0)}
                return byteArray
            case .D2:
                return [0xD2]
            case .D3(let now):
                var byteArray:[UInt8] = [0xD3, 0x04]
                let timestamp = now.timeIntervalSince1970.toInt64
                
        
                if timestamp >= 0 && timestamp <= Int64(4294967295) {
                    print("Int64 value is in range for unsingned UInt32")
             
                    withUnsafeBytes(of: timestamp) { bytes in
                        for byte in bytes {
                            let stringHex = String(format: "%02x", byte)
                            let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                           
                            byteArray.append(uint8)
                        }
                    }
                    
                    byteArray.removeLast()
                    byteArray.removeLast()
                    byteArray.removeLast()
                    byteArray.removeLast()
  
                } else {
                    print("Int64 value is out of range for UInt32")
                    byteArray.append(0xFF)
                    byteArray.append(0xFF)
                    byteArray.append(0xFF)
                    byteArray.append(0xFF)
                }
                
             
             
                return byteArray
            case .D4:
                return [0xD4, 0x00]
            case .A0:
                return [0xA0, 0x00]
            case .D5(let setupModel):
             
                let resetBolt:UInt8 = setupModel.resetBolt ? 0xA2 : 0xA3
                let soundSetting:UInt8 = setupModel.soundOn ? 0x01 : 0x00
                let vacationSetting:UInt8 = setupModel.vacationModeOn ? 0x01 : 0x00
                let autoLockSetting:UInt8 = setupModel.autoLockOn ? 0x01 : 0x00
                let autoLockTime = UInt8(setupModel.autoLockTime)
                let leadCode: UInt8 = setupModel.guidingCode ? 0x01 : 0x00
                var byteArray:[UInt8] = [0xD5, 0x16, resetBolt, soundSetting, vacationSetting, autoLockSetting, autoLockTime, leadCode]
                let latitude1 = setupModel.latitude.toInt32
                let latitude2 = setupModel.latitude.decimalPartToInt32
                let longitude1 = setupModel.longitude.toInt32
                let longitude2 = setupModel.longitude.decimalPartToInt32
                withUnsafeBytes(of: latitude1) { bytes in
                    for byte in bytes {
                        let stringHex = String(format: "%02x", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                        byteArray.append(uint8)
                    }
                }

                withUnsafeBytes(of: latitude2) { bytes in
                    for byte in bytes {
                        let stringHex = String(format: "%02x", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                        byteArray.append(uint8)
                    }
                }

                withUnsafeBytes(of: longitude1) { bytes in
                    for byte in bytes {
                        let stringHex = String(format: "%02x", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                        byteArray.append(uint8)
                    }
                }

                withUnsafeBytes(of: longitude2) { bytes in
                    for byte in bytes {
                        let stringHex = String(format: "%02x", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                        byteArray.append(uint8)
                    }
                }
                return byteArray
            case .A1(let setupModel):
                var byteArray:[UInt8] = [0xA1, 0x1C]
                let latitude1 = setupModel.latitude.toInt32
                let latitude2 = setupModel.latitude.decimalPartToInt32
                let longitude1 = setupModel.longitude.toInt32
                let longitude2 = setupModel.longitude.decimalPartToInt32
                withUnsafeBytes(of: latitude1) { bytes in
                    for byte in bytes {
                        let stringHex = String(format: "%02x", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                        byteArray.append(uint8)
                    }
                }

                withUnsafeBytes(of: latitude2) { bytes in
                    for byte in bytes {
                        let stringHex = String(format: "%02x", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                        byteArray.append(uint8)
                    }
                }

                withUnsafeBytes(of: longitude1) { bytes in
                    for byte in bytes {
                        let stringHex = String(format: "%02x", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                        byteArray.append(uint8)
                    }
                }

                withUnsafeBytes(of: longitude2) { bytes in
                    for byte in bytes {
                        let stringHex = String(format: "%02x", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                        byteArray.append(uint8)
                    }
                }
             //   let direction: UInt8 =  setupModel.direction == .unknown ? 0xA2 : setupModel.direction == .ignore ? 0xA3 : 0xFF
                var direction: UInt8 = 0xFF
                switch setupModel.direction {
                case .right:
                    direction = 0xA0
                case .left:
                    direction = 0xA1
                case .unknown:
                    direction = 0xA2
                case .ignore:
                    direction = 0xA3
                default:
                    break
                    
                }
                
                byteArray.append(direction)
                let guidingCode: UInt8 = setupModel.guidingCode == .open ? 0x01 : setupModel.guidingCode == .close ? 0x00 : 0xFF
                byteArray.append(guidingCode)
                let virtualCode: UInt8 = setupModel.virtualCode == .open ? 0x01 : setupModel.virtualCode == .close ? 0x00 : 0xFF
                byteArray.append(virtualCode)
                let twoFA: UInt8 = setupModel.twoFA == .open ? 0x01 : setupModel.twoFA == .close ? 0x00 : 0xFF
                byteArray.append(twoFA)
                let vacationModeOn: UInt8 = setupModel.vacationModeOn == .open ? 0x01 : setupModel.vacationModeOn == .close ? 0x00 : 0xFF
                byteArray.append(vacationModeOn)
                let autoLockOn: UInt8 = setupModel.autoLockOn == .open ? 0x01 : setupModel.autoLockOn == .close ? 0x00 : 0xFF
                byteArray.append(autoLockOn)
            
                print("autoLockOn: \(setupModel.autoLockOn.rawValue)")
                
                let time = Int32(setupModel.autoLockTime)
           
                withUnsafeBytes(of: time) { bytes in
               
                    for byte in bytes {
                        let stringHex = String(format: "%02x", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                      
                        byteArray.append(uint8)
                    }
                }
                // time has 4 byte command just need 2 byte
                // remove last two byte
                byteArray.removeLast(2)
                
                let soundOn: UInt8 = setupModel.soundOn == .open ? 0x01 : setupModel.soundOn == .close ? 0x00 : 0xFF
                byteArray.append(soundOn)
                
                var voice: [UInt8] = [0xFF, 0xFF]
                switch setupModel.voiceValue {
                case .close:
                    voice = [0x01, 0x00]
                case .open:
                    voice = [0x01, 0x64]
                case .loudly:
                    voice = [0x02, 0x64]
                case .whisper:
                    voice = [0x02, 0x32]
                case .value(let value):
                    var element: UInt8 = 0x00
                    let hexString = String(value, radix: 16)
                    element =  UInt8(hexString) ?? 0x00
    
                    print("progress Value: \(value)")
                    print("progress uint8: \(element)")
                    voice = [0x03, UInt8(value)]
                    
                default:
                    voice = [0xFF, 0xFF]
                }
                byteArray = byteArray + voice
                
                let fastMode: UInt8 = setupModel.fastMode == .open ? 0x01 : setupModel.fastMode == .close ? 0x00 : 0xFF
                byteArray.append(fastMode)
                
                return byteArray
            case .D6:
                return [0xD6, 0x00]
            case .A2:
                return [0xA2, 0x00]
            case .D7(let lockMode):
                return [0xD7, 0x01, lockMode.rawValue]
            case .A3(let act, let lock, let security):
                switch act {
                case .lockstate:
                    return [0xA3, 0x02, 0x01, lock!.rawValue]
                case .securitybolt:
                    return [0xA3, 0x02, 0x02, security!.rawValue]
                }
            case .D9(let offset, let abbreviation):
                var byteArray:[UInt8] = [0xD9]
                let timeZoneOffSetLength = 4
//                guard let data = abbreviation.data(using: .utf8) else { return [0xD9] }

                let dataLength = UInt8(timeZoneOffSetLength + abbreviation.count)
                byteArray.append(dataLength)
                withUnsafeBytes(of: offset) { bytes in
                    for byte in bytes {
                        let stringHex = String(format: "%02x", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                        byteArray.append(uint8)
                    }
                }
                abbreviation.forEach{byteArray.append($0)}
                return byteArray
            case .E0:
                return [0xE0, 0x00]
            case .E1(let index):
                return [0xE1, 0x01, UInt8(index)]
            case .E2:
                return [0xE2]
            case .E3:
                return [0xE3]
            case .E4:
                return [0xE4, 0x00]
            case .E5(let index):
                return [0xE5, 0x01, UInt8(index)]
            case .E6(let model):
                let command = model.command
                let commandLength = UInt8(command.count)
                var byteArray = [0xE6, commandLength]
                command.forEach{byteArray.append($0)}
                return byteArray
            case .E7(let editTokenModel):
                let command = editTokenModel.command
                let commandLength = UInt8(command.count)
                var byteArray = [0xE7, commandLength]
                command.forEach{byteArray.append($0)}
                return byteArray
            case .E8(let tokenModel, let pinCode):
                if tokenModel.isOwnerToken == .owner {
                    guard let pinCode = pinCode else { return [0xE8] }
                    guard let index = tokenModel.indexOfToken else { return [0xE8] }
                    let length = pinCode.count
                    let commandLength = 1 + 1 + length
                    var byteArray = [0xE8, UInt8(commandLength), UInt8(index), UInt8(length)]
                    pinCode.forEach{byteArray.append($0)}
                    return byteArray
                } else {
                    guard let index = tokenModel.indexOfToken else { return [0xE8] }
                    return [0xE8, 0x01, UInt8(index)]
                }
            case .E9:
                return [0xE9]
            case .EA:
                return [0xEA, 0x00]
            case .EB(let index):
                return [0xEB, 0x01, UInt8(index)]
            case .EC(let PinCodeManageModel):
                return PinCodeManageModel.command
            case .ED(let PinCodeManageModel):
            return PinCodeManageModel.command
            case .EE(let index):
                return [0xEE, 0x01, UInt8(index)]
            case .EF:
                return [0xEF, 0x00]
            case .F1(let identity):
       
                let length = identity.count
                let commandLength = 2 + length
                guard let data = identity.data(using: .utf8) else {
                    return [0x00]
                }
                
                return [0xF1, UInt8(commandLength), 0x01, 0x00] + data.map{$0}
            case .F2(let identity):
       
                let length = identity.count
                let commandLength = 2 + length
                guard let data = identity.data(using: .utf8) else {
                    return [0x00]
                }
                
                return [0xF2, UInt8(commandLength), 0x01, 0x00] + data.map{$0}

            case .A4:
                return [0xA4, 0x00]
            case .A5(let type):
                return [0xA5, 0x01, type.rawValue]
            case .A6(let model):
                return [0xA6, 0x03] + model.command
            case .A7(let model):
                return model.command
            case .A8(let model):
                return model.command
            case .A9(let model):
                return [0xA9, 0x04] +  model.command
            case .AA(let model):
                return [0xAA, 0x03] + model.command
            case .N90:
                return [0x90, 0x00]
            case .N91(let index):
                return [0x91, 0x01, UInt8(index)]
            case .N92(let model):
                let command = model.command
                let commandLength = UInt8(command.count)
                return [0x92, commandLength] + model.command
            case .N93(let model):
                return [0x93, 0x02] + model.command
            case .N94:
                return [0x94, 0x00]
                
            }
        }

        var dataLength: UInt8 {
            switch self {
            case .getWifiList:
                return 0x01
            case .setSSID(let ssidString):
                guard let data = ssidString.data(using: .utf8) else {
                    return 0x01
                }
                let length = UInt8(data.count + 1)
                return length
            case .setPassword(let passwordString):
                guard let data = passwordString.data(using: .utf8) else {
                    return 0x01
                }
                let length = UInt8(data.count + 1)
                return length
            case .setConnection:
                return 0x01
            case .B0:
                return 0x03
            case .B1:
                return 0x01
            case .C0:
                return 0x10
            case .C1:
                return 0x08
            case .C2:
                return 0x01
            case .C3(let data):
                return UInt8(data.command.count)
            case .C4(let data):
                return UInt8(data.command.count)
            case .C7(let adminCode):
                return UInt8(adminCode.count + 1)
            case .C8(let model):
                return model.commandLength
            case .CC:
                return 0x00
            case .CB:
                return 0x00
            case .CE(let adminCode):
                let length = UInt8(1 + adminCode.count)
                return length
            case .CF:
                return 0x00
         
            case .D0:
                return 0x00
            case .D1(let lockName):
                guard let data = lockName.data(using: .utf8) else {
                    return 0x01
                }
                let length = UInt8(data.count + 1)
                return length
            case .D2:
                return 0x01
            case .D3:
                return 0x04
            case .D4:
                return 0x00
            case .A0:
                return 0x00
            case .D5:
                return 0x16
            case .A1:
                return 0x1C
            case .D6:
                return 0x00
            case .A2:
                return 0x00
            case .D7:
                return 0x01
            case .A3:
                return 0x02
            case .D9( _, let abbreviation):
                let timeZoneOffSetLength = 4
//                guard let data = abbreviation.data(using: .utf8) else { return 0x01 }
                let dataLength = UInt8(timeZoneOffSetLength + abbreviation.count)
                return dataLength
            case .E0:
                return 0x00
            case .E1:
                return 0x01
            case .E2:
                return 0x01
            case .E3:
                return 0x01
            case .E4:
                return 0x00
            case .E5:
                return 0x01
            case .E6(let model):
                let commandLength = UInt8(model.command.count)
                return commandLength
            case .E7(let editTokenModel):
                let commandLength = UInt8(editTokenModel.command.count)
                return commandLength
            case .E8(let tokenModel, let pinCode):
                if tokenModel.isOwnerToken == .owner {
                    guard let pinCode = pinCode else { return 0x00 }
                    let length = pinCode.count
                    let commandLength = 1 + 1 + length
                    return UInt8(commandLength)
                } else {
                    return 0x01
                }
            case .E9:
                return 0x01
            case .EA:
                return 0x00
            case .EB:
                return 0x01
            case .EC(let PinCodeManageModel):
                return PinCodeManageModel.commandLength
            case .ED(let PinCodeManageModel):
                return PinCodeManageModel.commandLength
            case .EE:
                return 0x01
            case .EF:
                return 0x00
            case .F1(let identity):
               
                let length = identity.count
                let commandLength = length + 2
                
                return UInt8(commandLength)
            case .F2(let identity):
               
                let length = identity.count
                let commandLength = length + 2
                
                return UInt8(commandLength)
          
            case .A4:
                return 0x00
            case .A5:
                return 0x01
            case .A6:
                return 0x03
            case .A7(let model):
                return model.commandLength
            case .A8(let model):
                return model.commandLength
            case .A9:
                return 0x04
            case .AA:
                return 0x03
            case .N90:
                return 0x00
            case .N91:
                return 0x02
            case .N92(let model):
                let commandLength = UInt8(model.command.count)
                return commandLength
            case .N93(let model):
                return 0x02
            case .N94:
                return 0x00
            }
        }
    }

    enum ActionResolveOption {
        case getWifiList(SSIDModel)
        case setSSID
        case setPassword
        case setConnection(Bool)
        case setMQTT(Bool)
        case setCloud(Bool)
        case C0([UInt8])
        case C1(tokenType, TokenPermission)
        case C2(RFMCUversionModel)
        case C3(OTAResponseModel)
        case C4(OTADataResponseModel)
        case C7(Bool)
        case C8(Bool)
        case CC
        case CB(Bool)
        case CE(Bool)
        case CF(Bool)
        case B0(plugStatusResponseModel)
        case B1(plugStatusResponseModel)
        case D0(String?)
        case D1(Bool)
        case D2
        case D3(Bool)
        case D4(DeviceSetupResultModelD4)
        case A0(DeviceSetupResultModelA0)
        case D5(Bool)
        case A1(Bool)
        case D6(DeviceStatusModelD6)
        case A2(DeviceStatusModelA2)
        case D7
        case A3
        case D9(Bool)
        case E0(Int)
        case E1(LogModel)
        case E2
        case E3
        case E4([Int])
        case E5(TokenModel)
        case E6(AddTokenResult)
        case E7(Bool)
        case E8(Bool)
        case E9
        case EA(PinCodeArrayModel)
        case EB(PinCodeModelResult)
        case EC(Bool)
        case ED(Bool)
        case EE(Bool)
        case EF(AdminCodeMode)
        case F1(DeviceStatusModelA2)
        case F2(Bool)
        case N90([Int])
        case N91(UserCredentialModel)
        case N92(N9ResponseModel)
        case N93(N9ResponseModel)
        case N94(N9ResponseModel)
        case error(String)
        case A4(SupportDeviceTypesResponseModel)
        case A5(AccessArrayResponseModel)
        case A6(AccessDataResponseModel)
        case A7(AccessResponseModel)
        case A8(AccessResponseModel)
        case A9(SetupAccessResponseModel)
        case AA(DelAccessResponseModel)
        case AF(AlertResponseModel)
        var transmissionKey:UInt8? {
            switch self {
            case .getWifiList:
                return 0xF0
            case .setSSID:
                return 0xF0
            case .setPassword:
                return 0xF0
            case .setConnection:
                return 0xF0
            case .setMQTT:
                return 0xF0
            case .setCloud:
                return 0xF0
            case .B0:
                return 0xB0
            case .B1:
                return 0xB1
            case .C0:
                return 0xC0
            case .C1:
                return 0xC1
            case .C2:
                return 0xC2
            case .C3:
                return 0xC3
            case .C4:
                return 0xC4
            case .C7:
                return 0xC7
            case .C8:
                return 0xC8
            case .CC:
                return 0xCC
            case .CB:
                return 0xCB
            case .CE:
                return 0xCE
            case .CF:
                return 0xCF
            case .D0:
                return 0xD0
            case .D1:
                return 0xD1
            case .D2:
                return 0xD2
            case .D3:
                return 0xD3
            case .D4:
                return 0xD4
            case .A0:
                return 0xA0
            case .D5:
                return 0xD5
            case .A1:
                return 0xA1
            case .D6:
                return 0xD6
            case .A2:
                return 0xA2
            case .D7:
                return 0xD7
            case .A3:
                return 0xA3
            case .D9:
                return 0xD9
            case .E0:
                return 0xE0
            case .E1:
                return 0xE1
            case .E2:
                return 0xE2
            case .E3:
                return 0xE3
            case .E4:
                return 0xE4
            case .E5:
                return 0xE5
            case .E6:
                return 0xE6
            case .E7:
                return 0xE7
            case .E8:
                return 0xE8
            case .E9:
                return 0xE9
            case .EA:
                return 0xEA
            case .EB:
                return 0xEB
            case .EC:
                return 0xEC
            case .ED:
                return 0xED
            case .EE:
                return 0xEE
            case .EF:
                return 0xEF
            case .F1:
                return 0xF1
            case .F2:
                return 0xF2
            case .N90:
                return 0x90
            case .N91:
                return 0x91
            case .N92:
                return 0x92
            case .N93:
                return 0x93
            case .N94:
                return 0x94
            case .A4:
                return 0xA4
            case .A5:
                return 0xA5
            case .A6:
                return 0xA6
            case .A7:
                return 0xA7
            case .A8:
                return 0xA8
            case .A9:
                return 0xA9
            case .AA:
                return 0xAA
            case .AF:
                return 0xAF
            case .error:
                return nil
            }
        }
    }

    func appendSerialByte()-> [UInt8] {
        self.increaseCounter()
        let byteArray = [counter.toTwoByte(.low), counter.toTwoByte(.high)]
        return byteArray
    }

    /// Fill data with random byte
    func fillDataLength(with action:ActionOption)-> [UInt8] {
        var byteArray = action.command
        for _ in 0...action.dataLength - 1 {
            byteArray.append(UInt8.random(in: 0x00...0xff))
        }
        return byteArray
    }

    /// Fill total data length to 16x

    func fillRandomBytes(_ data:[UInt8])-> [UInt8] {
        var byteArray = self.appendSerialByte()
        data.forEach{byteArray.append($0)}

        let byteLength = byteArray.count
        let fillCount = (16 - (byteLength % 16))

        for _ in 0...fillCount - 1  {
            byteArray.append(UInt8.random(in: 0x00...0xff))
        }
        print("🌊🌊🌊 \n send Command: \(byteArray.bytesToHex()) \n 🌊🌊🌊")
        return byteArray
    }

    func increaseCounter() {
        self.counter += 1
    }

    private func resetCounter() {
        self.counter = 0
    }

    func createAction(with action: ActionOption, key: [UInt8]) -> Data? {
        let bytesArray: [UInt8] = {
            switch action {

            case .C0(let actionAndData):
                self.resetCounter()
                if let actionAndData = actionAndData {
                    let padding = fillRandomBytes(actionAndData)
                 
                    return padding
                } else {
                    return []
                }

            case .D2:
                return [0x00]

            case .E2:
                return [0x01]
            case .E3:
                return [0x01]

            case .E9:
                return [0x01]

                
            default:
                let data = action.command
                let padding = fillRandomBytes(data)
                return padding
            }
        }()


        guard let aesBytes = AESModel.shared.encrypt(key: key, bytesArray) else { return nil }

        return Data(aesBytes)
    }

    func resolveAction<T>(_ characteristic:T, key:[UInt8], _ checkIsSameAction:CommandService.ActionOption? = nil)-> ActionResolveOption {
        if let characteristic = characteristic as? CBCharacteristic {
        
            guard let responseValue = characteristic.value else { return .error("Can't get characteristic: \(characteristic) value")}
            
   
            guard let decryptData = AESModel.shared.decrypt(key: key, responseValue) else { return .error("Decrypt data error") }
        
            guard let action = decryptData[safe: 2] else { return .error("Can't get first value of characteristic")}
            guard let dataLength = decryptData[safe: 3] else { return .error("Can't get first value of characteristic")}

            print("🌜🌜🌜 \n response data CBCharacteristic \(decryptData.bytesToHex()) \n 🌜🌜🌜")
            
            if Int(dataLength) > decryptData.count {
                return .error("Unknown response")
            }
            
            var dataWithoutHeader = Array(decryptData[4...Int(dataLength) + 3])
            if action == 0xA5 {
                dataWithoutHeader = Array(decryptData[3...Int(dataLength) + 3])
            }
            return self.resolveAction(action, data: dataWithoutHeader, checkIsSameAction)
        } else if let data = characteristic as? Data {
            guard let decryptData = AESModel.shared.decrypt(key: key, data) else { return .error("Decrypt data error") }
            guard let action = decryptData[safe: 2] else { return .error("Can't get first value of characteristic")}
            guard let dataLength = decryptData[safe: 3] else { return .error("Can't get first value of characteristic")}
            
            print("🌜🌜🌜 \n response data  Data \(decryptData.bytesToHex()) \n 🌜🌜🌜")
            
            
            var dataWithoutHeader = Array(decryptData[4...Int(dataLength) + 3])
            if action == 0xA5 {
                dataWithoutHeader = Array(decryptData[3...Int(dataLength) + 3])
            }
            return self.resolveAction(action, data: dataWithoutHeader, checkIsSameAction)
        } else if let byteArray = characteristic as? [UInt8] {
            guard let decryptData = AESModel.shared.decrypt(key: key, Data.init(byteArray)) else { return .error("Decrypt data error") }
            guard let action = decryptData[safe: 2] else { return .error("Can't get first value of characteristic")}
            guard let dataLength = decryptData[safe: 3] else { return .error("Can't get first value of characteristic")}
            
            print("🌜🌜🌜 \n response data  [UInt8] \(decryptData.bytesToHex()) \n 🌜🌜🌜")
            
            var dataWithoutHeader = Array(decryptData[4...Int(dataLength) + 3])
            if action == 0xA5 {
                dataWithoutHeader = Array(decryptData[3...Int(dataLength) + 3])
            }
            return self.resolveAction(action, data: dataWithoutHeader, checkIsSameAction)
        } else {
            return .error("Unknown response type \(characteristic)")
        }
    }

    private func resolveAction(_ actionCode:UInt8, data:[UInt8], _ checkIsSameAction:CommandService.ActionOption? = nil) -> ActionResolveOption {
        if let checkIsSameAction = checkIsSameAction {
            guard actionCode == checkIsSameAction.command.first else { return .error("Unkown action \(actionCode)") }
            return self.resolveWithActionCode(actionCode: actionCode, data: data)
        } else {
            return self.resolveWithActionCode(actionCode: actionCode, data: data)
        }
    }

    private func resolveWithActionCode(actionCode:UInt8, data:[UInt8]) -> ActionResolveOption {
  
        switch actionCode {
        case 0xF0:
            // set wifi 回傳 L
            // set ssid 回傳 S
            // set password 回傳 P
            // set connection 回傳 "CWiFi Succ" or "LE"
            guard let index0 = data[safe: 0] else { return .error("Can't get F0 response") }
            guard let stringValue = String(data: Data([index0]), encoding: .utf8) else { return .error("[F0]:Convert data to string error")}
            print("👊👊👊  WifiConnectState 👊👊👊 \n \(String(data: Data(data), encoding: .utf8)) \n 👊👊👊👊👊👊")
            // CWiFi Succ
            // SWiFi Fail
            switch stringValue {
            case "L":
                let ssidModel = SSIDModel(response: data)
                return .getWifiList(ssidModel)
            case "S":
                return .setSSID
            case "P":
                return .setPassword
            case "C":
                guard let string = String(data: Data(data), encoding: .utf8) else { return .error("") }
                if string == "CWiFi Succ" {
                    return .setConnection(true)
                }
                
                if string == "CMQTT Succ" {
                    return .setMQTT(true)
                }
                
                if string == "CCloud Succ" {
                    return .setCloud(true)
                }
                
                if string == "CWiFi Fail" {
                    return .setConnection(false)
                }
                
                if string == "CMQTT Fail" {
                    return .setMQTT(false)
                }
                
                if string == "CCloud Fail" {
                    return .setCloud(false)
                }
                
                return .setConnection(false)
               
            default:
                return .error("Unknown F0 response: \(data.bytesToHex())")
            }
        case 0xB0:
            let model = plugStatusResponseModel(data)
       
            return .B0(model)
        case 0xB1:
            let model = plugStatusResponseModel(data)
       
            return .B1(model)
        case 0xC0:
            return .C0(data)
        case 0xC1:
            var tokenMode: tokenType {
                guard let index0 = data.first else { return .invalid }
                switch index0 {
                case 0x03:
                    return .oneTimeToken
                case 0x02:
                    return .reject
                case 0x01:
                    return .valid
                case 0x00:
                    return .invalid
                default:
                    return .invalid
                }
            }

            var tokenPermission: TokenPermission {
                guard let index1 = data[safe: 1] else { return .error }
                guard let string = String(data: Data([index1]), encoding: .utf8)?.lowercased() else { return .error }
                print("tokenPermission: \(string)")
                switch string {
                case "m":
                    return .owner
                case "a":
                    return .manager
                case "l":
                    return .user
                case "n":
                    return .none
                default:
                    return .error
                }
            }
            return .C1(tokenMode, tokenPermission)
        case 0xC2:
            return .C2(RFMCUversionModel(response: data))
        case 0xC3:
       
            let model = OTAResponseModel(data)
       
            return .C3(model)
        case 0xC4:
            let model = OTADataResponseModel(data)
            return .C4(model)
        case 0xC7:
            let isSuccess = data.first == 0x01
            return .C7(isSuccess)
        case 0xC8:
            let isSuccess = data.first == 0x01
            return .C8(isSuccess)
        case 0xCC:
            return .CC
        case 0xCB:
            let isSuccess = data.first == 0x01
            return .CB(isSuccess)
        case 0xCE:
            let isSuccess = data.first == 0x01
            return .CE(isSuccess)
        case 0xCF:
            let isSuccess = data.first == 0x01
            return .CF(isSuccess)
        case 0xD0:
            let name = String(data: Data.init(data), encoding: .utf8)
            return .D0(name)
        case 0xD1:
            let isSuccess = data.first == 0x01
            return .D1(isSuccess)
        case 0xD2:
            return .D2
        case 0xD3:
            let isSuccess = data.first == 0x01
            return .D3(isSuccess)
        case 0xD4:
            let setupModel = DeviceSetupResultModelD4(data)
            return .D4(setupModel)
        case 0xA0:
            let setupModel = DeviceSetupResultModelA0(data)
            return .A0(setupModel)
        case 0xD5:
            let isSuccess = data.first == 0x01
            return .D5(isSuccess)
        case 0xA1:
            let isSuccess = data.first == 0x01
            return .A1(isSuccess)
        case 0xD6:
            let state = DeviceStatusModelD6(data)
            return .D6(state)
        case 0xA2:
            let state = DeviceStatusModelA2(data)
            return .A2(state)
        case 0xD7:
            return .D7
        case 0xA3:
            return .A3
        case 0xD9:
            let isSuccess = data.first == 0x01
            return .D9(isSuccess)
        case 0xE0:
            let logQuantity = data.first?.toInt ?? 0
            return .E0(logQuantity)
        case 0xE1:
            let model = LogModel(data: data)
            return .E1(model)
        case 0xE2:
            return .E2
        case 0xE3:
            return .E3
        case 0xE4:
            let indexArray = data.enumerated().filter{$0.1 == 0x01}.map{$0.0}
            return .E4(indexArray)
        case 0xE5:
            let tokenModel = TokenModel(response: data)
            return .E5(tokenModel)
        case 0xE6:
            let result = AddTokenResult(response: data)
            return .E6(result)
        case 0xE7:
            let isSuccess = data.first == 0x01
            return .E7(isSuccess)
        case 0xE8:
            let isSuccess = data.first == 0x01
            return .E8(isSuccess)
        case 0xE9:
            return .E9
        case 0xEA:
            let PinCodeModel = PinCodeArrayModel(response: data)
            return .EA(PinCodeModel)
        case 0xEB:
            let result = PinCodeModelResult(response: data)
            return .EB(result)
        case 0xEC:
            guard let index0 = data[safe: 0] else { return .EC(false) }
            return .EC(index0 == 0x01)
        case 0xED:
            guard let index0 = data[safe: 0] else { return .ED(false) }
            return .ED(index0 == 0x01)
        case 0xEE:
            let isSuccess = data.first == 0x01
            return .EE(isSuccess)
        case 0xEF:
            var adminCodeMode: AdminCodeMode {
                guard let index0 = data.first else { return .error }
                switch index0 {
                case 0x01:
                    return .setupSuccess
                case 0x00:
                    return .empty
                default:
                    return .error
                }
            }
            return .EF(adminCodeMode)
 
        case 0xA4:
            let result = SupportDeviceTypesResponseModel(response: data)
            return .A4(result)
        case 0xA5:
            let result = AccessArrayResponseModel(data: data)
            return .A5(result)
        case 0xA6:
            let result = AccessDataResponseModel(response: data)
            return .A6(result)
        case 0xA7:
            let result = AccessResponseModel(data)
            return .A7(result)
        case 0xA8:
            let result = AccessResponseModel(data)
            return .A8(result)
        case 0xA9:
            let result = SetupAccessResponseModel(data)
            return .A9(result)
        case 0xAA:
            let result = DelAccessResponseModel(data)
            return .AA(result)
        case 0xAF:
            let result = AlertResponseModel(data)
            return .AF(result)
        case 0xF1:
            let state = DeviceStatusModelA2(data)
            return .F1(state)
        case 0xF2:
            let isSuccess = data.first == 0x01
            return .F2(isSuccess)
        case 0x90:
            let indexArray = data.enumerated().filter{$0.1 == 0x01}.map{$0.0}
            return .N90(indexArray)
        case 0x91:
            let model = UserCredentialModel(response: data)
            return .N91(model)
        case 0x92:
            let model = N9ResponseModel(response: data)
            return .N92(model)
        case 0x93:
            let model = N9ResponseModel(response: data)
            return .N93(model)
        case 0x94:
            let model = N9ResponseModel(response: data)
            return .N94(model)
        default:
            return .error("Unkown action \(actionCode)")
        }
    }
}


