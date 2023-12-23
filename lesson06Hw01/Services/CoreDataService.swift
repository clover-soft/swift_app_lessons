import UIKit
import CoreData

class ViewController: UIViewController {
    var friends: [FriendCoreModel] = []
    var groups: [GroupCoreModel] = []

    // Для управления контекстом Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFriendsAndGroups()
        loadDataFromAPI()
    }
    
    // Загрузка данных из Core Data
    private func fetchFriendsAndGroups() {
        do {
            friends = try context.fetch(FriendCoreModel.fetchRequest())
            groups = try context.fetch(GroupCoreModel.fetchRequest())
            // Обновить UI
            updateUI()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Загрузка данных из API
    private func loadDataFromAPI() {
        APIManager.shared.getData(for: .friends) { [weak self] data in
            guard let self = self, let items = data as? [FriendsModel.Response.Friend] else { return }
            
            // Сохранить друзей в Core Data
            self.saveFriends(items)
            
            // Обновить UI
            DispatchQueue.main.async {
                self.fetchFriendsAndGroups()
            }
        }
        
        APIManager.shared.getData(for: .groups) { [weak self] data in
            guard let self = self, let items = data as? [GroupsModel.Response.Group] else { return }
            
            // Сохранить группы в Core Data
            self.saveGroups(items)
            
            // Обновить UI
            DispatchQueue.main.async {
                self.fetchFriendsAndGroups()
            }
        }
    }

    // Сохранение друзей в Core Data
    private func saveFriends(_ friendsData: [FriendsModel.Response.Friend]) {
        friendsData.forEach { friendData in
            let friend = FriendCoreModel(context: context)
            friend.id = Int32(friendData.id)
            friend.firstName = friendData.firstName
            friend.lastName = friendData.lastName
            friend.online = Int32(friendData.online)
            friend.photo = friendData.photo
        }
        saveContext()
    }
    
    // Сохранение групп в Core Data
    private func saveGroups(_ groupsData: [GroupsModel.Response.Group]) {
        groupsData.forEach { groupData in
            let group = GroupCoreModel(context: context)
            group.name = groupData.name
            group.photo = groupData.photo
        }
        saveContext()
    }
    
    // Сохранение контекста Core Data
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    // Обновление пользовательского интерфейса
    private func updateUI() {
        // Обновить UI с данными из Core Data
    }
    
    // Показ ошибки
    private func showErrorAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
       
