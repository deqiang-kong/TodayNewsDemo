//
//  HomeAPI.swift
//  TodayNewsDemo
//
//  首页 数据列表接口

import UIKit
import Alamofire
import SwiftyJSON
import HandyJSON


class HomeAPI: NSObject {
    
    
    /// 获取首页不同分类的新闻内容(和视频内容使用一个接口)
    class func getCategoryRefreshData(refresh: Bool,category: String, completionHandler:@escaping (_ nowTime: TimeInterval,_ newsTopics: [WeiTouTiao])->()) {
        
        let params = ["device_id": device_id,
                      "category": category,
                      "iid": IID,
                      "device_platform": "iphone",
                      "version_code": versionCode] as [String : AnyObject]
        
        let nowTime = NSDate().timeIntervalSince1970
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let chaheKey = home_synthesize_news + category
        
        // 数据解析
        func dataAnalysis(data :AnyObject){
            let json = JSON(data)
            //let jsonStr = json.description
            //let ss = jsonStr.replacingOccurrences(of: "\"", with: "‘")
            guard let dataJSONs = json["data"].array else {
                return
            }
            var topics = [WeiTouTiao]()
            for data in dataJSONs {
                if let content = data["content"].rawString() {
                    let contentData: NSData = content.data(using: String.Encoding.utf8)! as NSData
                    do {
                        let dict = try JSONSerialization.jsonObject(with: contentData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
                        //let cell_type = dict["cell_type"] as? Int
                        let topic = WeiTouTiao(dict: dict as! [String : AnyObject])
                        topics.append(topic)
                        //print(dict)
                    } catch {
                        
                    }
                }
            }
            completionHandler(nowTime, topics)
        }
        
        // 数据刷新
        if refresh {
            NetworkTools.shareInstance.requestData(methodType: .GET, urlString: home_synthesize_news, parameters: params) { (result, error) in
                if error != nil {
                    // 网络请求统一错误处理
                    NetworkError.analysis(errorInfo: error)
                } else {
                    dataAnalysis(data: result!)
                    // 存储缓存
                    CacheCoreDataUtils.share.setCacheData(context : context ,key: chaheKey, data: result)
                }
            }
        }else{
            if let bounds = CacheCoreDataUtils.share.getCachaData(context : context ,key: chaheKey , expirationTime: 10) {
                // 传递缓存数据
                if bounds.data.length > 10 {
                    
                    dataAnalysis(data: bounds.data)
                }
                // 执行网络请求
                if !bounds.statu {
                    NetworkTools.shareInstance.requestData(methodType: .GET, urlString: home_synthesize_news, parameters: params) { (result, error) in
                        if error != nil {
                            // 网络请求统一错误处理
                            NetworkError.analysis(errorInfo: error)
                        } else {
                            dataAnalysis(data: result!)
                        }
                    }
                }
            }
        }
    }
    
    
    /// 获取首页不同分类的新闻更多内容
    class func getHomeCategoryMoreData(category: String, completionHandler:@escaping (_ nowTime: TimeInterval,_ newsTopics: [WeiTouTiao])->()) {
        
        let params = ["device_id": device_id,
                      "category": category,
                      "iid": IID,
                      "device_platform": "iphone",
                      "version_code": versionCode] as [String : AnyObject]
        
        let nowTime = NSDate().timeIntervalSince1970
        
        NetworkTools.shareInstance.requestData(methodType: .GET, urlString: home_synthesize_news, parameters: params) { (result, error) in
            if error != nil {
                // 网络请求统一错误处理
                NetworkError.analysis(errorInfo: error)
            } else {
                
                let json = JSON(result)
                guard let dataJSONs = json["data"].array else {
                    return
                }
                var topics = [WeiTouTiao]()
                for data in dataJSONs {
                    if let content = data["content"].string {
                        let contentData: NSData = content.data(using: String.Encoding.utf8)! as NSData
                        do {
                            let dict = try JSONSerialization.jsonObject(with: contentData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                            let topic = WeiTouTiao(dict: dict as! [String : AnyObject])
                            topics.append(topic)
                            //print(dict)
                        } catch {
                            
                        }
                    }
                }
                completionHandler(nowTime, topics)
            }
        }
        
    }
    
    
    /// 获取一般新闻详情数据
    class func getCommenNewsDetail(articleURL: String, completionHandler:@escaping (_ htmlString: String, _ images: [NewsDetailImage], _ abstracts: [String])->()) {
        
