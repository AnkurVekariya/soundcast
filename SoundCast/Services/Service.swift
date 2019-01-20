//
//  Service.swift
//  SoundCast
//
//  Created by Ankur on 1/18/19.
//  Copyright © 2019 ankur. All rights reserved.
//

import UIKit
import Alamofire

class Service: NSObject {
    
    static let shared = Service()
    
    func fetchTracks(completion: @escaping ([Track]?, Error?) -> ()){
        
        let urlString = "https://soundcast.back4app.io/classes/songs_library"
        guard let url = URL(string: urlString) else {
            return }
        
        let headers: HTTPHeaders = [
            "X-Parse-Application-Id": "VSPdpDKRMND382hqIRFIaiVLgbkhM0E1rL32l1SQ",
            "X-Parse-REST-API-Key": "E4ZeObhQv3XoHaQ3Q6baHGgbDPOkuO9jPlY9gzgA"
        ]
        
        Alamofire.request(url,method: .get, headers: headers).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote rooms:" + "\(String(describing: response.result.error))")
                completion(nil, response.result.error)
                return
            }

            guard let value = response.result.value as? [String: Any],
                let rows = value["results"] as? [[String: Any]] else {
                    print("Malformed data received from fetchAllRooms service")
                    completion(nil, nil)
                    return
            }
            let tracks = rows as [NSDictionary]
            var trackList = [Track]()
            
            
            for item in tracks {
                let track = Track(thumbnail: item["thumbnail"] as? String, title: item["title"] as? String, link: item["link"] as? String)
               
                trackList.append(track)
            }
        
            completion(trackList, nil)

        }
   
    }
}
