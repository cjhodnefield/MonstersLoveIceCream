CJ Hodnefield

Final Project

Supported Devices: iPad

Supported Orientations: Landscape

PROJECT NAME:

I tried to rename my project from TowerDefenseGridTest to MonstersLoveIceCream. I talked to Andrew, but we could not fix all of the problems, so both names are still sort of hanging around in my file paths on GitHub right now, and I don't want to risk trying to fix them this late in the game. It should work fine for grading and loading my project on a device, but if you have any trouble opening my project, please let me know.

STORYBOARD:

The storyboard only looks good in wRegular hAny, so please view it in that. I didn't have time to fix the others and the current supported devices (iPad) don't need anything else for now.


GAME LOGIC:

If you want to see the grid that shows how everything is moving, there is a boolean near the top of GameScene called gridHidden which can be set to true. This slows down the FPS a ton though, because of how I implemented the grid as a bunch of nodes. I'll fix this later on, but for now it's fine since I intend to run the game without the grid displayed.

The 2x2 array named mapLayout in the Level class acts as a rubric to guide a lot of the initialization work in GameScene. GameScene uses this 2x2 array to create 2 GKGraphGrids. One holds nodes that represent the path from the enemy spawn location to the ice cream shop (the base), and one hold nodes that are valid locations for turrets.

During the game, the play button starts the next wave of enemies. Turrets can be placed by tapping on the area around the path before or during a wave of enemies. Placing a turret reduces the cash value in the upper right, and defeating enemies increases the cash value. If an enemy makes it to the base, the lives count in the upper right will go down. I plan to add animations later to make it more obvious that those values are changing.

In the future, I plan to add many more turret and enemy types, as well as the ability to upgrade or sell existing turrets. I need to play around with the balance of enemy power and tower cost a lot too to determine how to make the game challening, but not impossible.

Currently, clicking on the settings button on the game map will abort the current level and take you back to the main menu. Eventually, I intend to implement that as a pause button that takes you to the main menu, but saves progress so that you can open up the GameScene again and resume that level.

I also haven't implemented records of wins and losses yet. Eventually, I want to track how well the user has done on levels in the past, as well as some other statistics about use of the game.


TURRETS BUTTON:

This button doesn't do anything yet, because I didn't deem it necessary for my project submission and opted to fix and perfect other parts of the app. Eventually, this will lead to a table view that describes the different types of turrets that can be placed. It will also include any boss monsters that the user has befriended.


UIALERT REQUIREMENT:

I had my app preduce a UIAlert on the 5th launch to suggest that the user rate the app on the app store.


WARNINGS:

These warnings may have gone away, but in case they happen during testing, here's my disclaimer:

I keep getting this warning in the console when running my app, but some searching online suggests that there isn't actually anything wrong (some people are accusing it of being an XCode bug). Just wanted to mention that I was aware of the warning, but I don't think I can do anything about it (and I tried).

StackOverflow discussion about it for reference: 
http://stackoverflow.com/questions/34302179/cuicatalog-invalid-request-requesting-subtype-without-specifying-idiom-where


ATTRIBUTIONS:

Note: I created a lot of this art on my own by pulling images together and using photo editors. I credited the images I pulled, but I just wanted you mention that some of the organization and stuff is originally done by me.

FiringComponent.swift:    	/// - Attributions: http://www.raywenderlich.com/57368/trigonometry-game-programming-sprite-kit-version-part-1
GameInfo.swift:				/// - Attributions: http://stackoverflow.com/questions/24059327/detect-current-device-with-ui-user-interface-idiom-in-swift
GameInfo.swift:    			/// - Attributions: http://stackoverflow.com/questions/29984654/nsuserdefaults-key-initialization-when-app-starts-for-the-first-time
GameScene.swift:			/// - Attributions: https://blog.lukasjoswiak.com/gameplaykit-for-beginners-part-1/
GameScene.swift:			/// - Attributions: http://untamed.wild-refuge.net/rmxpresources.php?characters
GameScene.swift:			/// - Attributions: Krasi Wasilev ( http://freegameassets.blogspot.com)
GameScene.swift:			/// - Attributions: https://cdn3.iconfinder.com/data/icons/buttons/512/Icon_3-512.png
Instructions.swift:        	/// - Attributions: Lecture 8
Level.swift:				/// - Attributions: http://ask4asset.com/turret-defense-free-art-pack/
LevelSelect.swift:    		/// - Attributions: https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson8.html#//apple_ref/doc/uid/TP40015214-CH16-SW1
MainMenuViewController.swift:/// - Attributions: http://ic8.link/2969
SettingsViewController.swift:    /// - Attributions: http://www.ioscreator.com/tutorials/uislider-tutorial-ios8-swift
SplashScreen.swift:        	/// - Attributions: http://stackoverflow.com/questions/26379462/how-do-i-perform-an-auto-segue-in-xcode-6-using-swift
Fixed a problem with a warning I couldn't diagnose /// - Attributions: http://stackoverflow.com/questions/26547399/xcode-storyboard-warning-constraint-referencing-items-turned-off-in-current-con

Art:
http://www.freevector.com/site_media/preview_images/FreeVector-Cartoon-Monsters-Set.jpg
http://thumb7.shutterstock.com/display_pic_with_logo/507037/319737431/stock-photo-horned-green-monster-cartoon-character-holding-follow-me-sign-raster-illustration-isolated-on-white-319737431.jpg
http://icecreamuso.hol.es/ice-cream-cartoon.html
http://images.clipartpanda.com/digital-clock-clipart-7-00-ice-cream-clip-art-ycoG8yKcE.png
http://thumb7.shutterstock.com/display_pic_with_logo/507037/319605209/stock-vector-funny-horned-blue-monster-cartoon-character-holding-a-blank-sign-vector-illustration-isolated-on-319605209.jpg
http://thumb101.shutterstock.com/display_pic_with_logo/507037/318203393/stock-vector-smiling-pink-monster-cartoon-character-holding-a-blank-sign-vector-illustration-isolated-on-white-318203393.jpg
http://www.wallquotes.com/sites/default/files/arts0557-20.png
https://s-media-cache-ak0.pinimg.com/236x/85/34/7a/85347ab44f379d2daa3b54edf7eab037.jpg