//
//  ConnectUrl.swift
//  TodayNewsDemo
//
//  URL地址库

import Foundation

/**
 * 是否是测试服务器
 */
public  let  IS_TEST_SERVER = false ;

////////---------UAT------------////////
let UAT_HOST = "https://is.snssdk.com/";



////////---------生产------------////////
let PRODUCT_HOST = "https://is.snssdk.com/";



////////---------URL-----------////////
//当前服务器地址
let BASE_URL = IS_TEST_SERVER ? UAT_HOST : PRODUCT_HOST


////////---------Home 模块-----------////////
// 我的频道列表
let my_channels_key = "home_my_channels"

// 频道推荐列表
let home_recommend_channels = BASE_URL + "article/category/get_subscribed/v1/"

// 频道备选列表
let home_optional_channels = BASE_URL + "article/category/get_extra/v1/"


// 首页综合推荐新闻
let home_synthesize_news = BASE_URL + "api/news/feed/v58/"
