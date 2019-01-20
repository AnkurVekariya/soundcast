//
//  HomeViewController.swift
//  SoundCast
//
//  Created by Ankur on 1/18/19.
//  Copyright © 2019 ankur. All rights reserved.
//

import UIKit
import Reachability

class HomeViewController: UITableViewController {
    
    var homeViewModels = [HomeViewModel]()
    let cellId = "cellId"
    
    //Internet reachability check
    let reachability = Reachability()!
    
    //refresh control
    let refresControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        fetchData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    //check network reachability callback
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            self.showToast(message: "Network not reachable")
        }
    }
    
    fileprivate func fetchData() {
        Service.shared.fetchTracks{ (tracks, err) in
            if let err = err {
                print("Failed to fetch tracks:", err)
                return
            }
            self.refresControl.endRefreshing()
            //got data so display tableview
            DispatchQueue.main.async {
                self.tableView.isHidden = false
            }
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
        DispatchQueue.main.async {
            self.tableView.isHidden = true
        }
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresControl
        } else {
            tableView.addSubview(refresControl)
        }
        refresControl.addTarget(self, action: #selector(refreshTrackData(_:)), for: .valueChanged)

        tableView.register(HomeListTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc private func refreshTrackData(_ sender: Any) {
        // Fetch track Data
        fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
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
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 130, y: self.view.frame.size.height-100, width: 260, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
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
