struct PhotosModel: Codable {
  let response: Response
  
  struct Response: Codable {
    let count: Int
    let items: [Photo]
     
    struct Photo: Codable {
      let id: Int
      let albumId: Int
      let ownerId: Int
      let title: String
      let url: String
      let sizes: [Size]
       
      struct Size: Codable {
        let type: String
        let url: String
        let width: Int
        let height: Int
      }
       
      private enum CodingKeys: String, CodingKey {
        case id
        case albumId = "album_id"
        case ownerId = "owner_id"
        case title
        case url
        case sizes
      }
    }
  }
}
