//
//  WeitoutiaoHeaderView.swift
//  TodayNewsDemo
//
//

import UIKit

protocol WeitoutiaoHeaderViewDelegate: class {
    /// 文字按钮点击了
    func headerViewTextButtonClicked()
    /// 图片按钮点击了
    func headerViewImageButtonClicked()
    /// 视频按钮点击了
    func headerViewVideoButtonClicked()
}

class WeitoutiaoHeaderView: UIView, LoadNibProtocol {

    weak var delegate:WeitoutiaoHeaderViewDelegate?
    /// 文字按钮
    @IBOutlet weak var textButton: UIButton!
    /// 图片按钮
    @IBOutlet weak var imageButton: UIButton!
    /// 视频按钮
    @IBOutlet weak var videoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /// 设置主题
        theme_backgroundColor = "colors.cellBackgroundColor"
        textButton.theme_setTitleColor("colors.black", forState: .normal)
        imageButton.theme_setTitleColor("colors.black", forState: .normal)
        videoButton.theme_setTitleColor("colors.black", forState: .normal)
        textButton.theme_setImage("images.weitoutiaoTextButton", forState: .normal)
        imageButton.theme_setImage("images.weitoutiaoImageButton", forState: .normal)
        videoButton.theme_setImage("images.weitoutiaoVideoButton", forState: .normal)
    }
    
    // 文字按钮点击了
    @IBAction func textButtonClicked() {
        delegate?.headerViewTextButtonClicked()
    }
    
    // 图片按钮点击了
    @IBAction func imageButtonClicked() {
        delegate?.headerViewImageButtonClicked()
    }
    
    // 视频按钮点击了
    @IBAction func videoButtonClicked() {
        delegate?.headerViewVideoButtonClicked()
    }

}
