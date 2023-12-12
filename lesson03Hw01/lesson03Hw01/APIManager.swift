//
//  APIManager.swift
//  lesson03Hw01
//
//  Created by yakov on 12.12.2023.
//

import Foundation

final class APIManager {
    private let session: URLSession
    
    static private var token = ""
    static private var userId = ""

    static func setCredentials(_ token: String, _ userId: String) {
        self.token = token
        self.userId = userId
        print(token)
        print(userId)
    }
        
    enum Requests {
        case friends
        case groups
        case photos
    }
    
    static let shared = APIManager()
    
    private init() {
        session = URLSession.shared
    }
    
    private func getRequestUrl(for request: Requests) -> URL? {
        var urlString = ""
//        var dataType: Any.Type
        
        switch request {
        case .friends:
            urlString = "https://api.vk.com/method/friends.get?fields=nickname,photo_50&access_token=\(APIManager.token)&v=5.199"
//            dataType = FriendsModel.self
        case .groups:
            urlString = "https://api.vk.com/method/groups.get?extended=1&access_token=\(APIManager.token)&v=5.199"
//            dataType = GroupsModel.self
        case .photos:
            urlString = "https://api.vk.com/method/photos.getAll?owner_id=\(APIManager.userId)&access_token=\(APIManager.token)&v=5.199"
//            dataType = PhotosModel.self
        }
        
        guard let url = URL(string: urlString) else {
            print("Error while creating URL")
            return nil
        }
        
        return url
    }
    
    func getData(for request: Requests) {
        guard let url = getRequestUrl(for: request) else {
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                switch request {
                case .friends:
                    let decodedData = try JSONDecoder().decode(FriendsModel.self, from: data)
                    print(decodedData)
                    break
                case .groups:
                    let decodedData = try JSONDecoder().decode(GroupsModel.self, from: data)
                    print(decodedData)
                    break
                case .photos:
                    let decodedData = try JSONDecoder().decode(PhotosModel.self, from: data)
                    print(decodedData)
                    break
                }
            } catch {
                print(error)
            }
            
        }.resume()
    }
}
