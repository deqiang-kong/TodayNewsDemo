//
//  HomeViewController.swift
//  TodayNewsDemo
//
//
//  用于频道编辑页数据回传

import Foundation

protocol ChannelsBackDelegate {
    
    func channelsBack(channels: [ChannelModel]?, index : Int)
}
