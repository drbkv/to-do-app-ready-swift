import CoreData

@objc(Task)
public class Task: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var completed: Bool
    @NSManaged public var voiceNoteURL: String?

    
}
