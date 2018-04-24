//
//  ChannelAPI.swift
//  TodayNewsDemo
//
//  频道管理相关接口数据请求

import UIKit
import SwiftyJSON
import HandyJSON


class ChannelAPI: NSObject {
    
    
    /// JSONString转换为字典
    ///
    /// - Parameter jsonString:
    /// - Returns: <#return value description#>
    class func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
        
        
    }
    
    // 获取我的频道数据
    class func getMyChannels(_ finished:@escaping (_ channels: [ChannelModel]?) -> ()) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let bounds = CacheCoreDataUtils.share.getCachaData(context : context ,key: my_channels_key, expirationTime: 10) {
            // 我的频道缓存数据
            if bounds.data.length > 10 {
               
                let json = JSON(bounds.data)
                var channels = [ChannelModel]()
                // 遍历
                for orderInfo in json.arrayObject! {
                    // 根据指定模型反序列化数据
                    let channel = JSONDeserializer<ChannelModel>.deserializeFrom(json: JSON(orderInfo).description)
                    channels.append(channel!)
                }
                finished(channels )
            }
            // 缓存数据不存在时请求网络获取推荐频道数据
            else{
                let params = ["device_id": device_id,
                              "aid": 13,
                              "iid": IID] as [String : AnyObject]
                
                NetworkTools.shareInstance.requestData(methodType: .GET, urlString: home_recommend_channels, parameters: params) { (result, error) in
                    
                    if error != nil {
                        // 网络请求统一错误处理
                        NetworkError.analysis(errorInfo: error)
                    } else {
                        let json = JSON(result!)
                        //let jsonStr = json.rawString()
                        // 频道列表数据
                        let channelbean = JSONDeserializer<ChannelsBean>.deserializeFrom(json: json["data"].description)
                        var channels = channelbean?.data
                        // 添加推荐标题
                        let recommend = ChannelModel()
                        recommend.category = ""
                        recommend.name = "推荐"
                        recommend.type = 0
                        channels?.insert(recommend, at: 0)
                        
                        finished(channels)
                        // 保存my频道列表
                        saveMyChannelCacheData(data: (channels)!)
                    }
                }
            }
        }
    }
    
    //保存我的频道数据缓存
    class func saveMyChannelCacheData(data : [ChannelModel]){
        // 从对象实例转换到JSON字符串
        let jsonString = data.toJSONString()!
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // 存储缓存
        CacheCoreDataUtils.share.setCacheData(context : context ,key: my_channels_key, data: jsonString as AnyObject)
    }
    
    
    // 获取推荐频道数据
    class func getRecommendChannels(_ finished:@escaping (_ channels: [ChannelModel]?) -> ()) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let bounds = CacheCoreDataUtils.share.getCachaData(context : context ,key: home_recommend_channels, expirationTime: 10) {
            // 传递缓存数据
            if bounds.data.length > 10 {
                let json = JSON(bounds.data)
                // 频道列表数据
                let channels = JSONDeserializer<ChannelsBean>.deserializeFrom(json: json["data"].description)
                //let jsonStr = json1.?.rawString()?
                finished(channels?.data)
            }
            // 执行网络请求
            if !bounds.statu {
                let params = ["device_id": device_id,
                              "aid": 13,
                              "iid": IID] as [String : AnyObject]
                
                NetworkTools.shareInstance.requestData(methodType: .GET, urlString: home_recommend_channels, parameters: params) { (result, error) in
                    
                    if error != nil {
                        // 网络请求统一错误处理
                        NetworkError.analysis(errorInfo: error)
                    } else {
                        let json = JSON(result!)
                        //let jsonStr = json.rawString()
                        // 频道列表数据
                        let channels = JSONDeserializer<ChannelsBean>.deserializeFrom(json: json["data"].description)
                        finished(channels?.data)
                        // 存储缓存
                        CacheCoreDataUtils.share.setCacheData(context : context ,key: home_recommend_channels, data: result)
                    }
                }
            }
        }
    }
    
    
    
    // 获取备选频道数据
    class func getOptionalChannels(_ finished:@escaping (_ channels: [ChannelModel]?) -> ()) {
        let params = ["device_id": device_id,
                      "aid": 13,
                      "iid": IID] as [String : AnyObject]
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let bounds = CacheCoreDataUtils.share.getCachaData(context : context ,key: home_optional_channels, expirationTime: 10) {
            // 传递缓存数据
            if bounds.data.length > 10 {
                let json = JSON(bounds.data)
                // 频道列表数据
                let channels = JSONDeserializer<ChannelsBean>.deserializeFrom(json: json["data"].description)
                
                finished(channels?.data)
            }
            // 执行网络请求
            if !bounds.statu {
                NetworkTools.shareInstance.requestData(methodType: .GET, urlString: home_optional_channels, parameters: params) { (result, error) in
                    
                    if error != nil {
                        // 网络请求统一错误处理
                        NetworkError.analysis(errorInfo: error)
                    } else {
                        let json = JSON(result!)
                        //let jsonStr = json.rawString()
                        // 频道列表数据
                        let channels = JSONDeserializer<ChannelsBean>.deserializeFrom(json: json["data"].description)
                        finished(channels?.data)
                        // 存储缓存
                        CacheCoreDataUtils.share.setCacheData(context : context ,key: home_optional_channels, data: result)
                    }
                }
            }
        }
        
    }
    
    
    
    
    
}

