//
//  resNameUseCase.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class resTimeUseCase {
    public var isSavedTime: Bool?
    public var isSavedTimeZone: Bool?
}

public class resAdminCodeUseCase {
    public var isCreated: Bool?
    public var isEdited: Bool?
    public var isExisted: Bool?
}

public class resNameUseCase {
    public var isConfigured: Bool?
    public var data: String?
}

public class resConfigUseCase {
    public var isConfigured: Bool?
    public var data: DeviceSetupResultModelN80?
}

public class resUtilityUseCase {
    public var version: RFMCUversionModel?
    public var isFactoryReset: Bool?
    public var isPlugFactoryReset: Bool?
    public var isMatter: Bool?
    public var alert: AlertResponseModel?
}

public class resTokenUseCase {
    public var array: [Int]?
    public var data: TokenModel?
    public var created: AddTokenResult?
    public var isEdited: Bool?
    public var isDeleted: Bool?
}

public class resLogUseCase {
    public var count: Int?
    public var data: LogModel?
}

public class resWifiUseCase {
    public var list: SSIDModel?
    public var status: DeviceStatusModelN82?
    public var isWifi: Bool?
    public var isMQTT: Bool?
    public var isClould: Bool?
    public var isAutoUnlcok: Bool?
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

