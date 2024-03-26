//
//  resNameUseCase.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class resNameUseCase {
    public var set: Bool?
    public var data: String?
}

public class resConfigUseCase {
    public var set: N81ResponseModel?
    public var data: DeviceSetupResultModelN80?
}

public class resUtilityUseCase {
    public var version: RFMCUversionModel?
    public var factoryReset: Bool?
    public var matter: Bool?
    public var alert: AlertResponseModel?
}

public class resTokenUseCase {
    public var array: [Int]?
    public var data: TokenModel?
    public var isCreate: Bool?
    public var isEdit: Bool?
}

public class resLogUseCase {
    public var count: Int?
    public var data: LogModel?
}

public class resWifiUseCase {
    public var list: SSIDModel?
    public var status: DeviceStatusModelN82?
    public var wifi: Bool?
    public var MQTT: Bool?
    public var Clould: Bool?
    public var autoUnlcok: Bool?
}

public class resOTAUseCase {
    public var status: OTAResponseModel?
    public var data: OTADataResponseModel?
   
}

