//
//  HomeViewModel.swift
//  SoundCast
//
//  Created by Ankur on 1/18/19.
//  Copyright © 2019 ankur. All rights reserved.
//

import Foundation
import UIKit

struct HomeViewModel {
    
    let title: String
    
    let link: String
    let thumbnailURL: String
    
    // Dependency Injection (DI)
    init(track: Track) {
        self.title = track.title ?? "Untitled"
        self.link = track.link ?? ""
        self.thumbnailURL = track.thumbnail ?? ""
        
    }
    
}
