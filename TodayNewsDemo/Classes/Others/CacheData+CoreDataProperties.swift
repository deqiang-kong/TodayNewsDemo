//
//  CacheData+CoreDataProperties.swift
//  
//
//  Created by kaipai on 2017/12/28.
//
//

import Foundation
import CoreData


extension CacheData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CacheData> {
        return NSFetchRequest<CacheData>(entityName: "CacheData")
    }

    @NSManaged public var time: NSDate?
    @NSManaged public var data: String?
    @NSManaged public var cacheKey: String?
    @NSManaged public var userName: String?

}
