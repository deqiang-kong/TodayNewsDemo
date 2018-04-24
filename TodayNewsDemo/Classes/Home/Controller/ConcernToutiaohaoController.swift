//
//  ConcernToutiaohaoController.swift
//  TodayNewsDemo
//
//  头条号

import UIKit

class ConcernToutiaohaoController: UIViewController {

    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var rightTableView: UITableView!
    
    fileprivate var concerns = [ConcernToutiaohao]()
    fileprivate var subConcerns = [SubConcern]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "头条号"
        leftTableView.delegate = self
        rightTableView.delegate = self
        
//        leftTableView.ym_registerCell(cell: LeftCategoryCell.self)
//        rightTableView.ym_registerCell(cell: RightCategoryCell.self)
//
//        NetworkTool.loadEntryList { (concerns) in
//            self.concerns = concerns
//            self.leftTableView.reloadData()
//            for item in self.concerns {
//                self.subConcerns = item.list
//            }
//            self.rightTableView.reloadData()
//            self.leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
//        }
    }
}

extension ConcernToutiaohaoController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return concerns.count
        } else {
            return subConcerns.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as LeftCategoryCell
            cell.concern = concerns[indexPath.row]
            return cell
        } else {
            let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as RightCategoryCell
            cell.subConcern = subConcerns[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == leftTableView {
//            subConcerns.removeAll()
//            NetworkTool.loadEntryList { (concerns) in
//                self.concerns = concerns
//                self.subConcerns = concerns[indexPath.row].list
//                self.rightTableView.reloadData()
//            }
//        } else {
//            let userVC = FollowDetailViewController()
//            let subConcern = subConcerns[indexPath.row]
//            userVC.userid = subConcern.user_id!
//            navigationController?.pushViewController(userVC, animated: true)
//        }
    }
}
