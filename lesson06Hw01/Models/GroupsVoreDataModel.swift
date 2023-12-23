import CoreData

@objc(GroupCoreModel)
public class GroupCoreDataModel: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupCoreDataModel> {
        return NSFetchRequest<GroupCoreDataModel>(entityName: "GroupCoreModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32
    @NSManaged public var photo: String?
    @NSManaged public var screenName: String?

}

