struct GroupsModel: Codable {
  let response: Response
  
  struct Response: Codable {
    let count: Int
    let items: [Group]
     
    struct Group: Codable {
      let id: Int
      let name: String
      let description: String
      let membersCount: Int
      let photo: String
      let deactivated: String?
       
      private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case membersCount = "members_count"
        case photo = "photo_100"
        case deactivated
      }
    }
  }
}
