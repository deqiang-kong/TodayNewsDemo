//
//  CoreDataUtils.swift
//  DBFM
//  数据缓存
//  CoreDataUtils

import Foundation
import CoreData
import SwiftyJSON



class CacheCoreDataUtils  {
    
    /// 单例
    static let share = CacheCoreDataUtils()
    
    //    // 获取管理的数据上下文  对象
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    /// 获取缓存数据
    func getCachaData(context : NSManagedObjectContext ,key :String, expirationTime :Int)->(statu:Bool ,data: AnyObject)? {
        var status = false
        var jsonData = "" as AnyObject
        //获取缓存数据
        let cacheObj = searchData(context: context, key: key)
        
        if cacheObj != nil {
            let time = cacheObj!.time! as Date
            let jsonStr =  cacheObj!.data! as String
            if let data = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                //status = true
                jsonData = data as AnyObject
            }
            
            //let time = "2017-12-20 17:50:00"
            let dateForm = DateFormatter()
            dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //let da = dateForm.date(from: time)
            let minute = Int(NSDate().timeIntervalSince(time) / 60)
            // 判断缓存数据有效期
            if minute < expirationTime{
                status = true
                return (status , jsonData)
            }
        }
        
        return (status , jsonData)
    }
    
    
    
    //设置数据缓存
    func setCacheData(context : NSManagedObjectContext ,key:String,data:AnyObject?){
        let json = JSON(data as Any)
        if let jsonStr = json.rawString() {
            insetData(context: context, key: key, data: jsonStr)
        }
    }
    
    
    // MARK:- 插入（保存）数据操作
    internal func insetData(context : NSManagedObjectContext,key:String,data:String){
        delecteData(context :context,key:key)
        // 创建数据对象
        let cacheObj = NSEntityDescription.insertNewObject(forEntityName: "CacheData", into: context) as! CacheData
        
        // 对象赋值
        cacheObj.cacheKey = key
        cacheObj.time = Date()
        cacheObj.data = data
        cacheObj.userName = "12344321"
        // 保存
        do{
            try context.save()
        }
        catch{
            fatalError("无法保存 \\\\(error)")
        }
    }
    
    // MARK:- 查询数据操作
    internal func searchData(context : NSManagedObjectContext,key:String)-> CacheData? {
        // 声明数据的请求
        let fetchRequest:NSFetchRequest =  NSFetchRequest<CacheData>()
        fetchRequest.fetchLimit = 10  // 限定查询结果的数量
        fetchRequest.fetchOffset = 0  // 查询的偏移量
        
        // 声明一个实体结构
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "CacheData", in: context)
        // 设置数据请求的实体结构
        fetchRequest.entity = entity
        
        // 设置查询条件
        let predicate = NSPredicate(format: "cacheKey = '" + key + "'", "")
        fetchRequest.predicate = predicate
        
        // 查询操作
        do{
            let fetchedObjects:[AnyObject]? = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as [AnyObject]
            // 遍历查询的结果
            for info in fetchedObjects as! [CacheData] {
                //cacheData=info
                return info
            }
        }
        catch {
            fatalError("不存在：\\\\(error)")
        }
        return nil
    }
    
    
    internal func updateData(context : NSManagedObjectContext){
        // 声明数据的请求
        let fetchRequest:NSFetchRequest =  NSFetchRequest<CacheData>()
        fetchRequest.fetchLimit = 10  // 限定查询结果的数量
        fetchRequest.fetchOffset = 0  // 查询的偏移量
        
        // 声明一个实体结构
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "CacheData", in: context)
        // 设置数据请求的实体结构
        fetchRequest.entity = entity
        
        // 设置查询条件
        let predicate = NSPredicate(format: "cacheKey = '1'", "")
        fetchRequest.predicate = predicate
        
        // 查询操作
        do{
            let fetchedObjects:[AnyObject]? = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as [AnyObject]
            // 遍历查询的结果
            for info in fetchedObjects as! [CacheData] {
                //修改密码
                //info.password = "abcdaaaaaaaa"
                //重新保存
                try context.save()
            }
        }
        catch {
            fatalError("不能保存：\\\\(error)")
        }
    }
    
    
    // MARK:- 删除数据操作
    internal func delecteData(context : NSManagedObjectContext,key:String){
        // 声明数据的请求
        let fetchRequest:NSFetchRequest =  NSFetchRequest<CacheData>()
        fetchRequest.fetchLimit = 10  // 限定查询结果的数量
        fetchRequest.fetchOffset = 0  // 查询的偏移量
        
        // 声明一个实体结构
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "CacheData", in: context)
        // 设置数据请求的实体结构
        fetchRequest.entity = entity
        
        // 设置查询条件
        let predicate = NSPredicate(format: "cacheKey = '" + key + "'", "")
        fetchRequest.predicate = predicate
        
        // 查询操作
        do{
            let fetchedObjects:[AnyObject]? = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as [AnyObject]
            // 遍历查询的结果
            for info in fetchedObjects as! [CacheData] {
                //删除对象
                context.delete(info)
            }
            // 重新保存 - 更新到数据库中
            try context.save()
        }
        catch {
            fatalError("不能保存：\\\\(error)")
        }
    }
}



