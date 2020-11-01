###### Documentation of the SkeletonProject #######

### Version 1.2 Changelog ###

Contents from Version 1 as well as initial setup remain almost the same

# New Contents

- Code is migrated to swift 4.2 (The Pods still need to be updated tho in order to silence Xcode's warning...)
- Configurable protocol, ViewConfigurators for abstract customization of cells/views with the optinal logic for asynchronous tableView optimizations
- Slightly changed/added BaseClasses:
    1) BaseVC now has a lot more functionality handling sideMenu types and customizable refreshControl.
    2) BaseView is now split into BaseView and BaseDesignableView (Use the designable one for IBDesignables only)
    !!!Note for IBDesignables: DO NOT USE PODS IN ANY IBDESIGNABLE RELATED FILES!!!. If your view requires a pod.. make it NOT IBDesignable.
    3) BaseDataSourceProtocol which handles basic tableView/Collection view functionality (should be inherited by the viewModel's protocols)
    4) BaseViewConfigurator (related with the first -)
- Updated network kit (main difference is that it now has a BaseAPIRequest class that needs to be inherited from all ApiRequests, also possibility for Caching and custom parsers)
- Introduced Repositories as a pattern that contains the service logic for accessing backend/dataBase
- Updated Templates: Now with more comments and also added template for Repository and APIRequest
- Various extensions added including: Gradient, Animations, ColorBlending, EmptyCollectionViewCell, NetworkKit+NoConnection and some others.
- Snippets: Very useful for autocompleting repeatable code. Tightly integrated with Configurators/BaseDataSource protocol in order for the fastest way to build generic tableViews/CollectionViews
- !!! DOWNLOAD SNIPPETS FROM - https://bitbucket.upnetix.com/projects/IL/repos/xcodesnippets/browse !!!
- !!! Fully functional example showcasing everything you need to know including:
     1) the coordinators flow (with delegates and presenting various screens)
     2) tableView AND collection view created by using the snippets, along with model/repository/ApiRequest example
     3) Example screens and some observables and alerts
- !!! Added Localizer (FLEX) as an integration along with UpnetixLocalizationWrapper. All you need to do for it to function properly is change the APP_ID, URL, SECRET and DOMAINS properties in both the script and in Constants
- !!! For more info on the Localizer -> https://bitbucket.upnetix.com/projects/IL/repos/upnetix-localizer-pod/browse

### Version 1.1 ###

1) For initial setup it should in theory work with just downloading, changing the project name to your desired name, and pod install

2) Contents: 
- Uses MVVM-C architecture - https://medium.com/sudo-by-icalia-labs/ios-architecture-mvvm-c-coordinators-3-6-3960ad9a6d85 (we do not use it completely strictly but the core concept is the same)
- Various helpful extension and functions (should add more in the future)
- Wrappers for Networking, Logging, Analytics
- Swiftlint
- !!! IBDesignables: All custom views should be set to target the IBDesignable target !!!
- !!! DOWNLOAD TEMPLATES FROM - https://bitbucket.upnetix.com/projects/IL/repos/xcodetemplates/browse !!!

3) TODO:
- Possibly add the localizer in the skeleton
- For sure add other extenisons and possibly other wrappers for common logic
- Possibly add predefined hockeyapp and crashlytics integrations
- Possibly add fastfile for hockeyapp/crashlytics/both (maybe testflight as well later)
- Possibly add more functionality to the base classes and other abstractions

######

### Logging Wrapper ###
Use Log.debug("message") and respectively Log.info/warninrg/error/severe to log things at separate levels. Should you need to implement in the wrapper crashlytics logs for a specific level.

### Analytics Wrapper ###
Use Analytics.fireEvent("name", eventArgs: [String: Any]?) to fire analytics events. Should you need to implement in the wrapper firebase analytics or adobe analytics or w/e analytics you might need

### IBDesignables ###
- Use the template to create a custom uiview and !!!SET THE TARGET TO IBDesignables!!!. It will automatically have the BaseView as a parent. The base view has in itself all the magic setup methods used previously
- The base view is public because to access the custom view from code you !!!NEED to write import IBDesignable!!! in the file in which you want to use it. It is a separate framework therefore -> public.. 
- Make your own classes public as well to be able to access them through code. Often there are problems with building the ibdesignables.. still looking into the reasons for it. DerivedData...Clean..Build..Hope for the best

### SystemAlertQueuePod ###
- Use it to queue system alerts (simple or with multiple actions) one after the other if required (for errors/internet connection/any business case that requires system alerts)

######

### Initial Setup! ###
- Copy everything except the .git folder into your new repository.
    - If you have done pod install in the skeleton project don't copy Pods folders as well.
- Open the project in Xcode.
- In Project Navigator view select the Skeleton project node and rename it to #YourProjectName (you can do it from the Inspector view's identity and Type tab or from the Project Navigator).   
    - This will bring a new dialog on the screen - accept to rename all project items.  
- Rename the project folder.
- Rename the Scheme to #YourProjectName.
- In target Build Settings change Info.plist's folder name.
- Go in the podfile and rename the target (the comment perhaps as well) to point to #YourProjectName.
- Go to Terminal app and make pod install.  
**NB!** Do not forget to install SkeletonKit's pods first.  
**NB!** If you don't have localPodspecRepo on your Mac - write: `pod repo add UpnetixPods https://bitbucket.upnetix.com/scm/il/podspecrepo.git`     AND      `pod repo update`  
- Clean the project build folder, close Xcode and delete derived data.
- If you have Skeleton.workspace delete it and open #YourProjectName.workspace
- Go to your project target and change the bundle ID (normally com.upnetix.#YourProjectName)  
**NB!** Again from the project target scroll down to Linked Frameworks and Libraries and remove the old Pods_Skeleton.framework.  
- Delete all `Example*` files and folders in Models, Repositories and Modules folders.
- Build and run.  
**Additional Notes** There is possibly some Skeleton name stuff leftover after this but if you meet any that cause problems or if you have any issues make sure to report them.


######
