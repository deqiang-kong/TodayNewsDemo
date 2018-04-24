//
//  FeedShareViewController.swift
//  TodayNewsDemo
//
//
//  转发 控制器
//

import UIKit
import Kingfisher

class FeedShareViewController: UITableViewController {

    var content: String?
    
    var thumbImageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// 取消按钮点击
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    /// 发布按钮点击
    @IBAction func postButtonClicked(_ sender: UIBarButtonItem) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 110
        }
        return 98
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row  == 0 {
            let cell = PostFirstCell.loadViewFromNib()
            
            return cell
        } else {
            let cell = PostSecondCell.loadViewFromNib()
            cell.videoButton.kf.setBackgroundImage(with: URL(string: thumbImageURL!), for: .normal)
            cell.contentLabel.text = content!
            return cell
        }
    }

}
