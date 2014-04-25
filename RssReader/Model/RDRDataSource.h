#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

@interface RDRDataSource : NSObject


#pragma mark - Properties

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


#pragma mark - Constructors


#pragma mark - Static Methods

+ (RDRDataSource *)sharedInstance;


#pragma mark - Instance Methods

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray *)getAllSources;

@end