        Alamofire.request(articleURL).responseString { (response) in
            guard response.result.isSuccess else {
                return
            }
            
            if let value = response.result.value {
                var images = [NewsDetailImage]()
                var abstracts = [String]()
                var htmlString = String()
                if value.contains("BASE_DATA.galleryInfo =") { // 则是图文详情
                    // 获取 图片链接数组
                    let startIndex = value.range(of: "\"sub_images\":")!.upperBound
                    let endIndex = value.range(of: ",\"max_img_width\"")!.lowerBound
                    let range = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
                    let BASE_DATA = value.substring(with: range)
                    let data = BASE_DATA.data(using: String.Encoding.utf8)! as Data
                    let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [AnyObject]
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
                    for string in subAbstracts! {
                        abstracts.append(string)
                    }
                } else if value.contains("articleInfo: ") { // 一般的新闻
                    // 获取 新闻内容
                    let startIndex = value.range(of: "content: '")!.upperBound
                    let endIndex = value.range(of: "'.replace")!.lowerBound
                    let range = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
                    let content = value.substring(with: range)
                    
                    let contentDecode = htmlDecode(content: content)
                    /// 创建 html
                    var html = "<!DOCTYPE html>"
                    html += "<html>"
                    html += "<head>"
                    html += "<meta charset=utf-8>"
                    html += "<meta content='width=device-wdith,initial-scale=1.0,maximum-scale=3.0,user-scalabel=0;' name='viewport' />"
                    html += "<link rel=\"stylesheet\" type=\"text/css\" href=\"news.css\" />\n"
                    html += "</head>"
                    html += "<body>"
                    html += contentDecode
                    html += "</body>"
                    html += "<div></div>"
                    html += "</html>"
                    htmlString = html
                } else { // 第三方的新闻内容
                    /// 这部分显示还有问题
                    htmlString = value
                }
                completionHandler(htmlString, images, abstracts)
            }
        }
    }
    
    
    /// 转义字符
    class func htmlDecode(content: String) -> String {
        var s = String()
        s = content.replacingOccurrences(of: "&amp;", with: "&")
        s = s.replacingOccurrences(of: "&lt;", with: "<")
        s = s.replacingOccurrences(of: "&gt;", with: ">")
        s = s.replacingOccurrences(of: "&nbsp;", with: " ")
        s = s.replacingOccurrences(of: "&#39;", with: "\'")
        s = s.replacingOccurrences(of: "&quot;", with: "\"")
        s = s.replacingOccurrences(of: "<br>", with: "\n")
        return s
    }
    
    
    
    // 获取今日头条的视频真实链接可参考下面的博客
    // http://blog.csdn.net/dianliang01/article/details/73163086
    /// 解析视频的真实链接
    class func parseVideoRealURL(video_id: String, completionHandler:@escaping (_ realVideo: RealVideo)->()) {
        let r = arc4random() // 随机数
        let url: NSString = "/video/urls/v/1/toutiao/mp4/\(video_id)?r=\(r)" as NSString
        let data: NSData = url.data(using: String.Encoding.utf8.rawValue)! as NSData
        var crc32: UInt64 = UInt64(data.getCRC32()) // 使用 crc32 校验
        if crc32 < 0 { // crc32 的值可能为负数
            crc32 += 0x100000000
        }
        // 拼接
        let realURL = "http://i.snssdk.com/video/urls/v/1/toutiao/mp4/\(video_id)?r=\(r)&s=\(crc32)"
        Alamofire.request(realURL).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                let dict = json["data"].dictionaryObject
                let video = RealVideo(dict: dict! as [String : AnyObject])
                completionHandler(video)
            }
        }
    }
    
    
}




