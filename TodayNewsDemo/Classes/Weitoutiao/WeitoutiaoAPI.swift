//
//  VideoAPI.swift
//  TodayNewsDemo
//
//  微头条 数据列表接口

import UIKit
import Alamofire
import SwiftyJSON
import HandyJSON


class WeitoutiaoAPI: NSObject {
    
    
    /// 获取微头条数据
    class func loadWeiTouTiaoData(completionHandler: @escaping (_ weitoutiaos: [WeiTouTiao]) -> ()) {
        let url = BASE_URL + "api/news/feed/v54/?"
        let params = ["iid": IID,
                      "category": "weitoutiao",
                      "count": 20,
                      "device_id": device_id] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"].string == "success" else {
                    return
                }
                guard let dataJSONs = json["data"].array else {
                    return
                }
                var weitoutiaos = [WeiTouTiao]()
                for dataJSON in dataJSONs {
                    if let content = dataJSON["content"].string {
                        let data = content.data(using: String.Encoding.utf8)! as Data
                        let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        let weitoutiao = WeiTouTiao(dict: dict as! [String : AnyObject])
                        weitoutiaos.append(weitoutiao)
                    }
                }
                completionHandler(weitoutiaos)
            }
        }
    }
    
    /// 点击了关注按钮
    class func loadFollowInfo(user_id: Int, completionHandler: @escaping (_ isFllowing: Bool)->()) {
        let url = BASE_URL + "2/relation/follow/v2/?"
        let params = ["iid": IID,
                      "user_id": user_id,
                      "device_id": device_id] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"].string == "success" else {
                    return
                }
                guard let data = json["data"].dictionary else {
                    return
                }
                guard data["description"]?.string == "关注成功" else {
                    return
                }
                if let user = data["user"]?.dictionaryObject {
                    let user_info = WTTUser(dict: user as [String : AnyObject])
                    completionHandler(user_info.is_following!)
                }
            }
        }
        
    }
    
    /// 点击了取消关注按钮
    class func loadUnfollowInfo(user_id: Int, completionHandler: @escaping (_ isFllowing: Bool)->()) {
        let url = BASE_URL + "/2/relation/unfollow/?"
        let params = ["iid": IID,
                      "user_id": user_id,
                      "device_id": device_id] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"].string == "success" else {
                    return
                }
                guard let data = json["data"].dictionary else {
                    return
                }
                if let user = data["user"]?.dictionaryObject {
                    let user_info = WTTUser(dict: user as [String : AnyObject])
                    completionHandler(user_info.is_following!)
                }
            }
        }
        
    }
    
    
    
    
    
    
}




