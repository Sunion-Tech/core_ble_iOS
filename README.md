
# Sunion BLE communication SDK for IOS

| Content  |
| :---- |
| [Bluetooth](#Bluetooth)|

## System requirements
* swift 5.0+
* iOS 12.1+
* iPhone only



# Bluetooth


| Content  |
| :---- |
| [Install](#Install)|
| [Setup](#Setup)
| [Quick start](#start)
| [UseCases](#UseCases)

# Install
1. Click on Project Navigator
2. Select Targets 
3. Select Build phases 
4. Click on the + button in Link Binary With Libraries
5. Select ``SunionBluetoothTool.framework`` from the list.

# Setup
```
import SunionBluetoothTool
```
viewDidLoad
```
SunionBluetoothTool.shared.delegate = self
```
# Start
### Pairing with lock
To pair with lock, you can get lock connection information by scanning QR code of lock. The content of QR code is encryted with BARCODE_KEY, you can decrypt the contet with the following example code:
```
let response = SunionBluetoothTool.shared.decodeQrCode(barcodeKey: String, qrCode: String)
```
### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
|barcodeKey | String | AES decode/encode Key
|qrCodeData | String |get from qrCode


Before connecting to the lock, you can setup connection state observer:
```
    func bluetoothState(State: bluetoothState) {
        switch State {
        case .enable:
             // do something here
        case .disable:
            // do something here
        case .connecting:
            // do something here
        case .connected(_):
            // do something here
        case .disconnect(let disconnectState):
            switch disconnectState {
            case .fail:
                // do something here
            case .discoverServices(_):
                // do something here
            case .discoverCharacteristics:
                // do something here
            case .deviceRefused:
                // do something here
            case .illegalToken:
                // do something here
                
            }
            
        }
    }
```


### Parameter
|Parameter|Description|
|-|-|
|enable  | permission
|disable | permission
|connecting| bluetooth status
|connected| bluetooth status
|disconnected| DisconnectedState

#### DisconnectedState
|Parameter|Description|
|-|-|
|fail  | error status
|discoverServices|  error status
|discoverCharacteristics| error status
|deviceRefused| error status
|illegalToken | error status

## Connecting to lock 
```
SunionBluetoothTool.shared.initBluetooth(macAddress: String, aes1Key: [UInt8], token: [UInt8])
```
Parameters
| Parameter | Type | Description |
| -------- | -------- | -------- |
| macAddress     | String     |  QR code / BluetoothToolModel
| aes1Key | [UInt8] |  QR code / BluetoothToolModel
| token | [UInt8] | QR code / BluetoothToolModel


### Connecting to paired lock
To connect to paired lock, you should use the saved LockConnectionInfo to connect to lock.
```
let data = SunionBluetoothTool.shared.data
```
#### Parameters

##### data: BluetoothToolModel

| Name | Type | Description |
| -------- | -------- | -------- |
| macAddress     | String     | BT mac address of lock. You can get it from QR code.     |
| token     | String     | Default connection token of lock. You can get it from QR code.     |
| permanentToken     | String     | Excanged connection token when pairing with lock. You should save it for later use.    |
| aes1Key     | String     | Encryption key of data transmission. You can get it from QR code.     |
| aes2Key     | String     | Random-generated encryption key of data transmission.     |
| permission     | TokenPermission     | Permission of connection token.     |
| qrCodeShareFrom| String| share from who
| qrCodeSerialNumber| String | SerialNumber
| qrCodeDisplayNmae| String |  name of device
| modelName| String |  name of device model
| FirmwareVersioin| String | version of device firmware
| RFVersion| String | version of RF
| bleNmae | String | Bluetooth broadcast name
| identifier| String| Bluetooth connted UUID

# BLEUseCases

### IncomingDeviceStatusUseCase
IncomingDeviceStatusUseCase collects device status notified by lock. You can setup the observer when lock connection is ready: [info Link](#DeviceStatus)

```
func DeviceStatus(value: DeviceStatusModel?) {
    if let value = value {
    
        if let D6 = value.D6 {
          // do something here
        }
        
        if let A2 = value.A2 {
          // do something here
        }
        
        if let AF = value.AF {
         // do something here
        }
    
    } else {
     // error
    }
}
```




## AdminCodeUseCase 
### Check if admin code has been set
```
SunionBluetoothTool.shared.isAdminCode()
```
#### Delegate function
```
func AdminCodeExist(bool: Bool?) {
     if let bool = bool {
        // do something here
     } else {
         // error
     }
}
```

---
### Create admin code

```
SunionBluetoothTool.shared.setupAdminCode(Code: String)
```

#### Parameters
| Parameter | Type | Description |
| -------- | -------- | -------- |
| Code     | String     | 4-8 digits 


#### Delegate function
```
func AdminCode(bool: Bool?) {
     if let bool = bool {
        // do something here
     } else {
         // error
     }
}
```
---
### Edit admin code

```
SunionBluetoothTool.shared.editAdminCode(oldCode: String, newCode: String)
```

#### Parameters
| Parameter | Type | Description |
| -------- | -------- | -------- |
| oldCode     | String     | Old Admin Code
| newCode | String | new Admin Code


#### Delegate function
```
func EditAdminCode(bool: Bool?) {
     if let bool = bool {
        // do something here
     } else {
         // error
     }
}
```

## LockTimeUseCase 

### Set time of lock
```
SunionBluetoothTool.shared.setupDeviceTime(date: Date)
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| date     | Date     | Unix timestamp    |

#### Delegate function
```
func DeviceTime(bool: Bool?) {
     if let bool = bool {
        // do something here
     } else {
         // error
     }
}
```

---
### Set timezone of lock
```
 SunionBluetoothTool.shared.setupTimeZone(timezone: String)
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| timezone     | String     | Time-zone ID, such as Asia/Taipei.    |

#### Delegate function
```
func TimeZone(bool: Bool?) {
     if let bool = bool {
        // do something here
     } else {
         // error
     }
}
```


## LockNameUsecase 


### Set lock name
```
SunionBluetoothTool.shared.setupDeviceName(name: String)
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| name     | String     | Lock name length limit is 20 bytes   |

#### Delegate function

```
func DeviceName(bool: Bool?) {
     if let bool = bool {
        // do something here
     } else {
         // error
     }
}
```
---
### get lock name
```
SunionBluetoothTool.shared.getDeviceName()
```

#### Delegate function

```
func DeviceNameData(value: String?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```

## TokenUsecase


### Edit Token
```
SunionBluetoothTool.shared.editToken(model: EditTokenModel)
```

##### Parameter
###### EditTokenModel
| Name | Type | Description |
| -------- | -------- | -------- |
|tokenName|  String | name of token
|tokenPermission|TokenPermission| all<br>limit
|tokenIndex|Int| index of token

#### Delegate function
```
func EditToken(bool: Bool?) {
     if let bool = bool {
        // do something here
     } else {
         // error
     }
}
```
---

### getTokenArray
```
SunionBluetoothTool.shared.getTokenArray()
```
#### Delegate function
```
func TokenArray(value: [Int]?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | [Int]     | position of tokens  |

---
### getToken
```
SunionBluetoothTool.shared.getToken(count: Int)
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | Int     |  count of tokens |

#### Delegate function

```
func TokenData(value: TokenModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
---
### createToken
```
SunionBluetoothTool.shared.createToken(model: AddTokenModel)
```

#### Parameter

##### AddTokenModel
| Name | Type | Description |
| -------- | -------- | -------- |
|tokenName|  String | name of token
|tokenPermission|TokenPermission|all<br>limit

#### Delegate function
```
func TokenOption(value: AddTokenResult?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```

#### Parameter
##### AddTokenResult
| Name | Type | Description |
| -------- | -------- | -------- |
|isSuccess|  Bool | true<br>false
|index|Int| index of token
|token|[UInt8]| token byte

---
### delToken
```
SunionBluetoothTool.shared.delToken(model: TokenModel, ownerPinCode: String? = nil)
```

#### Parameter
| Name | Type | Description |
| -------- | -------- | -------- |
|model|  TokenModel | requestModel
| ownerPinCode| String| admincode

##### TokenModel
| Name | Type | Description |
| -------- | -------- | -------- |
|isEnable|  Bool | true<br>false
|tokenMode| TokenType|permanent<br>oneTime<br>invalid
|isOwnerToken|OwnerTokenType| owner<br>notOwner<br>error
|tokenPermission|CommandService.TokenPermission| owner<br>manager<br>user<br>none<br>error
|token|[UInt8]|token byte
|name|String| name of token
|indexOfToken| Int| index of token




#### Delegate function
```
func Token(bool: Bool?) {
     if let bool = bool {
        // do something here
     } else {
         // error
     }
}
```



 ---
### getTokenQrCode
```
SunionBluetoothTool.shared.getTokenQrCode(barcodeKey: String,tokenIndex: Int, aes1Key: Data, macAddress: String, userName: String, modelName: String, deviceName: String)
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
|barcodeKey|String| enCode QrCode
| tokenIndex     | Int     | position of token |
|aes1Key| Data | get it from QR code
| macAddress| String | bluetooth macAddress
| userName| String| name of share
| modelName | String | name of model
| deviceName | String | name of device

#### Delegate function
```
func TokenQrCode(value: String?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | String     | value of qrCdoe |

## DeviceConfigUsecase 


### get DeviceConfig
```
SunionBluetoothTool.shared.getDeviceConfigD4()
SunionBluetoothTool.shared.getDeviceConfigA2()
```

#### Delegate function
```
func DeviceConfig(value: DeviceSetupResultModel?) {
     if let value = value {
      
        if let D4 = value.D4 {
                  // do something here
                }
                
        if let A0 = value.A0 {
                  // do something here
                }
                
        if let N80 = value.N80 {
            // do something here
        }
     } else {
         // error
     }
}
```

#### parameter

##### DeviceSetupResultModel.D4
| Name | Type | Description |
| -------- | -------- | -------- |
|lockDirection|LockDirectionOption|Right<br>Left<br>unknown<br>error|
|soundOn|Boolean|true<br>false|
|vacationModeOn|Boolean|true<br>false|
|autoLockOn|Boolean|true<br>false|
|autoLockTime|Int|1~90 (1 for 10 seconds)|
|guidingCode|Boolean|true<br>false|
|laititude| Double| Latitude of lock location
|logitude| Double|  Logitude of lock location
##### DeviceSetupResultModel.A0
| Name | Type | Description |
| -------- | -------- | -------- |
|laititude| Double| Latitude of lock location
|logitude| Double|  Logitude of lock location
| direction| LockDirectionOption | left<br>right<br>unknown<br>ignore<br>unsupport<br>error
|guidingCode| CodeStatus| open<br>close<br>unsupport<br>error
|virtualCode| CodeStatus| open<br>close<br>unsupport<br>error
|twoFA| CodeStatus| open<br>close<br>unsupport<br>error
|vacationMode| CodeStatus| open<br>close<br>unsupport<br>error
|isAutoLock| CodeStatus| open<br>close<br>unsupport<br>error
|autoLockTime| Int| time of autolock
|autoLockMinLimit| Int| min time of autolock
|autoLockMaxLimit| Int | max time of autolock
|sound| CodeStatus| open<br>close<br>unsupport<br>error
|voiceType| VoiceType| onoff<br>level<br>percentage<br>error
|voiceValue| VoiceValue| open<br>close<br>loudly<br>whisper<br>value(Int)<br>error
|fastMode| CodeStatus| open<br>close<br>unsupport<br>error
##### DeviceSetupResultModel.A0
| Name | Type | Description |
| -------- | -------- | -------- |
|mainVersion|String| main of version
|subVersion|String| sub of version|
|formatVersion| String| format of version|
|serverversion| String| server of version|
|laititude| Double| Latitude of lock location
|logitude| Double|  Logitude of lock location
| direction| LockDirectionOption | left<br>right<br>unknown<br>ignore<br>unsupport<br>error
|guidingCode| CodeStatus| open<br>close<br>unsupport<br>error
|virtualCode| CodeStatus| open<br>close<br>unsupport<br>error
|twoFA| CodeStatus| open<br>close<br>unsupport<br>error
|vacationMode| CodeStatus| open<br>close<br>unsupport<br>error
|isAutoLock| CodeStatus| open<br>close<br>unsupport<br>error
|autoLockTime| Int| time of autolock
|autoLockMinLimit| Int| min time of autolock
|autoLockMaxLimit| Int | max time of autolock
|sound| CodeStatus| open<br>close<br>unsupport<br>error
|voiceType| VoiceType| onoff<br>level<br>percentage<br>error
|voiceValue| VoiceValue| open<br>close<br>loudly<br>whisper<br>value(Int)<br>error
|fastMode| CodeStatus| open<br>close<br>unsupport<br>error

---

### set DeviceConfig
```
SunionBluetoothTool.shared.setupDeviceConfig(data: DeviceSetupModel)
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| data     | DeviceSetupModel   | D5<br>A1<br>N81  |

##### DeviceSetupResultModel.D5
| Name | Type | Description |
| -------- | -------- | -------- |
|resetBolt|Bool| reset Bolt
|soundOn|Bool| sound on off
|vacationModeOn| Bool| vacationMode on off
|autoLockOn| Bool| autolock on off
|autoLockTime| Bool | time of autolock 
| guidingCode| Bool| guidingcode on off
| laititude| Double| Latitude of lock location
| longitude| Double|Longitude of lock location

##### DeviceSetupModel.A1
| Name | Type | Description |
| -------- | -------- | -------- |
| laititude| Double| Latitude of lock location
| longitude| Double|Longitude of lock location
| guidingCode| CodeStatus| open<br>close<br>unsupport<br>error
| virtualCode | CodeStatus| open<br>close<br>unsupport<br>error
|twoFA| CodeStatus| open<br>close<br>unsupport<br>error
|vacationModeOn| CodeStatus| open<br>close<br>unsupport<br>error
| autoLockOn| CodeStatus| open<br>close<br>unsupport<br>error
|autoLockTime| Int| time of autolock
| soundOn| CodeStatus| open<br>close<br>unsupport<br>error
|fastMode| CodeStatus| open<br>close<br>unsupport<br>error
|voiceValue|VoiceValue|open<br>close<br>loudly<br>whisper<br>value(Int)<br>error
|direction|LockDirectionOption|left<br>right<br>unknown<br>ignore<br>unsupport<br>error


##### DeviceSetupModel.N81
| Name | Type | Description |
| -------- | -------- | -------- |
| laititude| Double| Latitude of lock location
| longitude| Double|Longitude of lock location
| guidingCode| CodeStatus| open<br>close<br>unsupport<br>error
| virtualCode | CodeStatus| open<br>close<br>unsupport<br>error
|twoFA| CodeStatus| open<br>close<br>unsupport<br>error
|vacationModeOn| CodeStatus| open<br>close<br>unsupport<br>error
| autoLockOn| CodeStatus| open<br>close<br>unsupport<br>error
|autoLockTime| Int| time of autolock
| soundOn| CodeStatus| open<br>close<br>unsupport<br>error
|fastMode| CodeStatus| open<br>close<br>unsupport<br>error
|voiceValue|VoiceValue|open<br>close<br>loudly<br>whisper<br>value(Int)<br>error
|direction|LockDirectionOption|left<br>right<br>unknown<br>ignore<br>unsupport<br>error
|sabbathMode|CodeStatus| open<br>close<br>unsupport<br>error

#### [Delegate function](#DeviceStatus)


---
### FactoryReset
```
SunionBluetoothTool.shared.factoryReset(adminCode: [Int])
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| adminCode     | [Int]   | adminPinCode  |

#### Delegate function
```
func FactoryReset(bool: Bool?) {
    if let bool = bool {
        // do something here
    } else {
     // error
    }
}
```


## LockStatusUsecase 


### bolt check
```
SunionBluetoothTool.shared.boltCheck()
```

#### [Delegate function](#DeviceStatus)

---
### switch Device
```
SunionBluetoothTool.shared.switchDevice(mode: CommandService.DeviceMode)
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| model     | CommandService.DeviceMode     | lock<br>unlock  |

#### [Delegate function](#DeviceStatus)
---
### SupportType
```
SunionBluetoothTool.shared.getSupportType()
```

#### Delegate function
```
func SupportType(value: SupportDeviceTypesResponseModel?) {
    if let value = value {
        // do something here
    } else {
     // error
    }
}
```

#### Parameters
#####  SupportDeviceTypesResponseModel
| Name | Type | Description |
| -------- | -------- | -------- |
|AccessCode| Int| count of code
| AccessCard| Int| count of card
| Fingerprint| Int| count of finger
| Face| Int| count of face

## LogUsecase 


### Log count
```
SunionBluetoothTool.shared.getLogCount()
```

#### Delegate function
```
func LogCount(value: Int?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | Int     | count of log  |

---
### Log Data
```
SunionBluetoothTool.shared.getLog(count: value)
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | Int     | count of log  |

#### Delegate function
```
func LogData(value: LogModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```

#### Parameters
#####  LogModel
| Name | Type | Description |
| -------- | -------- | -------- |
|timestamp|  Double |time of log
|event| eventStatus|[Link](#eventStatus)
|name|String| name of log
|message|String| message of log

## PinCodeUsecase 


### PinCode Array

### command: D
```
SunionBluetoothTool.shared.getPinCodeArray()
```

#### Delegate function
```
func PinCodeArray(value: PinCodeArrayModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```


#### Parameters
#####  PinCodeArrayModel
| Name | Type | Description |
| -------- | -------- | -------- |
|count|  Int | pinCode length
|data|[Int]| pinCode data
|firstEmptyIndex|Int| empty of index

### command: A
```
SunionBluetoothTool.shared.getAccessArray()
```
#### Delegate function
```
func AccessArray(value: AccessArrayResponseModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```


#### Parameters
#####  AccessArrayResponseModel
| Name | Type | Description |
| -------- | -------- | -------- |
|type|  AccessTypeOption | AccessCode<br>AccessCard<br>Fingerprint<br>Face<br>error
|finish|Bool| data finished
|hasDataAIndex|[Int]| data array
| datalen| Int| length of data
---
### PinCode Data
### command: D
```
SunionBluetoothTool.shared.getPinCode(position: Int)
```

#### Parameters
| Parameter | Type | Description |
| -------- | -------- | -------- |
| position    |  Int | position of Pincode

#### Delegate function
```
func PinCodeData(value: PinCodeModelResult?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```


#### Parameters
##### PinCodeModelResult
| Name | Type | Description |
| -------- | -------- | -------- |
|isEnable|  Bool | true<br>false
|PinCode|[UInt8]|  data of PinCode
|PinCodeLength|UInt8|  length of PinCode
|name| String | name of PinCode
| schedule| PinCodeScheduleResult | all<br>none<br>once<br>weekly<br>validTime<br>error

### command: A
```
SunionBluetoothTool.shared.searchAccess(model: SearchAccessRequestModel)
```
#### Parameters
##### SearchAccessRequestModel
| Name | Type | Description |
| -------- | -------- | -------- |
|accessType|  AccessTypeMode | AccessCode<br>AccessCard<br>Fingerprint<br>Face
|index | Int|  position of Access

#### Delegate function
```
func SearchAccess(value: AccessDataResponseModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```


#### Parameters
##### AccessDataResponseModel
| Name | Type | Description |
| -------- | -------- | -------- |
|isEnable|  Bool | true<br>false
| type|  AccessTypeOption | AccessCode<br>AccessCard<br>Fingerprint<br>Face<br>error
|index| Int| position of Access
|nameLength| Uint8| length of name
| name| String| name of access
| codeCard| String| value of access
|schedule| UserCodeScheduleResult| all<br>none<br>once<br>weekly<br>validTime<br>error
---
### setup Access 

### command: A
```
SunionBluetoothTool.shared.setupAccess(model: SetupAccessRequestModel)
```

#### Parameters
##### SetupAccessRequestModel
| Name | Type | Description |
| -------- | -------- | -------- |
|index|  Int | position of Access
| accessType|  AccessTypeOption | AccessCode<br>AccessCard<br>Fingerprint<br>Face<br>error
|state| AccessStateMode | start<br>quit


#### Delegate function
```
func  SetupAccess(value: SetupAccessResponseModel?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```

#### Parameters
##### SetupAccessResponseModel
| Name | Type | Description |
| -------- | -------- | -------- |
| type|  AccessTypeOption | AccessCode<br>AccessCard<br>Fingerprint<br>Face<br>error
|index| Int| position of Access
|isSuccess| Bool| successed
|state |setupAccessOption|start<br>quit<br>updat<br>error
---
### add/Edit PinCode 

### command: D
```
SunionBluetoothTool.shared.pinCodeOption(model: PinCodeManageModel)
```

#### Parameters
##### PinCodeManageModel
| Name | Type | Description |
| -------- | -------- | -------- |
|index|  Int | position of PinCode
|isEnable|Bool|  true<br>false
|PinCode|[Int]|  data of PinCode
|name| String | name of PinCode
| schedule| PinCodeScheduleResult | all<br>none<br>once<br>weekly<br>validTime<br>error
|PinCodeManageOption| PinCodeManageOption | add<br>edit

#### Delegate function
```
func PinCode(bool: Bool?){
     if let bool = bool {
        // do something here
     } else {
         // error
     }
}
```
### command: A
```
SunionBluetoothTool.shared.accessAction(model: AccessRequestModel)
```
#### Parameters
##### AccessRequestModel
| Name | Type | Description |
| -------- | -------- | -------- |
|index|  Int | position of access
|isEnable|Bool|  true<br>false
| type|  AccessTypeOption | AccessCode<br>AccessCard<br>Fingerprint<br>Face<br>error
|name| String | name of access
| codecard| String| value of access
| schedule| PinCodeScheduleResult | all<br>none<br>once<br>weekly<br>validTime<br>error
| accessOption| accesseOption| add<br>edit

#### Delegate function
```
func AccessAction(value: AccessResponseModel?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```


#### Parameters
##### AccessResponseModel
| Name | Type | Description |
| -------- | -------- | -------- |
| type|  AccessTypeOption | AccessCode<br>AccessCard<br>Fingerprint<br>Face<br>error
|index| Int| position of Access
|isSuccess| Bool| successed

---
### Delete PinCode 
### command: D
```
SunionBluetoothTool.shared.delPinCode(position: Int) 
```

#### Parameters
| Parameter | Type | Description |
| -------- | -------- | -------- |
| position    |  Int | location of PinCode

#### Delegate function
```
func PinCode(bool: Bool?){
     if let bool = bool {
        // do something here
     } else {
         // error
     }
}
```

### command: A
```
SunionBluetoothTool.shared.delAccess(model: DelAccessRequestModel) 
```

#### Parameters
##### DelAccessRequestModel
| Name | Type | Description |
| -------- | -------- | -------- |
|accessType|  AccessTypeMode | AccessCode<br>AccessCard<br>Fingerprint<br>Face
|index | Int|  position of Access

#### Delegate function
```
func DelAccess(value: DelAccessResponseModel?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```

#### Parameters
##### DelAccessResponseModel
| Name | Type | Description |
| -------- | -------- | -------- |
| type|  AccessTypeOption | AccessCode<br>AccessCard<br>Fingerprint<br>Face<br>error
|index| Int| position of Access
|isSuccess| Bool| successed

---
## Wifi
### WifiList 

```
SunionBluetoothTool.shared.wifiList()
```



#### Delegate function
```
func  SetupAccess(value: SSIDModel?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameters
##### SSIDModel
| Name | Type | Description |
| -------- | -------- | -------- |
| passwordLevel |  PasswordLevel |  required<br> none<br>completed <br>unknown
|name| String| Wifi Name

---

### ConnectWifi 

```
SunionBluetoothTool.shared.connectWifi(SSIDName: String, passwrod: String)

```
#### Parameters
| Name | Type | Description |
| -------- | -------- | -------- |
| SSIDName |  String |  wifi Name
|passwrod| String| Wifi password


#### Delegate function
```
step1: 

func  connectWifi(value: Bool?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}

step2: 

func  connectMQTT(value: Bool?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}

step3: 

func  connectCloud(value: Bool?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
---
### wifiAutoUnlcok 

```
SunionBluetoothTool.shared.wifiAutoUnlock(identity: String )
```
#### Parameters
##### OTAStatusRequestModel
| Name | Type | Description |
| -------- | -------- | -------- |
| identity |  String |  user identityID




#### Delegate function [LINK](#DeviceStatus)
```
func DeviceStatus(value: DeviceStatusModel?) {...}
```
---
### iswifiAutoUnlock 

```
SunionBluetoothTool.shared.iswifiAutoUnlock(identity: String )
```
#### Parameters
##### OTAStatusRequestModel
| Name | Type | Description |
| -------- | -------- | -------- |
| identity |  String |  user identityID




#### Delegate function [LINK](#DeviceStatus)
```
func isWifiAutonunlock(bool: Bool?) {
    if let bool = bool {
        // do something here
     } else {
         // error
     }
}
```

---
## OTA
### OTAStatus 

```
SunionBluetoothTool.shared.otaStatus(req: OTAStatusRequestModel)
```
#### Parameters
##### OTAStatusRequestModel
| Name | Type | Description |
| -------- | -------- | -------- |
| target |  otaTarget |  wireless<br> mcu
|state| otaState| start<br>finish<br>cancel
| fileSize| Int| update data size|
|IV| String | initial vactor
|Signature| String | file identify



#### Delegate function
```
func  OTAStatus(value: OTAResponseModel?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameters
##### OTAResponseModel
| Name | Type | Description |
| -------- | -------- | -------- |
| target |  otaTarget |  wireless<br> mcu
|state| otaState| start<br>finish<br>cancel
|isSuccess|Bool| data update success

### OTAData 

```
SunionBluetoothTool.shared.otaData(req: OTADataRequestModel)
```
#### Parameters
##### OTADataRequestModel
| Name | Type | Description |
| -------- | -------- | -------- |
| offset |  Int |  file location
|data| [Uint8]| value of file




#### Delegate function
```
func  OTAData(value: OTADataResponseModel?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameters
##### OTAResponseModel
| Name | Type | Description |
| -------- | -------- | -------- |
| offset |  Int |  file location
|data| [Uint8]| value of file

---
## RFVersion

```
SunionBluetoothTool.shared.getRFVersion()
```


#### Response
```
SunionBluetoothTool.shared.data.RFVersion
```


---
## Usercredential
### Array
```
SunionBluetoothTool.shared.getUserCredentialArray()
```
#### Delegate function
```
func userCredentialArray(value: [Int]?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | [Int]     | position of users  |

---
### Data
```
SunionBluetoothTool.shared.getUserCredential(position: Int)
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| position     | Int     | position of user  |

#### Delegate function
```
func userCredentialData(value: UserCredentialModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
##### UserCredentialModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| index     | Int     | position of user  |
|name| String| name of user|
| uid| String| auth of user|
status| UserStatusEnum| available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue|
|type| UserTypeEnum| unrestrictedUser<br>yearDayScheduleUser<br>weekDayScheduleUser<br>programmingUser<br>nonAccessUser<br>forcedUser<br>disposableUser<br>expiringUser<br>scheduleRestrictedUser<br>remoteOnlyUser<br>unknownEnumValue|
|credentialRule|CredentialRuleEnum|single<br>dual<br>tri<br>unknownEnumValue|
|credentialStruct|[CredentialStructModel]| [LINK](#CredentialStructModel)
|weekDayscheduleStruct|[WeekDayscheduleStructModel]|[LINK](#WeekDayscheduleStructModel)|
|yearDayscheduleStruct|[YearDayscheduleStructModel]|[LINK](#YearDayscheduleStructModel)|


###### CredentialStructModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| index     | Int     | position of User  |
|type|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue<br>|

###### WeekDayscheduleStructModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| status     | ScheduleStatusEnum     | available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue<br> |
|daymask| DaysMaskMap|sunday<br>monday<br>tuesday<br>wednesday<br>thursday<br>friday<br>saturday|
|startHour|String| start hour time|
|startMinute|String| start Minute time|
|endHour| String | end hour time|
|endMinute| String| end Minute time

###### YearDayscheduleStructModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| status     | ScheduleStatusEnum     | available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue<br> |
|start| Date| start time
| end| Date | end time

---

### Create/Edit
```
SunionBluetoothTool.shared.userCredentialAction(model: UserCredentialModel, isCreate: Bool)
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| model     | UserCredentialModel     | [LINK](#UserCredentialModel)  |
|isCreate| Bool| true: create<br> false: edit

#### Delegate function
```
func func userCredentialAction(value: N9ResponseModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | N9ResponseModel     | [LINK](#N9ResponseModel)|
##### N9ResponseModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| index     | Int     | position of User|
| isSuccess| Bool |  success or fail|

---

### Delete
```
SunionBluetoothTool.shared.delUserCredentialAction(model: IndexUserCredentialRequestModel)
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| model     | IndexUserCredentialRequestModel     | position of of Uer |


#### Delegate function
```
func func delUserCredentialAction(value: N9ResponseModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | N9ResponseModel     | [LINK](#N9ResponseModel)|
##### N9ResponseModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| index     | Int     | position of User|
| isSuccess| Bool |  success or fail|

---
### hashUserCredential
```
SunionBluetoothTool.shared. hashUserCredential(model: HashusercredentialRequestModel)
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| model     | HashusercredentialRequestModel     | user<br>credential<br>error |


#### Delegate function
```
func func hashUserCredential(value: HashusercredentialModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | HashusercredentialModel     | user<br>credential<br>error |

##### HashusercredentialModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| target     | HashTargetEnum     | user<br>credential<br>error |
|data|[UInt8]| data of hash

---
### syncUserCredential
```
SunionBluetoothTool.shared.yncUserCredential()
```

#### Delegate function
```
func func syncUserCredential(value: Bool?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
---
### finishSyncData
```
SunionBluetoothTool.shared.finishSyncData() 
```

#### Delegate function
```
func func finishSyncData(value: Bool?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
---
### Able
```
SunionBluetoothTool.shared.userAble()
```

#### Delegate function
```
func func userAble(value: UserableResponseModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | UserableResponseModel     |[LINK](#UserableResponseModel)  |

##### UserableResponseModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| isMatter     | Bool     |true<br>false  |
|weekdayCount| Int| count of weekday|
|yeardayCount| Int| count of yearday|
|codeCount| Int| count of code|
|cardCount| Int| count of card|
|fpCount|Int| count of fp|
|faceCount|Int| count of face

---
## Credential
### Array
```
SunionBluetoothTool.shared.getCredentialArray()
```
#### Delegate function
```
func getCredentialArray(value: [Int]?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | [Int]     | position of Credentials  |

---
### Data
```
SunionBluetoothTool.shared.earchCredential(model: SearchCredentialRequestModel)
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| model     | SearchCredentialRequestModel     |  [LINK](#SearchCredentialRequestModel) |

##### SearchCredentialRequestModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| index     | Int     |  position of Credential |
| format | FormatEnum| user<br>credential

#### Delegate function
```
func searchCredential(value: CredentialModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | CredentialModel     | [LINK](#CredentialModel)  |

##### CredentialModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| format | FormatEnum| user<br>credential
|credientialIndex| int| position of Credential
| userIndex| int | position of user|
|status| UserStatusEnum|available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue|
|type|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue|
|credentialData|String| value of credential|
|credentialDetailStruct| [CredentialDetailStructModel]|[LINK](#CredentialDetailStructModel)|


##### CredentialDetailStructModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| format | FormatEnum| user<br>credential
|status| UserStatusEnum|available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue|
|type|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue|
|data|String| value of credential|

---
### Action
```
SunionBluetoothTool.shared.credentialAction(model: CredentialRequestModel, isCreate: Bool) 
```

#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| model     | CredentialRequestModel     |  [LINK](#CredentialRequestModel) |
|isCreate| Bool| create or not

##### CredentialRequestModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| format | FormatEnum| user<br>credential
|credientialIndex| int| position of Credential
| userIndex| int | position of user|
|status| UserStatusEnum|available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue|
|type|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue|
|credentialData|String| value of credential|
|credentialDetailStruct| [CredentialDetailStructRequestModel]|[LINK](#CredentialDetailStructRequestModel)|
|isCreate| Bool | create or not

##### CredentialDetailStructRequestModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| format | FormatEnum| user<br>credential
|status| UserStatusEnum|available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue|
|type|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue|
|data|String| value of credential|


#### Delegate function
```
func credentialAction(value: N9ResponseModel?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | N9ResponseModel     | [LINK](#N9ResponseModel)|
##### N9ResponseModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| index     | Int     | position of User|
| isSuccess| Bool |  success or fail|

---
### setUp
```
SunionBluetoothTool.shared.setupCredential(model: SetupCredentialRequestModel)
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| model     | SetupCredentialRequestModel     | [LINK](#SetupCredentialRequestModel)|
##### SetupCredentialRequestModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| accessType|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue|
|state| setupAccessOption|start<br>quit<br>update|
|index|int|position of credential|
#### Delegate function
```
func setupCredential(value: SetupCredentialModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | SetupCredentialModel    | [LINK](#SetupCredentialModel)  |

#### SetupCredentialModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| type|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue|
|state| setupAccessOption|start<br>quit<br>update|
|index|int|position of credential|
|isSuccess|Bool|success or not|
|data| [Uint8]| value of credential|
|faceError| String|  message of face|

---
### Delete
```
SunionBluetoothTool.shared.delCredential(model: IndexUserCredentialRequestModel) 
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| model     | IndexUserCredentialRequestModel     | position of of Uer |

#### Delegate function
```
func delCredential(value: N9ResponseModel?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
#### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
| value     | N9ResponseModel     | [LINK](#N9ResponseModel)|
##### N9ResponseModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| index     | Int     | position of User|
| isSuccess| Bool |  success or fail|

---
## isAutoUnlock
```
SunionBluetoothTool.shared.isAutoUnLock()
```

#### Delegate function
```
func isAutoUnLock(value: Bool?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
---
## isMatter
```
SunionBluetoothTool.shared.isMatter()
```

#### Delegate function
```
func isMatter(value: Bool?){
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
---
## Models
### QRCodeContent

| Name | Type | Description |
| -------- | -------- | -------- |
|T|String|Default connection token|
|K|String|Encryption key of data transmission|
|A|String|MAC address of lock|
|M|String|Model name of lock|
|S|String|Optional value, serial number of lock|
|F|String|Optional value, shared from username|
|L|String|Optional avlue, display name of lock|





#### eventStatus
| Name | Type | Value |
| -------- | -------- | -------- |
|event|Int|0: Auto lock close success<br>1: Auto lock close fail<br>2: App lock close success<br>3: App lock close fail<br>4: Physical button close success<br>5: Physical button close fail<br>6: Close the door manually success<br>7: Close the door manually fail<br>8: App lock open success<br>9: App lock open fail<br>10: Physical button open success<br>11: Physical button open fail<br>12: Open the door manually success<br>13: Open the door manually fail<br>14: Card open the door success<br>15: Card open the door fail<br>16: Fingerprint open the door success<br>17: Fingerprint open the door fail<br>18: Face open the door success<br>19: Face open the door fail<br>20: TwoFA open the door success<br>21: TwoFA open the door fail<br>64: Add token<br>65: Edit token<br>66: Delete token<br>80: Add access code<br>81: Edit access code<br>82: Delete access code<br>83: Add access card<br>84: Edit access card<br>85: Delete access card<br>86: Add fingerprint<br>87: Edit fingerprint<br>88: Delete fingerprint<br>89: Add face<br>90: Edit face<br>91: Delete face<br>128: Wrong password<br>129: Connection error<br>130: At wrong time enter correct password<br>131: At vacation mode enter not admin password<br>132: Wrong access card<br>133: Wrong fingerprint<br>134: Wrong face<br>135: TwoFA error|


















## Delegation Funcation

### DeviceStatus

```
func DeviceStatus(value: DeviceStatusModel?) {
    if let value = value {
    
        if let D6 = value.D6 {
          // do something here
        }
        
        if let A2 = value.A2 {
          // do something here
        }
        
        if let N82 = vlaue.N82 {
            // do something here
        }
        
        if let AF = value.AF {
         // do something here
        }
    
    } else {
     // error
    }
}
```

#### Parameters




##### DeviceStatusModel.D6
| Name | Type | Description |
| -------- | -------- | -------- |
|lockDirection|LockDirectionOption|Right<br>Left<br>unknown<br>error|
|soundOn|Boolean|true<br>false|
|vacationModeOn|Boolean|true<br>false|
|autoLockOn|Boolean|true<br>false|
|autoLockTime|Int|1~90 (1 for 10 seconds)|
|guidingCode|Boolean|true<br>false|
|isLocked | LockOption | locked<br>unlocked<br>error<br>loading
|battery|Int|Percentage of battery power|
|batteryWarning|BatteryWarningOption|normal<br>low<br>emergancy<br>error|
|timestamp|Double|Time of lock|



#####  DeviceStatusModel.A2
| Name | Type | Description |
| -------- | -------- | -------- |
|lockDirection|LockDirectionOption|Right<br>Left<br>unknown<br>ignore<br>unsupport<br>error|
|vacationModeOn|CodeStatus|open<br>close<br>unsupport<br>error|
|deadBolt|DeadboltStatus|protrude<br>retract<br>unsupport<br>error
|doorState|DoorStateStatus|close<br>unclose<br>unsupport<br>error
|lockState|LockStateSatus|lockedUnlinked<br>unlockedLinked<br>unknow<br>error
|securityBolt|SecruityboltStatus|protrude<br>unprotrude<br>unsupport<br>error
|battery|Int| number
|batteryWarning|BatteryWarningOption|normal<br>low<br>emergancy<br>error


#####  DeviceStatusModel.N82
| Name | Type | Description |
| -------- | -------- | -------- |
|mainVersion|String| main of version|
|subVerssion| String| sub of version|
|lockDirection|LockDirectionOption|Right<br>Left<br>unknown<br>ignore<br>unsupport<br>error|
|vacationModeOn|CodeStatus|open<br>close<br>unsupport<br>error|
|deadBolt|DeadboltStatus|protrude<br>retract<br>unsupport<br>error
|doorState|DoorStateStatus|close<br>unclose<br>unsupport<br>error
|lockState|LockStateSatus|lockedUnlinked<br>unlockedLinked<br>unknow<br>error
|securityBolt|SecruityboltStatus|protrude<br>unprotrude<br>unsupport<br>error
|battery|Int| number
|batteryWarning|BatteryWarningOption|normal<br>low<br>emergancy<br>error

##### DeviceStatusModel.AF-

| Name | Type | Description |
| -------- | -------- | -------- |
|type| alertType| errorAccess<br>correctButErrortime<br>correctButVacationMode<br>moreError<br>broken


