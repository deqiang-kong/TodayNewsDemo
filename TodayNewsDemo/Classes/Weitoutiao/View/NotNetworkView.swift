//
//  NotNetworkView.swift
//  TodayNewsDemo
//
//

import UIKit

class NotNetworkView: UIView {

    class func noNetworkView() -> NotNetworkView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.last as! NotNetworkView
    }

}
