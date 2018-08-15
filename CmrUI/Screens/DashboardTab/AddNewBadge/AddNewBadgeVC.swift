//
//  AddNewBadgeVC.swift
//  CmrUI
//

import UIKit

private struct Constants {
    static let addBadgeIdentifier = "AddNewBadgeCell"
    static let rowHeight: CGFloat = 80.0
}

class AddNewBadgeVC: UITableViewController {
    
    var badgeCallback: selectBadgeCallback?
    
    fileprivate typealias c = Constants
    
    lazy fileprivate var viewModel: AddNewBadgeVM = {
        return AddNewBadgeVM(delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadAvailableBadges()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupUI() {
        tableView.register(UINib(nibName: "\(AddNewBadgeCell.self)", bundle: nil), forCellReuseIdentifier: c.addBadgeIdentifier)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.badges?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: c.addBadgeIdentifier, for: indexPath) as! AddNewBadgeCell
        
        if let badges = viewModel.badges {
            cell.setImage(image: badges[indexPath.row].image() ?? UIImage())
            cell.setTitle(title: badges[indexPath.row].title())
            cell.setNumber(number: indexPath.row)
        }
        if indexPath.row == 0 {
            cell.showTopSeparatorView()
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return c.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        badgeCallback?(viewModel.badges![indexPath.row])
        tableView.deselectRow(at: indexPath, animated: false)
        navigationController?.popViewController(animated: true)
    }
//    
//    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        badgeCallback?(viewModel.badges![indexPath.row])
//        navigationController?.popViewController(animated: true)
//    }
}

extension AddNewBadgeVC: AddNewBadgeVMProtocol {
    func reloadBadges() {
        tableView.reloadData()
    }
    
    func reloadCells(indexes: [IndexPath]) {
        tableView.reloadRows(at: indexes, with: UITableViewRowAnimation.automatic)
    }
}

