//
//  ChannelModel.swift
//  TodayNewsDemo
//
//  频道基本信息

import HandyJSON

class ChannelModel: HandyJSON {
    
    var category: String?
    
    var tip_new: Int = 0
    
    var default_add: Int = 0
    
    var web_url: String?
    
    var concern_id: String?
    
    var flags: Int = 0
    
    var type: Int = 0
    
    var icon_url: String?
    
    var name: String?
    
    
    required init() {}
}
