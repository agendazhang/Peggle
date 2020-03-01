# CS3217 Problem Set 4

**Name:** Zhang Cheng

**Matric No:** A0173268X

## Tips
1. CS3217's docs is at https://cs3217.netlify.com. Do visit the docs often, as
   it contains all things relevant to CS3217.
2. A Swiftlint configuration file is provided for you. It is recommended for you
   to use Swiftlint and follow this configuration. We opted in all rules and
   then slowly removed some rules we found unwieldy; as such, if you discover
   any rule that you think should be added/removed, do notify the teaching staff
   and we will consider changing it!

   In addition, keep in mind that, ultimately, this tool is only a guideline;
   some exceptions may be made as long as code quality is not compromised.
3. Do not burn out. Have fun!

## Dev Guide

### About
This is an iPad game similar to the popular game `Peggle`. The game is made up of 
different levels that have blue, orange and green pegs on them. The objective is to clear 
all the orange pegs in each level by shooting cannon balls from a cannon at the top of the 
screen.

Here are some screenshots of the game.
* Main Menu: Select "Design Level" to design your own level.
![alt text](https://github.com/cs3217-1920/2020-ps4-agendazhang/blob/master/images/MainMenu.png)
* Level Designer: Place blue, orange or green pegs on the board to customize your own level, then select "Start" to start playing.
![alt text](https://github.com/cs3217-1920/2020-ps4-agendazhang/blob/master/images/LevelDesignerWithoutPegs.png)
![alt text](https://github.com/cs3217-1920/2020-ps4-agendazhang/blob/master/images/LevelDesignerWithPegs.png)
* Gameplay: Shoot the cannon ball from the cannon on top of the screen to clear all the orange pegs on the board. Rotate the cannon by swiping clockwise or anti-clockwise on the game board (light blue background) to change the angle to launch the ball. Tap the game board (light blue background) to shoot the cannon.
![alt text](https://github.com/cs3217-1920/2020-ps4-agendazhang/blob/master/images/PeggleGame.png)
* Save Level: At the Level Designer, you can also save the level that you have created on your iPad to load and play them later on.
![alt text](https://github.com/cs3217-1920/2020-ps4-agendazhang/blob/master/images/LevelDesignerSaveLevel.png)
* Load Level: Load a previously saved level to edit or play.
![alt text](https://github.com/cs3217-1920/2020-ps4-agendazhang/blob/master/images/LevelSelector.png)

### Features
* Peg shooting (in development)
	* Shoot cannon ball from a fixed cannon at the top of the screen to clear all the orange 
   pegs at each level.
* Physics Engine
   * The game has its own Physics Engine design which controls the physics of the bouncing ball and collisions.
* Level Designer
	* Create your own level by placing pegs anywhere on the board. You can save the levels 
   that you have created and load the levels to continue editing or play it.
   
### Design
Below shows the class diagram of all the features.
![alt text](https://github.com/cs3217-1920/2020-ps4-agendazhang/blob/master/images/Class%20Diagram.png)

For the Level Designer feature, it follows the Model-View-Controller (MVC) architechture pattern.

The `Model` component is mainly in charge of the storage and representation of the underlying data 
structures of the game, as well as the domain logic for the Level Designer feature. The `Peg` class 
represents a single peg, the `PegBoard` class consists of pegs and represents a board where pegs can 
be placed on it. The `PegBoardLevel` class represents a level in the game.

The `View` component mainly specifies the display of the UI components to the user. For example, the 
`PegView` class represents a the UI part of a single peg in the board. If it is assigned to be of blue 
color, it will load the blue peg image to display.

The `Controller` component acts as a middle-man between the `Model` and `View` components. When the 
`Controller` component detects a change like a button tap, it will inform the `Model` to do the necessary updates, 
then get information from the `Model` to update the view that is displayed to the user. It is in charge 
of the presentation logic as it manages the view whenever there is a change in the internal model.

An example will be when the user taps on the peg board to add a new peg. The `LevelDesignerViewController` 
will sense this tap through a `UITapGestureRecognizer`. It will get the location of the tap, then passes 
it to `PegBoardLevel` to handle the internal domain logic to add the peg. `PegBoardLevel` will then call 
the `addPeg()` method of the `PegBoard` class, which checks whether the location of the tap is a valid one.
If valid, it will update the internal structure of the peg board by adding a new `Peg`. It will then pass 
the information on whether the operation is successful to the `LevelDesignerViewController` class. `LevelDesignerViewController` will finally update the view of the peg board by adding a new `PegView` subview.

`LevelDesignerSaveLevelViewController` is the controller that is in charge of saving the data to file. The domain logic that handles the saving of data will be in `LevelSaver`. `LevelSelectorViewController` is in charge of loading the saved levels to continue editing or play. The domain logic that handles the loading of data will be in `LevelLoader`.

For the gameplay feature, it also follows the Model-View-Controller (MVC) architechture pattern. 

The `Model` component is mainly in charge of the representation of the underlying data 
structures of the game state, as well as the domain logic for the game. The `Peg` class 
represents a single peg, the `CannonBall` class represents a single cannon ball that is fired from the cannon, the `Wall` represents the 4 sides of the game screen, the `Bucket` represents the bucket that will try to catch the falling cannon ball. Both the `Peg` and `CannonBall` classes conform to the `PhysicsCircle` protocol, which specifies that they need to have a `radius` attribute. Both the `Bucket` and `Wall` classes conform to the `PhysicsRectangle` protocol which specifies that it needs to have `width` and `height` attributes. Both `PhysicsCircle` and `PhysicsRectangle` extends from the `PhysicsObject` protocol, which specifies some attributes, such as `x` and `y` coordinates of the object, `velocity` of the object and its `uuid`. The `PhysicsEngine` simulates physics interactions between the different `PhysicsObject`. It moves the objects based on their velocity, adds gravity to their velocity and checks for collisions between the different objects. It also contains a `PhysicsCollisionHandler` attribute, and `PhysicsCollisionHandler` is a protocol which specifies the methods that a collision handler class should conform to after the objects collide. The `PhysicsEngine` not only allows our `Peggle` game engine to be built on top of it, but also other games that have physics interactions. On top of the `PhysicsEngine` is our `PeggleGameEngine`, which is in charge of managing the overall game state of our `Peggle` game. It sets up the game board with pegs and walls before the game starts, allows the cannon to be fired and handles the game logic such as what happens when the cannon ball hits a peg and what happens when the cannon ball exits the stage. It has a `PeggleGameCollisionHandler`, which conforms to `PhysicsCollisionHandler` and handles collisions between objects. It also has a `PeggleGameCondition`, which keeps track of the win/lose condition of the game and count of game objects, such as number of orange pegs left, number of cannon balls remaining, game time left and the score that the user has obtained.

The `Controller` component will be the `PeggleGameRenderer`, which is in charge of the presentation logic of the qame state. It is informed by the `PeggleGameEngine` on the changes in the internal representation of the game state, and controls the display on the UI screen.

The `View` component is the UI components on the screen. For example, the 
`PegView` class represents the UI part of a single peg in the board. The `PegGlowView` class represents the UI part of a peg that has lit up after being hit by the cannon ball. The `CannonBallView` represents the UI part of the cannon ball. The `BucketView` represents the UI part of the bucket.

The position of the physics objects in the game will change due to the `Timer` object in `PeggleGameEngine`. At each interval in the timer in the `gameInterval()` method, `PeggleGameEngine` will create a `PhysicsEngine` object that is initialized by the current physics objects in the game and the `PeggleGameCollisionHandler`. The `moveObjects()` method of `PhysicsEngine` is called, which moves the positions of objects based on their velocities. `PhysicsEngine` will then check for any collisions between its object after any of its object moves. If so, it will call the respective collision handler method from `PeggleGameCollisionHandler` (which conforms to `PhysicsCollisionHandler`) to handle the collision. After the positions of the physics objects are set in each interval after `PhysicsEngine` handled them, `PeggleGameEngine` will finally call the `moveImages()` method of `PeggleGameRenderer`, which moves the images of each object on the UI screen based on their new positions.

An example will be when the `CannonBall` object collides with one of the `Peg` object. At the previous interval of `Timer`, the cannon ball is very close to the peg but not yet collided. At the current interval of `Timer`, `PeggleGameEngine` will create a `PhysicsEngine` object that is initialized by the current physics objects in the game and the `PeggleGameCollisionHandler`. The `moveObjects()` method of `PhysicsEngine` is called, and moves the cannon ball towards the peg. The peg's position does not change since it cannot move and its velocity is zero. `PhysicsEngine` will then detect that the cannon ball has collided with the peg with its `checkCollisionForCircleWithCircle()` method. It will then call `handleCollisionForCircleWithCircle()` method of `PeggleGameCollisionHandler` class, which changes the velocity of the cannon ball based on the angle of collision and the cannon ball's original velocity. It will also alert the `PeggleGameEngine` that a collision between a cannon ball and peg has occurred through the `cannonBallHitsPeg()` method, which will call `changeImage()` method of `PeggleGameRenderer` to change the image of the peg to one that lights up. Finally, after the internal physics logic has been handled, `gameInterval()` of `PeggleGameEngine` will need to update the new position of the cannon ball on the UI screen after the collision. The `moveImages()` method of `PeggleGameRenderer` will be called to do so.

The performance constraints for the gameplay feature are as follows:
* Due to the effect of gravity added on the cannon ball and the cannon can only be fired towards the bottom half part of the game board, there are certain parts on the top left and top right hand side of the game board that the cannon ball cannot reach when the cannon ball is first fired from the cannon. Hence, the pegs that are placed there can only be cleared if the ball hits a peg below and bounces up.
* If you place a peg directly below the cannon and you fire the cannon ball straight down, it will hit the peg, bounce up and hit the top wall, bounce back down and hit the peg again, repeating this forever. This is because the pegs that are hit will only be removed once the cannon ball reaches the bottom and is removed from the game board. Hence, when the user designs the level, they should avoid such cases where the cannon ball will not be able to go down.

## Rules of the Game
Please write the rules of your game here. This section should include the
following sub-sections. You can keep the heading format here, and you can add
more headings to explain the rules of your game in a structured manner.
Alternatively, you can rewrite this section in your own style. You may also
write this section in a new file entirely, if you wish.

### Cannon Direction
Rotate the cannon by swiping clockwise or anti-clockwise on the game board (light blue background) to change the angle to launch the ball. Tap the game board (light blue background) to shoot the cannon.

### Win and Lose Conditions
To win:
* Clear all the orange pegs in the level within time limit and before you run out of cannon balls.

To lose:
* There is a game timer which gives 60 seconds (excluding the extra time that you can receive) for each level. If the timer reaches 0.0 before you clear all the orange pegs, you lose the game. If you hit all the remaining orange pegs with the cannon ball but the cannon ball failed to reach the bottom of the screen/enters the bucket (meaning it is still in motion in the game board) and time runs out, you will also lose the game. This is because the pegs that are hit by the cannon ball will only be removed from the game board after the cannon ball reaches the bottom of the screen/enters the bucket.
* You are given 10 cannon balls (excluding the free balls that you can receive) for each level. If you run out of cannon balls and there are still orange pegs remaining, you lose the game. If you manage to clear the remaining orange pegs with your last cannon ball, you will win the game.

## Level Designer Additional Features

### Peg Rotation
i did not implement the triangular pegs feature.

### Peg Resizing
There are two buttons beside the "Delete" button in the Level Designer. The one with the "plus" sign in the magnifying glass represents the "increase size" button, while the other with the "minus" sign in the magnifying glass represents the "decrease size" button. If you select the "increase size"/"decrease size" button, then click on an existing peg on the board, it will increase/decrease the size of the peg respectively. The maximum size of the peg that you can increase is 2 times of its original radius, while the minimum size that you can decrease is 0.5 times of its original radius.

If you try to increase/decrease the size of the peg, but the new peg will overlap with another existing peg or exceed the boundaries of the screen, then the operation will be cancelled and the peg remains the same size.

## Powerups
You can gain powerups by hitting a green peg. The type of powerup gained will be explained below.

### Time Boost
If there is less than 10.0 seconds left on the game timer, this powerup will be activated. An additional 30.0 seconds will be added to the game timer.

### Space Blast
If there is more than 10.0 seconds left on the game timer, and there are 10 or more remaining orange pegs (the orange pegs that are hit this turn before the cannon ball reaches the bottom/enters the bucket are considered "remaining" and "not cleared yet"), this powerup will be activated. Any peg that is within a short distance (it is set as 80 in my game) from the green peg will be considered hit by the cannon ball and lighted up. If another green ball is hit by this manner, it will also activate its own powerup.

### Spooky Ball
If there is more than 10.0 seconds left on the game timer, and there are less than 10 remaining orange pegs (the orange pegs that are hit this turn before the cannon ball reaches the bottom/enters the bucket are considered "remaining" and "not cleared yet"), this powerup will be activated. After the current cannon ball reaches the bottom/enters the bucket, an extra cannon ball will be fired from the top, where the x-position will be the same as the x-position where the previous cannon ball reaches the bottom/enters the bucket, at a random angle. This extra cannon ball will not be subtracted from the remaining count of cannon ball. If this extra cannon ball enters the bucket, you will also gain an extra cannon ball.

## Bells and Whistles

* There is a home button at Level Designer and game screen. Once pressed, it will return to the main menu.
* There is a Play/Pause button at the game screen. You can press it to pause the game, or resume a paused game. Once paused, the game timer will stop running, the game objects will also stop moving and the cannon cannot be fired. Once resumed, the game timer will continue running, the game objects will continue moving and the cannon can once again be fired.
* The number of blue, orange and green pegs that are currently added are displayed at the top of the Level Designer screen.
* The number of orange pegs and cannon balls remaining are displayed at the bottom of the game screen.
* There is a game timer for the game. The time remaining is displayed at the bottom left of the game screen. It is elaborated in the "Win and Lose Conditions" section.
* There is a score system for the game. It adds up the scores of each shot by the cannon ball. For each shot, hitting a blue or green peg gives 10 points and an orange peg gives 100 points. The sum is then multiplied by the total number of pegs hit in that shot. For example, if you hit 10 blue pegs, 5 orange pegs, and 1 green peg, the total score is (10 * 10 + 5 * 100 + 1 * 10) * (10 + 5 + 1) = 9760. The score of the game is displayued at the bottom right of the game screen.
* There is an extra powerup "Time Boost" if you hit a green peg. It is elaborated in the "Powerups" section.
* If you win the game, the "YOU WIN" popup will also display the total time that you took for the level and the score you obtained.
* Once a powerup is activated, there will be an animation that displays the name of the powerup on the game board, then fades away.
* Once the cannon ball enters the bucket, there will be an animation that displays "+1 FREE BALL" on the game board, then fades away.
* There is music being played in the background of the main menu, Level Designer and game screens.
* When a powerup is activated, a sound will be played.
* When the cannon is fired, a sound will be played.
* When the cannon ball enters the bucket, a sound will be played.
* When you win the game, a cheerful sound will be played.
* When you lose the game, a disappointed sound will be played.

## Tests

### Unit Tests
* `Peg.swift`
	* `init` method
		* When passed with `(x: CGFloat, y: CGFloat, color: PegColor, radius: CGFloat)`, it should initialize the properties `x`, `y` and `color` to the respective values.
		* It should not be passed with any other properties other than `(coder decoder: NSCoder)`
	
	* `==` method
		* When I create two `Peg` objects by passing the same `(x: CGFloat, y: CGFloat, color: PegColor, radius: CGFloat)` properties, they should give `true` when tested for equality.
		* When I create two `Peg` objects by passing any different `(x: CGFloat, y: CGFloat, color: PegColor, radius: CGFloat)` properties, they should give `false` when tested for equality.
	
	* `init?(coder decoder: NSCoder)` and encode() methods
		* let testPeg = Peg(x: 5, y: 3, color: .Blue, radius: 5), let data = try NSKeyedArchiver.archivedData(withRootObject: testPeg, requiringSecureCoding: false). Testing data should not return nil.
		* let testPeg = Peg(x: 5, y: 3, color: .Blue, radius: 5), let data = try NSKeyedArchiver.archivedData(withRootObject: testPeg, requiringSecureCoding: false), let testPeg2 = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Peg. Testing testPeg2 should not return nil.
		* let testPeg = Peg(x: 5, y: 3, color: .Blue, radius: 5), let data = try NSKeyedArchiver.archivedData(withRootObject: testPeg, requiringSecureCoding: false), let testPeg2 = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Peg. Testing testPeg == testPeg2 should give true when tested with the `==` method since a `Peg` object encoded and then decoded should give the same object.
		
* `PegBoard.swift`
	* `init` method
		* When passed with `(boardWidth: CGFloat, boardHeight: CGFloat, pegs: [Peg])`, it should initialize the properties `boardWidth`, `boardHeight` and `pegs` to the respective values.
		* When passed with `(boardWidth: CGFloat, boardHeight: CGFloat)`, it should initialize the properties `boardWidth` and `boardHeight` to the respective values, and `pegs` should be initialized to an empty `Peg` array.
		* When passed with `()`, it should initialize the properties `boardWidth` and `boardHeight` to the default values stated in `NumberConstants.swift`, and `pegs` should be initialized to an empty `Peg` array.
		* The properties `numRows` and `numCols` should be initialized to the default values stated in `NumberConstants.swift` for all 3 of the above constructors.
		* It should not be passed with any other properties other than `(coder decoder: NSCoder)`
	
	* `getPegPosition(targetPeg: Peg)` method
		* When passed with any `Peg` object, it should return a `CGPoint` value where the `CGPoint.x` property is equal to the `x` property of the peg and the `CGPoint.y` property is equal to the `y` property of the peg.
	
	* `getPeg(point: CGPoint)` method: Point must be within a radius distance from any peg in the board
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), let point = CGPoint(x: 100, y: 100), pegBoard.getPeg(point: point) should return nil as pegBoard.pegs is currently empty.
		* let pegs = \[Peg(x: 100, y: 100, color: .Blue, radius: 10)\], let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024, pegs: pegs), let point = CGPoint(x: 100, y: 100), pegBoard.getPeg(point: point) should return Peg(x: 100, y: 100, color: .Blue, radius: 5) as pegBoard.pegs contains the peg that is centered at (x: 100, y: 100).
		* let pegs = \[Peg(x: 100, y: 100, color: .Blue, radius: 10)\], let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024, pegs: pegs), let point = CGPoint(x: 105, y: 105), numRows and numCols both equal 20, pegBoard.getPeg(point: point) should return Peg(x: 100, y: 100, color: .Blue, radius: 10) as pegBoard.pegs contains the peg at (x: 100, y: 100) that the point (x: 105, y: 105) is within a radius distance away.
		* let pegs = \[Peg(x: 100, y: 100, color: .Blue, radius: 10)\], let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024, pegs: pegs), let point = CGPoint(x: 130, y: 130), numRows and numCols both equal 20, pegBoard.getPeg(point: point) should return nil as pegBoard.pegs only contain the peg at (x: 100, y: 100) and the point (x: 130, y: 130) is more than a radius distance away.
	
	* `addPeg(position: CGPoint, color: PegColor)` method: Added peg's position must be more than a radius distance away from all 4 borders and more than a diameter distance away from all the other pegs in the board
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position = CGPoint(x: 10, y: 10), addPeg(position: position, color = .Blue) should return false as the added peg is within a radius away (radius = 1024 / 2 / 20 = 25.6) from 2 of the borders. pegBoard.pegs should be now empty as the peg is not added.
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position = CGPoint(x: 100, y: 100), addPeg(position: position, color = .Blue) should return true as pegBoard.pegs is currently empty and the added peg is more than a radius away (radius = 1024 / 2 / 20 = 25.6) from all four borders. pegBoard.pegs should now contain the peg at (x: 100, y: 100).
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position1 = CGPoint(x: 100, y: 100), addPeg(position: position1, color = .Blue), let position2 = CGPoint(x: 120, y: 120), addPeg(position: position2, color = .Blue) should return false as pegBoard.pegs currently has the first peg at (x: 100, y: 100), which is within a diameter away (diameter = 1024 / 20 = 51.2) from the second peg at (x: 120, y: 120) so the second peg cannot be added in. pegBoard.pegs should now only contain the first peg at (x: 100, y: 100).
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position1 = CGPoint(x: 100, y: 100), addPeg(position: position1, color = .Blue), let position2 = CGPoint(x: 200, y: 200), addPeg(position: position2, color = .Blue) should return true as pegBoard.pegs currently has the first peg at (x: 100, y: 100), which is more than a diameter away (diameter = 1024 / 20 = 51.2) from the second peg at (x: 200, y: 200). The second peg is also more than a radius distance away from all 4 borders, so the second peg can be added in. pegBoard.pegs should now contain the first peg at (x: 100, y: 100) and the second peg at (x: 200, y: 200).
		
	* `removePeg(position: CGPoint)` method: Position must be within a radius distance away from any of the pegs in the board for the peg to be removed.
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position = CGPoint(x: 100, y: 100), removePeg(position: position) should give false as pegBoard.pegs is currently empty and there is no peg to be removed.
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position1 = CGPoint(x: 100, y: 100), addPeg(position: position1, color = .Blue), let position = CGPoint(x: 105, y: 105), removePeg(position: position) should give true as pegBoard.pegs contains the peg at (x: 100, y: 100) which is within a radius distance away (radius = 1024 / 2 / 20 = 25.6) from the position (x: 105, y: 105). The peg is removed and pegBoard.pegs should now be empty.
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position1 = CGPoint(x: 100, y: 100), addPeg(position: position1, color = .Blue), let position = CGPoint(x: 200, y: 200), removePeg(position: position) should give false as pegBoard.pegs contains the peg at (x: 100, y: 100) which is more than a radius distance away (radius = 1024 / 2 / 20 = 25.6) from the position (x: 200, y: 200). The peg is not removed and pegBoard.pegs should still contain the peg.
		
	* `movePeg(oldPosition: CGPoint, newPosition: CGPoint)` method: oldPosition should be within a radius distance away from any peg in the board. newPosition should be more than a radius distance away from all 4 borders and more than a diameter distance away from all the other pegs in the board
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let oldPosition = CGPoint(x: 100, y: 100), let newPosition = CGPoint(x: 200, y: 200), movePeg(oldPosition: oldPosition, newPosition: newPosition) should give false as pegBoard.pegs is currently empty and there is no peg to be moved.
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let oldPosition = CGPoint(x: 100, y: 100), addPeg(position: oldPosition, color = .Blue), let newPosition = CGPoint(x: 200, y: 200), movePeg(oldPosition: oldPosition, newPosition: newPosition) should give true as pegBoard.pegs contains the peg at (x: 100, y: 100) which is within a radius distance away (radius = 1024 / 2 / 20 = 25.6) from the oldPosition (x: 100, y: 100). The newPosition (x: 200, y: 200) is also more than a radius distance from all 4 borders and there are no other pegs in the board. pegBoard.pegs should now contain the original peg at new location (x: 200, y: 200).
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let oldPosition = CGPoint(x: 100, y: 100), addPeg(position: oldPosition, color = .Blue), let newPosition = CGPoint(x: 10, y: 10), movePeg(oldPosition: oldPosition, newPosition: newPosition) should give false as the newPosition (x: 10, y: 10) is within a radius distance (radius = 1024 / 2 / 20 = 25.6) from 2 of the borders. pegBoard.pegs should now contain the original peg at the old location (x: 100, y: 100).
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let oldPosition1 = CGPoint(x: 100, y: 100), addPeg(position: oldPosition1, color = .Blue), let oldPosition2 = CGPoint(x: 200, y: 200), addPeg(position: oldPosition2, color = .Blue), newPosition = CGPoint(x: 205, y: 205), movePeg(oldPosition: oldPosition1, newPosition: newPosition) should give false as the newPosition (x: 205, y: 205) is within a radius distance (radius = 1024 / 2 / 20 = 25.6) from the second peg at (x: 200, y: 200). pegBoard.pegs should now contain the 2 original pegs at the old locations (x: 100, y: 100) and (x: 200, y: 200).
		
	* `resetPegBoard()` method
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let oldPosition1 = CGPoint(x: 100, y: 100), addPeg(position: oldPosition1, color = .Blue), let oldPosition2 = CGPoint(x: 200, y: 200), addPeg(position: oldPosition2, color = .Blue). resetPegBoard() should give true as it empties the peg board. pegBoard.pegs should now be an empty array.
		
	* `increasePegSize(position: CGPoint)` method
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position = CGPoint(x: 100, y: 100), addPeg(position: position, color = .Blue). increasePegSize(position: position) should increase the radius of the peg by 1.1 times.
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position1 = CGPoint(x: 100, y: 100), addPeg(position: position1, color = .Blue). let position2 = CGPoint(x: 105, y: 105). increasePegSize(position: position) should increase the radius of the peg by 1.1 times since position2 is within radius distance away from the peg.
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position1 = CGPoint(x: 100, y: 100), addPeg(position: position1, color = .Blue). let position2 = CGPoint(x: 130, y: 130). increasePegSize(position: position) should should not have any effect on the peg since position2 is more than a radius distance away from the peg.
		* If the peg is directly beside any of the border, increasePegSize(position: position) should not have any effect on the peg as the peg will exceed the borders.
		* If the peg is directly beside any other peg, increasePegSize(position: position) should not have any effect on the peg as the peg will overlap with another peg.
		
	* `decreasePegSize(position: CGPoint)` method
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position = CGPoint(x: 100, y: 100), addPeg(position: position, color = .Blue). decreasePegSize(position: position) should decrease the radius of the peg by 0.9 times.
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position1 = CGPoint(x: 100, y: 100), addPeg(position: position1, color = .Blue). let position2 = CGPoint(x: 105, y: 105). decreasePegSize(position: position) should decrease the radius of the peg by 0.9 times since position2 is within radius distance away from the peg.
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let position1 = CGPoint(x: 100, y: 100), addPeg(position: position1, color = .Blue). let position2 = CGPoint(x: 130, y: 130). decreasePegSize(position: position) should should not have any effect on the peg since position2 is more than a radius distance away from the peg.
		
	* `init?(coder decoder: NSCoder)` and encode() methods
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let oldPosition1 = CGPoint(x: 100, y: 100), addPeg(position: oldPosition1, color = .Blue), let oldPosition2 = CGPoint(x: 200, y: 200), addPeg(position: oldPosition2, color = .Blue), let data = try NSKeyedArchiver.archivedData(withRootObject: pegBoard, requiringSecureCoding: false). Testing data should not return nil.
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let oldPosition1 = CGPoint(x: 100, y: 100), addPeg(position: oldPosition1, color = .Blue), let oldPosition2 = CGPoint(x: 200, y: 200), addPeg(position: oldPosition2, color = .Blue), let data = try NSKeyedArchiver.archivedData(withRootObject: pegBoard, requiringSecureCoding: false), let pegBoard2 = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? PegBoard. Testing pegBoard2 should not return nil.
		* let pegBoard = PegBoard(boardWidth: 1024, boardHeight: 1024), numRows and numCols both equal 20, let oldPosition1 = CGPoint(x: 100, y: 100), addPeg(position: oldPosition1, color = .Blue), let oldPosition2 = CGPoint(x: 200, y: 200), addPeg(position: oldPosition2, color = .Blue), let data = try NSKeyedArchiver.archivedData(withRootObject: pegBoard, requiringSecureCoding: false), let pegBoard2 = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! PegBoard. Testing pegBoard1.boardWidth == pegBoard2.boardWidth should give true. Testing pegBoard1.boardHeight == pegBoard2.boardHeight should give true. Testing pegBoard1.pegs == pegBoard2.pegs should give true. A `PegBoard` object encoded and then decoded should give the same object.
		
* `PegBoardLevel.swift`
	* `init` method
		* When passed with `()`, `pegBoard` property should be initialized with the `init()` method of `PegBoard` class, `levelName` property should be nil.
		* When passed with `(boardWidth: CGFloat, boardHeight: CGFloat)`, `pegBoard` property should be initialized with the `init(boardWidth: CGFloat, boardHeight: CGFloat)` method of `PegBoard` class, `levelName` property should be nil.
		* When passed with `(boardWidth: CGFloat, boardHeight: CGFloat, levelName: String)`, `pegBoard` property should be initialized with the `init(boardWidth: CGFloat, boardHeight: CGFloat)` method of `PegBoard` class, `levelName` property should be initialized to `levelName`.
		* When passed with `(pegBoard: PegBoard, levelName: String)`, `pegBoard` property should be initialized with the value of `pegBoard`, `levelName` property should be initialized to `levelName`.
	* `getPegPosition()`, `getPeg()`, `addPeg()`, `removePeg()`, `movePeg()`, `resetPegBoard(), increasePegSize(), decreasePegSize()` methods should give the same outcome as the respective methods in `PegBoard` class with the same inputs, as they simply call those methods in `PegBoard` class.
	
* `CannonBall.swift`
	* `init` method
		* When passed with `(x: CGFloat, y: CGFloat, radius: CGFloat, velocity: CGVector)`, it should initialize the properties `x`, `y`, `radius` and `velocity` to the respective values. Its other properties `uuid` and `canMove` should also be initialized, with `canMove` being `true`.
		* It should not be passed with any other properties.
		
* `Wall.swift`
	* `init` method
		* When passed with `(x: CGFloat, y: CGFloat, wallType: WallType, width: CGFloat, height: CGFloat)`, it should initialize the properties `x`, `y`, `wallType`, `width` and `height` to the respective values. Its other properties `uuid`, `canMove` and `velocity` should also be initialized, with `canMove` being `true` and `velocity` being zero.
		* It should not be passed with any other properties.
		
* `PhysicsEngine.swift`
	* `init` method
		* When passed with `(physicsObjects: [PhysicsObject], physicsCollisionHandler: PhysicsCollisionHandler)`, it should initialize the properties `physicsObject` and `physicsCollisionHandler` to the respective values.
		* It should not be passed with any other properties.
	* `moveObjects()` method
		* When this method is called, the `x` and `y` properties of all the physics objects should increase/decrease by their own `dx` and `dy` properties respectively.
	* `addGravityToObjects()` method
		* Whem this method is called, the `dy` property of all the physics objects whose `canMove` is `true` should increase by `NumberConstants.gravityForce`.
	* `checkCollisionForCircleWithCircle(physicsCircle: PhysicsCircle, physicsCircle2: PhysicsCircle)` method
		* If the distance between the centre of `physicsCircle` and `physicsCircle2` calculated using their `x` and `y` values is more than the sum of their `radius`, a collision should not be detected.
		* If the distance between the centre of `physicsCircle` and `physicsCircle2` calculated using their `x` and `y` values is less than the sum of their `radius`, a collision should be detected.
	* `checkCollisionForCircleWithRectangle(physicsCircle: PhysicsCircle, physicsRectangle: PhysicsRectangle)` method
		* If no part of the `physicsCircle` overlaps with any part of the `physicsRectangle` after calculating using the `x`, `y`, `radius` values of the `physicsCircle` and the `x`, `y`, `width`, `height` of the `physicsRectangle`, a collision should not be detected.
		* If any part of the `physicsCircle` overlaps with some part of the `physicsRectangle` after calculating using the `x`, `y`, `radius` values of the `physicsCircle` and the `x`, `y`, `width`, `height` of the `physicsRectangle`, a collision should be detected.
	* `checkCollisionForRectangleWithRectangle(physicsRectangle: PhysicsRectangle, physicsRectangle2: PhysicsRectangle)` method
		* If no part of the `physicsRectangle` overlaps with any part of the `physicsRectangle2` after calculating using their `x`, `y`, `width`, `height` values, a collision should not be detected.
		* If any part of the `physicsRectangle` overlaps with some part of the `physicsRectangle2` after calculating using their `x`, `y`, `width`, `height` values, a collision should be detected.
		
* `PeggleGameEngine.swift`
	* `init` method
		* When passed with `(pegBoardModel: PegBoardModel, gameBoardView: UICollectionView)`, it should initialize the properties `pegBoardModel` and `gameBoardView` to the respective values. Its other properties `gameRenderer`, `physicsObjects`, `canFireCannon` and `pegsHitPerCannonBall` should also be initialized, with `gameRenderer` initialized with a new `PeggleGameRenderer` object, `physicsObjects` initialized with an empty `PhysicsObject` array, `canFireCannon` initialized with `true` and `pegsHitPerCannonBall` initialized with an empty `Peg` array.
		* It should not be passed with any other properties.
	* `addPhysicsObject(physicsObject: PhysicsObject)` method
		* When this method is called, the `physicsObjects` array should now have an additional element `physicsObject`
	* `addPhysicsObject(physicsObject: PhysicsObject, image: UIImageView)` method
		* When this method is called, the `physicsObjects` array should now have an additional element `physicsObject` and the `gameRenderer.addImage()` method should be called.
	* `removePhysicsObject(physicsObject: PhysicsObject)` method
		* When this method is called, the `physicsObject` element should now be removed from the `physicsObjects` array and the `gameRenderer.removeImage()` method should be called.
	* `startGame()` method
		* When the method is called, the `physicsObjects` array should now have the `Peg` objects that are obtained from `pegBoardModel` and the 4 `Wall` objects (topWall, leftWall, rightWall and bottomWall). The `Timer` object should be started with `timeInterval` value equal to `NumberConstants.gameInterval`.
	* `endGame()` method
		* When this method is called, the `Timer` object should be invalidated.
	* `fireCannon(cannonAngle: CGFloat)` method
		* If `cannonAngle` value is not between `-Double.pi / 2` and `Double.pi / 2`, the method should return without doing anything.
		* If `canFireCannon` value is `false`, the method should return without doing anything.
		* If both of the above values are valid and the method proceeds, the `physicsObjects` array should now have an additional `CannonBall` object, with its `velocity` value calculated based on `NumberConstants.cannonBallStartingVelocity` and `cannonAngle`. `canFireCannon` value should now also be changed to `false`.
	* `cannonBallHitsPeg(peg: Peg)` method
		* When this method is called, `pegsHitPerCannonBall` array should now have an additional element `peg`, if it does not already contain it. The `gameRenderer.changeImage()` method should be called.
	* `cannonBallHitsBottomWall(cannonBall: CannonBall)` method
		* When this method is called, the `cannonBall` should now be removed from the `physicsObjects` array. `pegsHitPerCannonBall` array should now be emptied and all the `Peg` objects that were in it should also be removed from the `physicsObjects` array.`

### Integration Tests
* Test selecting a peg on the palette
	* When app is first opened to the Level Designer part, the blue peg should be highlighted to indicate selection by default and the orange and delete pegs should be dimmed to indicate not selected.
	* When I press the orange peg, the orange peg should be highlighted to indicate selection and the blue and delete pegs should be dimmed to indicate not selected.
	* When I press the delete peg, the delete peg should be highlighted to indicate selection and the blue and orange pegs should be dimmed to indicate not selected.
	* When I press the blue peg, the blue peg should be highlighted to indicate selection and the orange and delete pegs should be dimmed to indicate not selected.
	* When I press the blue peg again, the blue peg should remain highlighted to indicate selection and the orange and delete pegs should remain dimmed to indicate not selected.
	
* Test adding a peg on the board by tapping
	* Blue peg is selected on the palette
		* Tapping a location on an empty board, and the tap location is far away from all 4 borders should create a blue peg on it.
		* Tapping a location on a board with pegs, and the tap location is at least a diameter distance away from all the current pegs and at least a radius distance away from all 4 borders should create a blue peg on it.
		* Tapping a location on a board with pegs, and the tap location is at least a diameter distance away from all the current pegs but less than a radius distance away from any of the 4 borders should not create a blue peg on it.
		* Tapping a location on a board with pegs, and the tap location is at least a radius distance away from all 4 borders but within a diameter distance away from any of the current pegs should not create a blue peg on it.
		
	* Orange peg is selected on the palette
		* Tapping a location on an empty board, and the tap location is far away from all 4 borders should create a orange peg on it.
		* Tapping a location on a board with pegs, and the tap location is at least a diameter distance away from all the current pegs and at least a radius distance away from all 4 borders should create a orange peg on it.
		* Tapping a location on a board with pegs, and the tap location is at least a diameter distance away from all the current pegs but less than a radius distance away from any of the 4 borders should not create a orange peg on it.
		* Tapping a location on a board with pegs, and the tap location is at least a radius distance away from all 4 borders but within a diameter distance away from any of the current pegs should not create a orange peg on it.

* Test removing a peg on the board by tapping
	* Delete peg is selected on the palette
		* Tapping a location on an empty board should not have any effect.
		* Tapping a location on a board with pegs, and the tap location is within the circumference of one of the current pegs should remove the peg from the board.
		* Tapping a location on a board with pegs, and the tap location is not within the circumference of any of the current pegs should not remove any peg from the board.
		
* Test removing a peg on the board by long press
	* Any peg is selected on the palette
		* Long pressing a location on an empty board should not have any effect.
		* Long pressing a location on a board with pegs, and the long press location is within the circumference of one of the current pegs should remove the peg from the board.
		* Long pressing a location on a board with pegs, and the long press location is not within the circumference of any of the current pegs should not remove any peg from the board.
		
* Test moving a peg around the board by dragging
	* Any peg is selected on the palette
		* Dragging on an empty board should not have any effect.
		* On a board with pegs, start dragging from a location that is not within the circumference of any of the current pegs should not move any pegs.
		* On a board with pegs, start dragging from a location that is within the circumference of one of the current pegs and across locations that are at least a diameter distance away from all the other current pegs and at least a radius distance away from all 4 borders, should move the peg in the dragging direction.
		* On a board with pegs, start dragging from a location that is within the circumference of one of the current pegs and across locations that are at least a diameter distance away from all the other current pegs and at least a radius distance away from all 4 borders, but reaching a location that is within a diameter distance away from one of the other current pegs. This should move the peg in the dragging direction to the final location that is more than a diameter distance away from all of the other pegs and make it stop there.
		* On a board with pegs, start dragging from a location that is within the circumference of one of the current pegs and across locations that are at least a diameter distance away from all the other current pegs and at least a radius distance away from all 4 borders, but reaching a location that is within a radius distance away from one of the borders. This should move the peg in the dragging direction to the final location that is more than a radius distance away from all of the 4 borders and make it stop there.
		
* Test pressing the 'Reset' button
	* Pressing when the board is empty should not show any effect.
	* Pressing when there are pegs on the board should clear the board of all pegs.
		
* Test pressing the 'Save' button
	* After pressing, it should bring me to another screen that says 'Save Level' on top, and a text field for me to specify the level name and 2 buttons that are 'Cancel' and 'Save'.
	* On the 'Save Level' screen, if I leave the text field empty and press 'Save', it should not save and show me an alert that informs me that the text field cannot be blank.
	* On the 'Save Level' screen, if I type something on the text field that includes non-alphanumerical characters or leave spaces between characters, and press 'Save', it should not save and show me an alert that informs me that the text field cannot have non-alphanumerical characters and cannot leave spaces between characters.
	* On the 'Save Level' screen, if I type something on the text field that has all alphanumerical characters with no space between characters and press 'Save', and the level name has not been saved before, it should successfully save the level and alert me.
	* On the 'Save Level' screen, if I type something on the text field that has all alphanumerical characters with no space between characters and press 'Save', but the level name has already been saved before, it should pop up an alert asking me to confirm whether to override the saved level.
	* From the previous example, if I press 'OK' to override, it will tell me that the level has been successfully saved and alert me. Else if I press 'Cancel', it will not save the level.
	* On the 'Save Level' screen, if I press 'Cancel', it will bring me back to the previous Level Designer screen.
	
* Test pressing the 'Load' button
	* After pressing, it should bring me to another screen that says 'Select Level', with a table that shows all the saved levels and 3 buttons that are 'Cancel', 'Edit' and 'Play'.
	* On the 'Select Level' screen, if I click on the level name of a saved level and click 'Edit', it will load the saved level and bring me back to the Level Designer screen with the saved level.
	* On the 'Select Level' screen, if I click on 'Cancel', it will bring me back to the previous Level Designer screen.
	* On the 'Select Level' screen, if I click on 'Play', nothing will happen as the play feature has not been implemented yet.

## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

Your answer here
