CoreDataUtils is common class provide funciton to create and integrate with CoreData more easy.

How To Get Started

- Download the project.
- Copy DataUtils class to your project.
- We should create the xcdatamodelid first.

- In AppDelegate, we call function to create CoreData

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [DataUtils installDatabaseWithName:@"TestModel"];

    return YES;
}
