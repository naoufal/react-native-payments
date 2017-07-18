Manual Integration Without CocoaPods
------------------------------------

Please follow these instructions to integrate Braintree iOS into your app without CocoaPods.

> Note: We assume that you are using Xcode 8+ and iOS 9.0+ as your Base SDK.

1. Add the Braintree iOS SDK code to your repository
  - Use git: `git submodule add https://github.com/braintree/braintree_ios.git`
  - Alternatively, you can [download the SDK as a ZIP file from GitHub](https://github.com/braintree/braintree_ios/archive/master.zip) and unzip it into your app's root directory in Finder
  - Delete the following folders: `Braintree-Demo`, `Docs`, `IntegrationTests`, `Specs`, `Unit Tests`
2. Open up your app in Xcode
3. Create a new framework target called `Braintree` (please use this exact name)
  - In Xcode, select `File` > `New` > `Target`
  - Select `Framework & Library` > `Cocoa Touch Framework`
  - Use the following options
    - Product Name: `Braintree`
    - Language: `Objective C`
    - Embed in Application: `[your app target]`
  - You will now see a new `Braintree` Target Dependency in your main app target (in the first section of `Build Phases`).
4. Add the Braintree code to project
  - In Xcode, select `File` > `Add Files to [...]...`
  - Navigate to `[Your app project root]/braintree-ios` and select the `Braintree` directory
  - Under `Add to targets`, make sure your newly-created framework target `Braintree` is checked and that `[your app target]` is unchecked
  - Optionally check `Copy items if needed`
  - Click `Add`
    ![Screenshot of adding the Braintree files to Braintree target](screenshot_add_files.png)
5. Modify the `Braintree` target's build phases (`Project` > `Braintree` > `Build Phases`)
  - In `Compile Sources`, delete all `.md` files (tip: filter by `.md`)
  - In `Headers`
    - Under `Public`, delete `Braintree.h`
    - Select all files under `Project` and drag them to `Public`
  - In `Link Binary With Libraries`
    - Add the following system frameworks:
      - `Contacts`
      - `CoreLocation`
      - `Foundation`
      - `MessageUI`
      - `PassKit`
      - `SystemConfiguration`
      - `UIKit`
    - Update `Contacts` to be weak linked by changing its status to `Optional`.
  - In `Copy Bundle Resources`, remove everything except the `.strings` files.
6. Modify `Braintree` build settings (`Project` > `Braintree` > `Build Settings`)
  - Edit `Public Headers Folder Path` by appending `/Braintree` (e.g. `$(CONTENTS_FOLDER_PATH)/Headers/Braintree`)
  - Edit `Other Linker Flags` by adding `-lc++ -ObjC`
7. Modify `[your app target]` build settings (`Project` > `[your app]` > `Build Settings`)
  - Set `Always Search User Paths` to `Yes`
8. Modify `[your app target]` build phases (select the `[your app]` target, then `Build Phases`)
  - In `Copy Bundle Resources`, add `Drop-In.strings`, `UI.strings` and `Three-D-Secure.strings` from the Braintree framework target (tip: filter by `.strings`)
  ![Screenshot of copying bundle resources for i18n](screenshot_copy_bundles.png)
9. Remove the `Braintree` scheme
  - In Xcode, select `Product` > `Scheme` > `Manage Schemes...`
  - Select the `Braintree` scheme and press the `-` button
10. Build and Run your app to test out the integration
11. [Integrate the SDK in your checkout form](https://developers.braintreepayments.com/ios/start/overview)
