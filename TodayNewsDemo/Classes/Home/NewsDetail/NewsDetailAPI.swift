//
//  NewsDetailAPI.swift
//  TodayNewsDemo
//
//  新闻详情相关接口数据请求

import UIKit
import Alamofire
import SwiftyJSON
import HandyJSON


class NewsDetailAPI: NSObject {
    
    
   
    
    /// 获取新闻详情相关新闻
    class func loadNewsDetailRelateNews(fromCategory: String, weitoutiao: WeiTouTiao, completionHandler:@escaping (_ relateNews: [WeiTouTiao], _ labels: [NewsDetailLabel], _ userLike: UserLike?, _ appInfo: NewsDetailAPPInfo?, _ filter_wrods: [WTTFilterWord]) -> ()) {
        let url = BASE_URL + "2/article/information/v21/?"
        // version_code=6.2.6
        let article_page = weitoutiao.has_video! ? 1 : 0
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let params = ["device_id": device_id,
                      "version_code": version,
                      "article_page": article_page,
                      "aggr_type": weitoutiao.aggr_type!,
                      "latitude": "",
                      "longitude": "",
                      "iid": IID,
                      "item_id": weitoutiao.item_id!,
                      "group_id": weitoutiao.group_id!,
                      "device_platform": "iphone",
                      "from_category": fromCategory] as [String : AnyObject]
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let data = json["data"].dictionary {
                    var relateNews = [WeiTouTiao]()
                    var labels = [NewsDetailLabel]()
                    var userLike: UserLike?
                    var appInfo: NewsDetailAPPInfo?
                    var filter_words = [WTTFilterWord]()
                    if let relatedVideoToutiao = data["related_video_toutiao"] {
                        for dict in relatedVideoToutiao.arrayObject! {
                            let news = WeiTouTiao(dict: dict as! [String: AnyObject])
                            relateNews.append(news)
                        }
                    } else if let ordered_info = data["ordered_info"] {
                        // ordered_info 对应新闻详情顶部的 新闻类别按钮，新欢，不喜欢按钮，app 广告， 相关新闻
                        // ordered_info是一个数组，数组内容不定，根据其中的 name 来判断对应的字典
                        if ordered_info.count > 0 { // 说明 ordered_info 有数据
                            for orderInfo in ordered_info.arrayObject! { // 遍历，根据 name 来判断
                                let ordered = orderInfo as! [String: AnyObject]
                                let name = ordered["name"]! as! String
                                if name == "labels" { // 新闻相关类别,数组
                                    if let orders = ordered["data"] as? [AnyObject] {
                                        for dict in orders {
                                            let label = NewsDetailLabel(dict: dict as! [String: AnyObject])
                                            labels.append(label)
                                        }
                                    }
                                } else if name == "like_and_rewards" { // 喜欢 / 不喜欢  字典
                                    userLike = UserLike(dict: ordered["data"] as! [String: AnyObject])
                                } else if name == "ad" { // 广告， 字典
                                    let appData = ordered["data"] as! [String: AnyObject]
                                    // 有两种情况，一种 app，一种 mixed
                                    if let app = appData["app"] {
                                        appInfo = NewsDetailAPPInfo(dict: app as! [String: AnyObject])
                                    } else if let mixed = appData["mixed"] {
                                        appInfo = NewsDetailAPPInfo(dict: mixed as! [String: AnyObject])
                                    }
                                } else if name == "related_news" { // 相关新闻  数组
                                    if let orders = ordered["data"] as? [AnyObject] {
                                        for dict in orders {
                                            let relatenews = WeiTouTiao(dict: dict as! [String: AnyObject])
                                            relateNews.append(relatenews)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    if let filterWords = data["filter_words"]?.arrayObject {
                        for item in filterWords {
                            let filterWord = WTTFilterWord(dict: item as! [String: AnyObject])
                            filter_words.append(filterWord)
                        }
                    }
                    completionHandler(relateNews, labels, userLike, appInfo, filter_words)
                }
            }
        }
    }
  
    
    
    /// 获取新闻详情评论
    class func loadNewsDetailComments(offset: Int, weitoutiao: WeiTouTiao, completionHandler:@escaping (_ comments: [NewsDetailImageComment])->()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = BASE_URL + "article/v2/tab_comments/?"
        var item_id = ""
        var group_id = ""
        if let itemId = weitoutiao.item_id {
            item_id = "\(itemId)"
        }
        if let groupId = weitoutiao.group_id {
            group_id = "\(groupId)"
        }
        let params = ["offset": offset,
                      "item_id": item_id,
                      "group_id": group_id] as [String : AnyObject]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let data = json["data"].arrayObject {
                    var comments = [NewsDetailImageComment]()
                    for dict in data {
                        let commentDict = dict as! [String: AnyObject]
                        let comment = NewsDetailImageComment(dict: commentDict["comment"] as! [String : AnyObject])
                        comments.append(comment)
                        
                    }
                    completionHandler(comments)
                }
            }
        }
    }
    
    
    /// 获取图片新闻详情数据
    class func loadNewsDetail(articleURL: String, completionHandler:@escaping (_ images: [NewsDetailImage], _ abstracts: [String])->()) {
        // 测试数据
        //        http://toutiao.com/item/6450211121520443918/
        let url = "http://www.toutiao.com/a6450237670911852814/#p=1"
        
        Alamofire.request(url).responseString { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                if value.contains("BASE_DATA.galleryInfo =") {
                    // 获取 图片链接数组
                    let startIndex = value.range(of: "\"sub_images\":")!.upperBound
                    let endIndex = value.range(of: ",\"max_img_width\"")!.lowerBound
                    let range = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
                    let BASE_DATA = value.substring(with: range)
                    let data = BASE_DATA.data(using: String.Encoding.utf8)! as Data
                    let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [AnyObject]
                    var images = [NewsDetailImage]()
                    for image in dict! {
                        let img = NewsDetailImage(dict: image as! [String: AnyObject])
                        images.append(img)
                    }
                    // 获取 子标题
                    let titleStartIndex = value.range(of: "\"sub_abstracts\":")!.upperBound
                    let titlEndIndex = value.range(of: ",\"sub_titles\"")!.lowerBound
                    let titleRange = Range(uncheckedBounds: (lower: titleStartIndex, upper: titlEndIndex))
                    let sub_abstracts = value.substring(with: titleRange)
                    let titleData = sub_abstracts.data(using: String.Encoding.utf8)! as Data
                    let subAbstracts = try? JSONSerialization.jsonObject(with: titleData, options: .mutableContainers) as! [String]
                    var abstracts = [String]()
                    for string in subAbstracts! {
                        abstracts.append(string)
                    }
                    completionHandler(images, abstracts)
                }
            }
        }
    }
    
    
    /// 获取图片新闻详情评论
    class func loadNewsDetailImageComments(offset: Int, item_id: UInt64, group_id: UInt64, completionHandler:@escaping (_ comments: [NewsDetailImageComment])->()) {
        let url = BASE_URL + "article/v2/tab_comments/?"
        let params = ["offset": offset,
                      "item_id": item_id,
                      "group_id": group_id] as [String : AnyObject]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let data = json["data"].arrayObject {
                    var comments = [NewsDetailImageComment]()
                    for dict in data {
                        let commentDict = dict as! [String: AnyObject]
                        let comment = NewsDetailImageComment(dict: commentDict["comment"] as! [String : AnyObject])
                        comments.append(comment)
                    }
                    completionHandler(comments)
                }
            }
        }
    }
    
   
    
}

