//
//  HomeViewController.swift
//  SoundCast
//
//  Created by Ankur on 1/18/19.
//  Copyright © 2019 ankur. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    
    var homeViewModels = [HomeViewModel]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
        fetchData()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func fetchData() {
        Service.shared.fetchTracks{ (tracks, err) in
            if let err = err {
                print("Failed to fetch courses:", err)
                return
            }
            print(tracks as Any)
            self.homeViewModels = tracks?.map({return HomeViewModel(track: $0)}) ?? []
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeListTableViewCell
        var cell:HomeListTableViewCell? = tableView.dequeueReusableCell(withIdentifier:"HomeListTableViewCell") as? HomeListTableViewCell
        if cell == nil{
            tableView.register(UINib.init(nibName: "HomeListTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeListTableViewCell")
            let arrNib:Array = Bundle.main.loadNibNamed("HomeListTableViewCell",owner: self, options: nil)!
            cell = arrNib.first as? HomeListTableViewCell
        }
        
        let homeViewModel = homeViewModels[indexPath.row]
        cell!.homeViewModel = homeViewModel
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController
        {
            
            vc.currentTrackIndex = indexPath.row
            vc.homeViewModels = homeViewModels
            present(vc, animated: true, completion: nil)
        }
    }
    
    fileprivate func setupTableView() {
        tableView.register(HomeListTableViewCell.self, forCellReuseIdentifier: cellId)
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
//        tableView.separatorColor = .mainTextBlue
//        tableView.backgroundColor = UIColor.rgb(r: 12, g: 47, b: 57)
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 80
//        tableView.tableFooterView = UIView()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Tracks"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .yellow
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.rgb(r: 40, g: 40, b: 41)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }


    /*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension UIColor {
    static let mainTextBlue = UIColor.rgb(r: 7, g: 71, b: 89)
    static let highlightColor = UIColor.rgb(r: 50, g: 199, b: 242)
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
