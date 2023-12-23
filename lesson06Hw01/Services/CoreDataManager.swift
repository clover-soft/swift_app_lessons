import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let context: NSManagedObjectContext
    
    private init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // Сохранение друзей в Core Data
    func saveFriends(_ friendsData: [FriendsModel.Response.Friend]) {
        friendsData.forEach { friendData in
            let friend = FriendCoreDataModel(context: context)
            friend.id = Int32(friendData.id)
            friend.firstName = friendData.firstName
            friend.lastName = friendData.lastName
            friend.online = Int32(friendData.online)
            friend.photo = friendData.photo
        }
        saveContext()
    }
    
    // Сохранение групп в Core Data
    func saveGroups(_ groupsData: [GroupsModel.Response.Group]) {
        groupsData.forEach { groupData in
            let group = GroupCoreDataModel(context: context)
            group.id = Int32(groupData.id)
            group.name = groupData.name
            group.photo = groupData.photo
            group.screenName = groupData.screenName
        }
        saveContext()
    }
    
    // Извлечение друзей из Core Data
    func fetchFriends() -> [FriendCoreDataModel] {
        do {
            return try context.fetch(FriendCoreDataModel.fetchRequest())
        } catch {
            print("Error fetching friends: \(error)")
            return []
        }
    }
    
    // Извлечение групп из Core Data
    func fetchGroups() -> [GroupCoreDataModel] {
        do {
            return try context.fetch(GroupCoreDataModel.fetchRequest())
        } catch {
            print("Error fetching groups: \(error)")
            return []
        }
    }
    
    // Сохранение контекста Core Data
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("An error occurred while saving: \(error), \(error.userInfo)")
            }
        }
    }
    func deleteAllFriends() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FriendCoreDataModel.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error deleting all friends: \(error)")
        }
    }
    
    // Сохранение времени последнего обновления друзей
    func saveFriendLastUpdate(date: Date) {
      let lastUpdate = getLastUpdateEntity()
      lastUpdate.friendsLastUpdate = date
      saveContext()
    }
    
    // Сохранение времени последнего обновления групп
    func saveGroupLastUpdate(date: Date) {
      let lastUpdate = getLastUpdateEntity()
      lastUpdate.groupsLastUpdate = date
      saveContext()
    }
    
    // Получение LastUpdate сущности, или создание новой если не существует
    private func getLastUpdateEntity() -> LastUpdate {
      let fetchRequest: NSFetchRequest<LastUpdate> = LastUpdate.fetchRequest()
      if let lastUpdate = try? context.fetch(fetchRequest).first {
        // Возвращаем существующую сущность
        return lastUpdate
      } else {
        // Создаем новую сущность, если не существует
        let newLastUpdate = LastUpdate(context: context)
        return newLastUpdate
      }
    }

    // Извлечение времени последнего обновления друзей
    func fetchFriendsLastUpdate() -> String {
      let lastUpdate = getLastUpdateEntity()
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .medium
      dateFormatter.timeStyle = .short
      
      if let date = lastUpdate.friendsLastUpdate {
        return dateFormatter.string(from: date)
      } else {
        return "Неизвестно"
      }
    }

    // Извлечение времени последнего обновления групп
    func fetchGroupsLastUpdate() -> String {
      let lastUpdate = getLastUpdateEntity()
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .medium
      dateFormatter.timeStyle = .short
      
      if let date = lastUpdate.groupsLastUpdate {
        return dateFormatter.string(from: date)
      } else {
        return "Неизвестно"
      }
    }
}
