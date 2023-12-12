//
//  PhotosDataModel.swift
//  lesson03Hw01
//
//  Created by yakov on 12.12.2023.
//

import Foundation

struct PhotosDataModel: Decodable {
    let response: Response
    
    struct Response: Decodable {
        let items: [Photo]
        
        struct Photo: Decodable {
            let sizes: [Size]
            
            struct Size: Decodable {
                let url: String
                
            }
        }
    }
}
