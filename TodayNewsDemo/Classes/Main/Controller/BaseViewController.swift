//
//  TabBarController.swift
//  TodayNewsDemo
//
//
//  BaseViewController

import UIKit

class BaseViewController: UIViewController {
    
    // 加载视图时会调用该方法
    override func loadView() {
        super.loadView()
        print("加载视图")
    }
    
    // 当加载视图结束时调用该方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="title"
        print("加载视图结束")
    }
    
    // 视图将要显示时调用该方法
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("视图即将显示")
    }
    
    // 当视图已经显示时调用该方法
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("视图已经显示")
    }
    
    // 当视图将要消失时调用该方法
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("视图即将消失")
    }
    
    // 当时图已经消失时调用该方法
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("视图已经消失")
    }
    
    // 当接收到内存警告时会执行这个方法
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

