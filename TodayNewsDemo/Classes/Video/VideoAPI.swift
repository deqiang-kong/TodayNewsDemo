//
//  VideoAPI.swift
//  TodayNewsDemo
//
//  视频 数据列表接口

import UIKit
import Alamofire
import SwiftyJSON
import HandyJSON


class VideoAPI: NSObject {
    
    
    
    /// 获取视频顶部标题内容
    class func loadVideoTitlesData(completionHandler:@escaping (_ videoTitles: [TopicTitle], _ videoTopicVCs: [VideoTopicController])->()) {
        let url = BASE_URL + "video_api/get_category/v1/?"
        let params = ["device_id": device_id,
                      "iid": IID]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let data = json["data"].arrayObject {
                    var titles = [TopicTitle]()
                    var videoTopicVCs = [VideoTopicController]()
                    // 添加推荐标题
                    let recommendDict = ["category": "video", "name": "推荐"]
                    let recommend = TopicTitle(dict: recommendDict as [String : AnyObject])
                    titles.append(recommend)
                    // 添加控制器
                    let firstVC = VideoTopicController()
                    firstVC.videoTitle = recommend
                    videoTopicVCs.append(firstVC)
                    for dict in data {
                        let title = TopicTitle(dict: dict as! [String: AnyObject])
                        let videoTopicVC = VideoTopicController()
                        videoTopicVC.videoTitle = title
                        videoTopicVCs.append(videoTopicVC)
                        titles.append(title)
                    }
                    completionHandler(titles, videoTopicVCs)
                }
            }
        }
    }
    
    
    
    
}




