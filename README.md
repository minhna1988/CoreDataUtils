CoreDataUtils is simple class provide funcitons:

- Setup your core data with existing model file.
- Fetch entity with condition, sort and limit row.
- Create new entity or update entity when it was existed
- Delete entity with condition

How To Get Started

- Download the project.
- Copy DataUtils class to your project.
- You should create the xcdatamodelid first.
- In AppDelegate, didFinishLaunchingWithOptions function, call function to create CoreData: [DataUtils installDatabaseWithName:<xcdatamodelid's name>]

-----------------------------------------