//
//  FriendsDataModel.swift
//  lesson03Hw01
//
//  Created by yakov on 12.12.2023.
//

import Foundation
struct FriendsModel: Decodable {
    let response: Response
    
    struct Response: Decodable {
        let items: [Friend]
        
        struct Friend: Decodable {
            let firstName: String
            let lastName: String
            let photo: String
            let online: Int
            
            enum CodingKeys: String, CodingKey {
                case firstName = "first_name"
                case lastName = "last_name"
                case photo = "photo_50"
                case online
            }
        }
    }
}
