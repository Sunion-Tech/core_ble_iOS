
# Pairing with lock
When pairing with the lock, you can obtain the lock's connection information by scanning the lock's QR code. You can use the following example to filter the QR code information:
```
let response = SunionBluetoothTool.shared.decodeQrCode(barcodeKey: String, qrCode: String)
```
### Parameter
| Parameter | Type | Description |
| -------- | -------- | -------- |
|barcodeKey | String | get from FU HSING
|qrCode| String | qrCode Value

# IncomingDeviceStatusUseCase
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
# USECASE
|name|
|-|
|[adminCode](#AdminCodeUseCase)|
|[time](#LockTimeUseCase)|
|[name](#LockNameUsecase)|
|[token](#TokenUsecase)|
|[config](#DeviceConfigUsecase)|
|[status](#LockStatusUsecase)|
|[log](#LogUsecase)|
|[pinCode](#PinCodeUsecase)|
|[qrCode model](#Models)|
|[delegate](#Delegate)|




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
|indexOfToken| Int| index of token<br>Add from tokenArray 




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
| data     | DeviceSetupModel   | D5<br>A1  |

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

### Version1
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

### Version2
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
### Version1
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
|index|Int|Add from PinCodeArray 

### Version2
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

### Version2
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

### Version1
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
### Version2
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
### Version1
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

### Version2
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


















## Delegate 

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


##### DeviceStatusModel.AF-

| Name | Type | Description |
| -------- | -------- | -------- |
|type| alertType| errorAccess<br>correctButErrortime<br>correctButVacationMode<br>moreError<br>broken


