import CoreData

@objc(FriendCoreModel)
public class FriendCoreDataModel: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendCoreDataModel> {
        return NSFetchRequest<FriendCoreDataModel>(entityName: "FriendCoreModel")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var photo: String?
    @NSManaged public var online: Int32
    @NSManaged public var id: Int32

}
