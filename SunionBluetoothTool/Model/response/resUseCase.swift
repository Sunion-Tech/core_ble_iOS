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
    public var isMatter: Bool?
    public var alert: AlertResponseModel?
}

public class resTokenUseCase {
    public var array: [Int]?
    public var data: TokenModel?
    public var isCreated: Bool?
    public var isEdited: Bool?
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
    public var clould: Bool?
    public var autoUnlcok: Bool?
}

public class resOTAUseCase {
    public var status: OTAResponseModel?
    public var data: OTADataResponseModel?
}

public class resUserUseCase {
    public var able: UserableResponseModel?
    public var supportedCounts: resUserSupportedCountModel?
    public var array: [Int]?
    public var data: UserCredentialModel?
    public var isCreatedorEdited: Bool?
    public var isDeleted: Bool?
}

public class resCredentialUseCase {
    public var array: [Int]?
    public var data: CredentialModel?
    public var isCreatedorEdited: Bool?
    public var isDeleted: Bool?
}

