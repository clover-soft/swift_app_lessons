//
//  GroupsModel.swift
//  lesson03Hw01
//
//  Created by yakov on 12.12.2023.
//

import Foundation
struct GroupsModel: Decodable {
    let response: Response
    
    struct Response: Decodable {
        let items: [Group]
        
        struct Group: Decodable {
            let name: String
            let photo: String
            
            enum CodingKeys: String, CodingKey {
                case name
                case photo = "photo_50"
            }
        }
    }
}
