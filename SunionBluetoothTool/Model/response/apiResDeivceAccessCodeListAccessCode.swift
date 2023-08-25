//
//  apiResDeivceAccessCodeListAccessCode.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//



import ObjectMapper


class apiResDeivceAccessCodeListAccessCode: Mappable  {
    var Timestamp: Double?
    var Name: String?
    var Code: String?
    var Attributes: apiResDeivceAccessCodeListAccessCodeAttributes?
 
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        Timestamp             <- map["Timestamp"]
        Name         <- map["Name"]
        Code  <- map["Code"]
        Attributes <- map["Attributes"]
  
    }
}

class apiResDeivceAccessCodeListAccessCodeAttributes: Mappable  {
    var NotifyWhenUse: Bool?
    var Enable: Bool?
    var Rule: [apiResDeivceAccessCodeListAccessCodeAttributesRule]?

 
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        NotifyWhenUse             <- map["NotifyWhenUse"]
        Enable <- map["Enable"]
        Rule         <- map["Rule"]
  
  
    }
}

class apiResDeivceAccessCodeListAccessCodeAttributesRule: Mappable  {
    var type: String?
    var Conditions: apiResDeivceAccessCodeListAccessCodeAttributesRuleConditions?

 
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        type             <- map["Type"]
        Conditions         <- map["Conditions"]
  
  
    }
}

class apiResDeivceAccessCodeListAccessCodeAttributesRuleConditions: Mappable  {
    var Scheduled: apiResDeivceAccessCodeListAccessCodeAttributesRuleConditionsScheduled?
    var ValidTimeRange: apiResDeivceAccessCodeListAccessCodeAttributesRuleConditionsValidTimeRange?

 
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        Scheduled             <- map["Scheduled"]
        ValidTimeRange         <- map["ValidTimeRange"]
  
  
    }
}

class apiResDeivceAccessCodeListAccessCodeAttributesRuleConditionsScheduled: Mappable  {
    var WeekDay: String?
    var StartTime: Int?
    var EndTime: Int?

 
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        WeekDay             <- map["WeekDay"]
        StartTime         <- map["StartTime"]
        EndTime <- map["EndTime"]
  
  
    }
}

class apiResDeivceAccessCodeListAccessCodeAttributesRuleConditionsValidTimeRange: Mappable  {

    var StartTimeStamp: Int64?
    var EndTimeStamp: Int64?

 
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    // Mappable
    func mapping(map: Map) {
     
        StartTimeStamp         <- map["StartTimeStamp"]
        EndTimeStamp <- map["EndTimeStamp"]
  
  
    }
}

