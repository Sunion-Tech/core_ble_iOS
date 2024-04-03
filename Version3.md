# USECASE
|name|
|-|
|[deviceStatus](#deviceStatus)|
|[time](#time)|
|[adminCode](#adminCode)|
|[name](#name)|
|[direction](#direction)|
|[config](#config)|
|[utility](#utility)|
|[token](#token)|
|[log](#log)|
|[wifi](#wifi)|
|[plug](#plug)|
|[ota](#ota)|
|[user](#user)|
|[credential](#credential)|

## deviceStatus
### Get DeviceStatus
```
SunionBluetoothTool.shared.Usecase.deviceStatus.data()
```
### Toggle lock
```
SunionBluetoothTool.shared.Usecase.deviceStatus.lockorUnlock(value: CommandService.DeviceMode)
```
#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| value     | CommandService.DeviceMode     | lock<br>unlock|
### Delegate function
```
 public func v3deviceStatus(value: DeviceStatusModelN82?) {
     if let value = value {
          // do something here
     } else {
         // error
     }
 }
```


#####  DeviceStatusModelN82
| Name | Type | Description |
| -------- | -------- | -------- |
|mainVersion|Int| main of version|
|subVerssion| Int| sub of version|
|lockDirection|LockDirectionOption|Right<br>Left<br>unknown<br>ignore<br>unsupport<br>error|
|vacationModeOn|CodeStatus|open<br>close<br>unsupport<br>error|
|deadBolt|DeadboltStatus|protrude<br>retract<br>unsupport<br>error
|doorState|DoorStateStatus|close<br>unclose<br>unsupport<br>error
|lockState|LockStateSatus|lockedUnlinked<br>unlockedLinked<br>unknow<br>error
|securityBolt|SecruityboltStatus|protrude<br>unprotrude<br>unsupport<br>error
|battery|Int| number
|batteryWarning|BatteryWarningOption|normal<br>low<br>emergancy

---
## time 

### Set the current time on the phone
```
SunionBluetoothTool.shared.Usecase.time.syncCurrentTime()
```
### Set the TimeZone
```
SunionBluetoothTool.shared.Usecase.time.setTimeZone(value: String)
```
#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| value     | String     | Time-zone ID, such as Asia/Taipei    |


### Delegate function
```
func v3time(value: resTimeUseCase?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```

##### resTimeUseCase
| Parameters | Type | Description |
| -------- | -------- | -------- |
| isSavedTime     | Bool     | Verify if setting the time was successful  |
|isSavedTimeZone|Bool| Verify if setting the timeZone was successful

---

## adminCode 
### Set adminCode
```
SunionBluetoothTool.shared.Usecase.adminCode.set(value: String)
```
#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| value     | String     | Digit limit 4-8, numbers only |

### Edit adminCode

```
SunionBluetoothTool.shared.Usecase.adminCode.edit(old: String, new: String)
```

#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| old     | String     | old adminCode |
|new|String| new adminCode, Digit limit 4-8, numbers only |


### adminCode Exists
```
SunionBluetoothTool.shared.Usecase.adminCode.exists()
```


### Delegate function

```
func v3adminCode(value: resAdminCodeUseCase?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
##### resAdminCodeUseCase
| Parameters | Type | Description |
| -------- | -------- | -------- |
| isCreated     | Bool     | Verify if setting the adminCode was successful  |
|isEdited|Bool| Verify if Edit the adminCode was successful|
|isExisted|Bool| adminCode exists or not

---
## name
### Retrieve name
```
SunionBluetoothTool.shared.Usecase.name.data()
```
### Edit name
```
SunionBluetoothTool.shared.Usecase.name.set(value: String) 
```

#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| value     | String     | Length must not exceed 20|

### Delegate function

```
func v3Name(value: resNameUseCase?) {
     if let value = value {
        // do something here
     } else {
         // error
     }
}
```
##### resNameUseCase
| Parameters | Type | Description |
| -------- | -------- | -------- |
| isConfigured     | Bool     | Verify if edited the name was successful  |
|data|String| data of name

---

## direction

### Door direction judgment
```
SunionBluetoothTool.shared.Usecase.direction.checkDoorDirection()
```
### Delegate function
```
 public func v3deviceStatus(value: DeviceStatusModelN82?) {
     if let value = value {
          // do something here
     } else {
         // error
     }
 }
```


#####  DeviceStatusModelN82
| Name | Type | Description |
| -------- | -------- | -------- |
|mainVersion|Int| main of version|
|subVerssion| Int| sub of version|
|lockDirection|LockDirectionOption|Right<br>Left<br>unknown<br>ignore<br>unsupport<br>error|
|vacationModeOn|CodeStatus|open<br>close<br>unsupport<br>error|
|deadBolt|DeadboltStatus|protrude<br>retract<br>unsupport<br>error
|doorState|DoorStateStatus|close<br>unclose<br>unsupport<br>error
|lockState|LockStateSatus|lockedUnlinked<br>unlockedLinked<br>unknow<br>error
|securityBolt|SecruityboltStatus|protrude<br>unprotrude<br>unsupport<br>error
|battery|Int| number
|batteryWarning|BatteryWarningOption|normal<br>low<br>emergancy

---

## config 
### Config data
```
SunionBluetoothTool.shared.Usecase.config.data()
```
### Set Config
```
SunionBluetoothTool.shared.Usecase.config.set(model: DeviceSetupModelN81)
```
#### DeviceSetupModelN81
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
|voiceType|VoiceType|onoff<br>level<br>percentage<br>error
|voiceValue|VoiceValue|open<br>close<br>loudly<br>whisper<br>value(Int)<br>error
|direction|LockDirectionOption|left<br>right<br>unknown<br>ignore<br>unsupport<br>error
|sabbathMode|CodeStatus| open<br>close<br>unsupport<br>error

### Delegate function
```
 public func v3Config(value: resConfigUseCase?) {
     if let value = value {
          // do something here
     } else {
         // error
     }
 }
```
##### resConfigUseCase
| Parameters | Type | Description |
| -------- | -------- | -------- |
| isConfigured     | Bool     | Verify if edited the config was successful  |
|data|DeviceSetupResultModelN80| [LINK](#DeviceSetupResultModelN80)

##### DeviceSetupResultModelN80
| Parameters | Type | Description |
| -------- | -------- | -------- |
|mainVersion| Int| main of version|
|subVerssion| Int| sub of version|
|formatVersion| Int| format of version|
|serverversion| Int| server of version|
| laititude| Double| Latitude of lock location
| longitude| Double|Longitude of lock location
|direction|LockDirectionOption|left<br>right<br>unknown<br>ignore<br>unsupport<br>error
| guidingCode| CodeStatus| open<br>close<br>unsupport<br>error
| virtualCode | CodeStatus| open<br>close<br>unsupport<br>error
|twoFA| CodeStatus| open<br>close<br>unsupport<br>error
|vacationModeOn| CodeStatus| open<br>close<br>unsupport<br>error
| autoLockOn| CodeStatus| open<br>close<br>unsupport<br>error
|autoLockTime| Int| time of autolock
|autoLockMinLimit| Int| min of autoLockTime|
|autoLockMaxLimit| Int| max of autoLockTime|
| soundOn| CodeStatus| open<br>close<br>unsupport<br>error
|fastMode| CodeStatus| open<br>close<br>unsupport<br>error
|voiceType|VoiceType|onoff<br>level<br>percentage<br>error
|voiceValue|VoiceValue|open<br>close<br>loudly<br>whisper<br>value(Int)<br>error
|sabbathMode|CodeStatus| open<br>close<br>unsupport<br>error

---
## utility
### device Version
```
SunionBluetoothTool.shared.Usecase.utility.version(type: RFMCURequestModel.versionType)
```
#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| type     | RFMCURequestModel.versionType    | RF<br>MCU|

### factoryReset
```
SunionBluetoothTool.shared.Usecase.utility.factoryResetDevice(adminCode: String)
```
#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| adminCode     | String    | value of adminCode|

### factoryResetPlug
```
SunionBluetoothTool.shared.Usecase.utility.factoryResetPlug() 
```

### MatterDevice
```
SunionBluetoothTool.shared.Usecase.utility.isMatter()
```

### Delegate function
```
 public func v3utility(value: resUtilityUseCase?) {
     if let value = value {
          // do something here
     } else {
         // error
     }
 }
```

##### resUtilityUseCase
| Parameters | Type | Description |
| -------- | -------- | -------- |
|version| RFMCUversionModel| [LINK](#RFMCUversionModel)
|isFactoryReset| Bool|Verify if factoryReset was successful
|isPlugFactoryReset| Bool| Verify if factoryReset was successful
|isMatter|Bool| device is matter or not
|alert|AlertResponseModel|Returns from here when the device is abnormal, [LINK](#AlertResponseModel)


##### RFMCUversionModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
|type|RFMCURequestModel.versionType| RF<br>MCU
|version| String| version of type

#### AlertResponseModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
|type|  CommandService.alertType|errorAccess<br>correctButErrortime<br>correctButVacationMode<br>activelyPressClearKey<br>moreError<br>broken

---
## token
### array
```
SunionBluetoothTool.shared.Usecase.token.array()
```

### data
```
SunionBluetoothTool.shared.Usecase.token.data(position: Int)
```
#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| position     | index    | location of the token |

### create
```
SunionBluetoothTool.shared.Usecase.token.create(model: AddTokenModel)
```
#### AddTokenModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| tokenName     | String    | name of the token |
|tokenPermission|TokenPermission|all<br>limit

### edit
```
SunionBluetoothTool.shared.Usecase.token.edit(model: EditTokenModel)
```
#### EditTokenModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| tokenName     | String    | name of the token |
|tokenPermission|TokenPermission|all<br>limit|
|tokenIndex| Int| location of the token|
### delete
```
SunionBluetoothTool.shared.Usecase.token.delete(model: TokenModel)
```
#### TokenModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| isEnable     | Bool    | enable of the token |
|tokenMode|TokenType|permanent<br>oneTime<br>invalid|
|isOwnerToken| OwnerTokenType| owner<br>notOwner<br>error|
|tokenPermission|TokenPermission|all<br>limit|
|token|[UInt8]| data of the token
| name     | String    | name of the token |

### Delegate function
```
 public v3Token(value: resTokenUseCase?) {
     if let value = value {
          // do something here
     } else {
         // error
     }
 }
```

##### resTokenUseCase
| Parameters | Type | Description |
| -------- | -------- | -------- |
|array| [Int]| location where the Token is stored
|data|TokenModel|[LINK](#TokenModel)
|created|addTokenResult|[LINK](#addTokenResult)
|isEdited|Bool| Verify if edited the token was successful
|isDeleted|Bool| Verify if deleted the token was successful

##### addTokenResult
| Parameters | Type | Description |
| -------- | -------- | -------- |
|isSuccess|Bool| Verify if create the token was successful
|index|Int|location of the token|
|token|[UInt8]| data of the token

---

## log

### count
```
SunionBluetoothTool.shared.Usecase.log.count()
```

### data
```
SunionBluetoothTool.shared.Usecase.log.data(position: Int)
```
#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| position     | index    | location of the log |

### Delegate function
```
 public v3Log(value: resLogUseCase?) {
     if let value = value {
          // do something here
     } else {
         // error
     }
 }
```

##### resLogUseCase
| Parameters | Type | Description |
| -------- | -------- | -------- |
|count| [Int]| total number of logs|
|data|LogModel|[LINK](#LogModel)

##### LogModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
|timestamp|Double| time of log
|event|Int| number of event [LINK](#eventType)
|name| String| name of log
|message|String| message of log


#### eventType
| Type  | Description               |
|:-----:|:-------------------------:|
|  0    | Auto close door success   |
|  1    | Auto close door failure   |
|  2    | App close door success    |
|  3    | App close door failure    |
|  4    | Button close door success |
|  5    | Button close door failure |
|  6    | Manual close door success |
|  7    | Manual close door failure |
|  8    | App open door success     |
|  9    | App open door failure     |
|  10   | Button open door success  |
|  11   | Button open door failure  |
|  12   | Manual open door success  |
|  13   | Manual open door failure  |
|  14   | Card open door success    |
|  15   | Card open door failure    |
|  16   | Fingerprint open door success |
|  17   | Fingerprint open door failure |
|  18   | Face open door success    |
|  19   | Face open door failure    |
|  20   | TwoFA open door success   |
|  21   | TwoFA open door failure   |
|  22   | Matter open door success  |
|  23   | Matter open door failure  |
|  24   | Matter close door success |
|  25   | Matter close door failure |
|  64   | Add Token                 |
|  65   | Edit Token                |
|  66   | Delete Token              |
|  80   | Add AccessCode            |
|  81   | Edit AccessCode           |
|  82   | Delete AccessCode         |
|  83   | Add AccessCard            |
|  84   | Edit AccessCard           |
|  85   | Delete AccessCard         |
|  86   | Add Fingerprint           |
|  87   | Edit Fingerprint          |
|  88   | Delete Fingerprint        |
|  89   | Add Face                  |
|  90   | Edit Face                 |
|  91   | Delete Face               |
|  92   | Add User                  |
|  93   | Edit User                 |
|  94   | Delete User               |
|  128  | Wrong password            |
|  129  | Connection error          |
|  130  | Input valid password during incorrect time slot |
|  131  | Input non-admin password in holiday mode |
|  132  | Wrong card                |
|  133  | Wrong fingerprint         |
|  134  | Wrong face                |
|  135  | 2FA error                 |

---

## wifi

### list
```
SunionBluetoothTool.shared.Usecase.wifi.list()
```
### configure Wifi
```
SunionBluetoothTool.shared.Usecase.wifi.configureWiFi(SSIDName: String, password: String) 
```
#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| SSIDName     | String    | name of the wifi |
|password| String| password of the wifi|

### autoUnlock

```
SunionBluetoothTool.shared.Usecase.wifi.autoUnlockForWiFi(identity: String)
```
#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| identity     | String    | data from device bluetooth |

### waitButtonAutonUnlock
```
SunionBluetoothTool.shared.Usecase.wifi.waitForButtonThenAutoUnlockWiFi(identity: String)
```
#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| identity     | String    | data from device bluetooth |


### Delegate function
```
 public v3Wifi(value: resWifiUseCase?)  {
     if let value = value {
          // do something here
     } else {
         // error
     }
 }
```

##### resWifiUseCase
| Parameters | Type | Description |
| -------- | -------- | -------- |
|list|SSIDModel|[LINK](#SSIDModel)
|status|DeviceStatusModelN82|[LINK](#DeviceStatusModelN82)
|isWifi|Bool|Verify if conncted the wifi was successful
|isMQTT|Bool|Verify if conncted the MQTT was successful
|isClould|Bool|Verify if conncted the Clould was successful
|isAutoUnlock|Bool| 

##### SSIDModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
|passowrdLevel| PasswordLevel|required<br>none<br>completed<br>unknown
|name| String| name of the SSID

---

## plug

### status
```
SunionBluetoothTool.shared.Usecase.plug.status()
```

### set
```
SunionBluetoothTool.shared.Usecase.plug.set(mode: CommandService.plugMode) 
```
##### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
|mode|CommandService.plugMode|on<br>off


### Delegate function
```
 public v3Plug(value: plugStatusResponseModel?)  {
     if let value = value {
          // do something here
     } else {
         // error
     }
 }
```

##### plugStatusResponseModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| isWifiSetting| Bool| WiFi is configured
| isWifiConnecting| Bool|connected to WiFi
| isOn| Bool| On/Powered<br> Off/Not powered

---

## ota
### response
```
SunionBluetoothTool.shared.Usecase.ota.responseStatus(model: OTAStatusRequestModel)
```
##### OTAStatusRequestModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
|target| otaTarget|wireless<br>mcu
|state|otaState|start<br>finish<br>cancel
|fileSize|Int| size of ota data, Must be a multiple of 32, only 'start' and 'finish' need to be specified
|IV|String|initial vactor, Only 'finish' needs to be specified
|signature|String| file identify,  Only 'finish' needs to be specified

## update
```
SunionBluetoothTool.shared.Usecase.ota.update(model: OTADataRequestModel)
```

##### OTADataRequestModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| offset |  Int |  file location
|data| [Uint8]| value of file, Move the first byte of the received Data to the end

### Delegate function
```
 public v3OTA(value: resOTAUseCase?)  {
     if let value = value {
          // do something here
     } else {
         // error
     }
 }
```

##### resOTAUseCase
| Parameters | Type | Description |
| -------- | -------- | -------- |
|status|OTAResponseModel|[LINK](#OTAResponseModel)
|data|OTADataResponseModel|[LINK](#OTADataRequestModel)


#### OTAResponseModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| target |  otaTarget |  wireless<br> mcu
|state| otaState| start<br>finish<br>cancel
|isSuccess|Bool| Verify if update was successful

---

## user

### able
```
SunionBluetoothTool.shared.Usecase.user.able()
```

### supportCount
```
SunionBluetoothTool.shared.Usecase.user.supportCount()
```

### array
```
SunionBluetoothTool.shared.Usecase.user.array()
```

### data
```
SunionBluetoothTool.shared.Usecase.user.data(position: Int)
```

#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| position     | index    | location of the user |

### Create/Edit
```
SunionBluetoothTool.shared.Usecase.user.createorEdit(model: UserCredentialRequestModel) 
```

#### UserCredentialRequestModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
|isCreate| Bool | create or edit
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
| Parameters | Type | Description |
| -------- | -------- | -------- |
| index     | Int     | position of User  |
|type|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue<br>|

###### WeekDayscheduleStructModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| status     | ScheduleStatusEnum     | available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue<br> |
|daymask| DaysMaskMap|sunday<br>monday<br>tuesday<br>wednesday<br>thursday<br>friday<br>saturday|
|startHour|String| start hour time|
|startMinute|String| start Minute time|
|endHour| String | end hour time|
|endMinute| String| end Minute time

###### YearDayscheduleStructModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| status     | ScheduleStatusEnum     | available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue<br> |
|start| Date| start time
| end| Date | end time

### delete
```
SunionBluetoothTool.shared.Usecase.user.delete(position: Int) 
```
#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| position     | index    | location of the user |

### Delegate function
```
 public v3User(value: resUserUseCase?)  {
     if let value = value {
          // do something here
     } else {
         // error
     }
 }
```

##### resUserUseCase
| Parameters | Type | Description |
| -------- | -------- | -------- |
able|UserableResponseModel|[LINK](#UserableResponseModel)
supportedCounts|resUserSupportedCountModel|[LINK](#resUserSupportedCountModel)
|array|[Int]|location where the user is stored
|data|UserCredentialModel|[LINK](#UserCredentialModel)
|isCreatedorEdited|Bool| Verify if  created or edited was successful
|isDeleted|Bool| Verify if deleted was successful



#### UserableResponseModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| isMatter     | Bool     |true<br>false  |
|weekdayCount| Int| count of weekday|
|yeardayCount| Int| count of yearday|
|codeCount| Int| count of code|
|cardCount| Int| count of card|
|fpCount|Int| count of fp|
|faceCount|Int| count of face

#### resUserSupportedCountModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| matter| Int|The number of  support Matter
| code| Int| The number of  support code
|card| Int|The number of  support card
|fp| Int|The number of  support fp
|face| Int|The number of  support face

#### UserCredentialModel
| Parameters | Type | Description |
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


##### CredentialStructModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| index     | Int     | position of User  |
|type|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue<br>|

##### WeekDayscheduleStructModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| status     | ScheduleStatusEnum     | available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue<br> |
|daymask| DaysMaskMap|sunday<br>monday<br>tuesday<br>wednesday<br>thursday<br>friday<br>saturday|
|startHour|String| start hour time|
|startMinute|String| start Minute time|
|endHour| String | end hour time|
|endMinute| String| end Minute time

##### YearDayscheduleStructModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| status     | ScheduleStatusEnum     | available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue<br> |
|start| Date| start time
| end| Date | end time

---

## credential

### array
```
SunionBluetoothTool.shared.Usecase.credential.array()
```

### data
```
SunionBluetoothTool.shared.Usecase.credential.data(model: SearchCredentialRequestModel)
```

##### SearchCredentialRequestModel
| Parameters | Type | Description |
| -------- | -------- | -------- |
| index     | Int     |  position of Credential |
| format | FormatEnum| user<br>credential

### create/Edit
```
SunionBluetoothTool.shared.Usecase.credential.createorEdit(model: CredentialRequestModel)
```

#### CredentialRequestModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| userIndex| int | position of user|
|credentialData| [CredentialDetailStructRequestModel]|[LINK](#CredentialDetailStructRequestModel)|
|isCreate| Bool | create or not

#### CredentialDetailStructRequestModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
|credientialIndex| int| position of Credential
|status| UserStatusEnum|available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue|
|type|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue|
|data|String| value of credential|

### delete
```
SunionBluetoothTool.shared.Usecase.credential.delete(position: Int)
```

#### Parameters
| Parameters | Type | Description |
| -------- | -------- | -------- |
| position     | index    | location of the user |



### Delegate function
```
 public v3Credential(value: resCredentialUseCase?)  {
     if let value = value {
          // do something here
     } else {
         // error
     }
 }
```

#### resCredentialUseCase
| Parameters | Type | Description |
| -------- | -------- | -------- |
|array|[Int]|location where the credential is stored
|data|CredentialModel|[LINK](#CredentialModel)
|isCreatedorEdited|Bool| Verify if created or edited was successful
|isDeleted|Bool| Verify if deleted was successful

#### CredentialModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
| format | FormatEnum| user<br>credential
|credientialIndex| int| position of Credential
| userIndex| int | position of user|
|status| UserStatusEnum|available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue|
|type|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue|
|credentialData|String| value of credential|
|credentialDetailStruct| [CredentialDetailStructModel]|[LINK](#CredentialDetailStructModel)|

#### CredentialDetailStructModel
| Parameter | Type | Description |
| -------- | -------- | -------- |
|credientialIndex| int| position of Credential
|status| UserStatusEnum|available<br>occupiedEnabled<br>occupiedDisabled<br>unknownEnumValue|
|type|CredentialTypeEnum|programmingPIN<br>pin<br>rfid<br>fingerprint<br>fingerVein<br>face<br>unknownEnumValue|
|data|String| value of credential|
