//
//  MyConcernController.swift
//  TodayNewsDemo
//
//  关注

import UIKit

class MyConcernController: UITableViewController {

    var myConcerns = [MyConcern]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "关注"
        view.backgroundColor = UIColor.white
        tableView.rowHeight = 68
        tableView.separatorColor = UIColor(r: 240, g: 240, b: 240)
        tableView.backgroundColor = UIColor.globalBackgroundColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "follow_title_profile_18x18_"), style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
        tableView.ym_registerCell(cell: AllConcernsCell.self)
    }
    
    @objc func rightBarButtonItemClicked() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let addFriendVC = storyBoard.instantiateViewController(withIdentifier: String(describing: AddFriendViewController.self)) as! AddFriendViewController
//        navigationController?.pushViewController(addFriendVC, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension MyConcernController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myConcerns.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as AllConcernsCell
        cell.myConcern = myConcerns[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let followDetail = FollowDetailViewController()
        let myConcern = myConcerns[indexPath.row]
        followDetail.userid = myConcern.userid ?? 0
        navigationController?.pushViewController(followDetail, animated: true)
    }
    
}
