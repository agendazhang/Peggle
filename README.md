# CS3217 Problem Set 4

**Name:** Your name

**Matric No:** Your matric no

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
different levels that have blue and orange pegs on them. The objective is to clear 
all the orange pegs in each level by shooting cannon balls from a cannon at the top of the 
screen.

Here are some screenshots of the game.
* Main Menu: Select "Design Level" to design your own level.
![alt text](https://github.com/cs3217-1920/2020-ps4-agendazhang/blob/master/images/MainMenu.png)
* Level Designer: Place blue or orange pegs on the board to customize your own level, then select "Start" to start playing.
![alt text](https://github.com/cs3217-1920/2020-ps4-agendazhang/blob/master/images/LevelDesignerWithoutPegs.png)
![alt text](https://github.com/cs3217-1920/2020-ps4-agendazhang/blob/master/images/LevelDesignerWithPegs.png)
* Gameplay: Shoot the cannon ball from the cannon on top of the screen to clear all the orange pegs on the board. Rotate the cannon by swiping clockwise or anti-clockwise on the screen to change the angle to launch the ball. Tap the screen to shoot the cannon.
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
For the gameplay feature, it follows the Model-View-Controller (MVC) architechture pattern. 
Below shows the class diagram of this feature.
![alt text](https://github.com/cs3217-1920/2020-ps3-agendazhang/blob/master/images/Class%20Diagram.png)

The `Model` component is mainly in charge of the representation of the underlying data 
structures of the game state, as well as the domain logic for the game. The `Peg` class 
represents a single peg, the `CannonBall` class represents a single cannon ball that is fired from the cannon and the `Wall` represents the 4 sides of the game screen. Both the `Peg` and `CannonBall` classes conform to the `PhysicsCircle` protocol, which specifies that they need to have a `radius` attribute. The `Wall` class conforms to the `PhysicsRectangle` protocol which specifies that it needs to have `width` and `height` attributes. Both `PhysicsCircle` and `PhysicsRectangle` extends from the `PhysicsObject` protocol, which specifies some attributes, such as `x` and `y` coordinates of the object, `velocity` of the object and its `uuid`. The `PhysicsEngine` simulates physics interactions between the different `PhysicsObject`. It moves the objects based on their velocity, adds gravity to their velocity and checks for collisions between the different objects. It also contains a `PhysicsCollisionHandler` attribute, and `PhysicsCollisionHandler` is a protocol which specifies the methods that a collision handler class should conform to after the objects collide. The `PhysicsEngine` not only allows our `Peggle` game engine to be built on top of it, but also other games that have physics interactions. On top of the `PhysicsEngine` is our `PeggleGameEngine`, which is in charge of managing the overall game state of our `Peggle` game. It sets up the game board with pegs and walls before the game starts, allows the cannon to be fired and handles the game logic such as what happens when the cannon ball hits a peg and what happens when the cannon ball exits the stage. It also has a `PeggleGameCollisionHandler`, which conforms to `PhysicsCollisionHandler` and handles collisions between objects.

The `Controller` component will be the `PeggleGameRenderer`, which is in charge of the presentation logic of the qame state. It is informed by the `PeggleGameEngine` on the changes in the internal representation of the game state, and controls the display on the UI screen.

The `View` component is the UI components on the screen. For example, the 
`PegView` class represents the UI part of a single peg in the board. The `PegGlowView` class represents the UI part of a peg that has lit up after being hit by the cannon ball. The`CannonBallView` represents the UI part of the cannon ball.

The position of the physics objects in the game will change due to the `Timer` object in `PeggleGameEngine`. At each interval in the timer in the `gameInterval()` method, `PeggleGameEngine` will create a `PhysicsEngine` object that is initialized by the current physics objects in the game and the `PeggleGameCollisionHandler`. The `moveObjects()` method of `PhysicsEngine` is called, which moves the positions of objects based on their velocities. `PhysicsEngine` will then check for any collisions between its object after any of its object moves. If so, it will call the respective collision handler method from `PeggleGameCollisionHandler` (which conforms to `PhysicsCollisionHandler`) to handle the collision. After the positions of the physics objects are set in each interval after `PhysicsEngine` handled them, `PeggleGameEngine` will finally call the `moveImages()` method of `PeggleGameRenderer`, which moves the images of each object on the UI screen based on their new positions.

An example will be when the `CannonBall` object collides with one of the `Peg` object. At the previous interval of `Timer`, the cannon ball is very close to the peg but not yet collided. At the current interval of `Timer`, `PeggleGameEngine` will create a `PhysicsEngine` object that is initialized by the current physics objects in the game and the `PeggleGameCollisionHandler`. The `moveObjects()` method of `PhysicsEngine` is called, and moves the cannon ball towards the peg. The peg's position does not change since it cannot move and its velocity is zero. `PhysicsEngine` will then detect that the cannon ball has collided with the peg with its `checkCollisionForCircleWithCircle()` method. It will then call `handleCollisionForCircleWithCircle()` method of `PeggleGameCollisionHandler` class, which changes the velocity of the cannon ball based on the angle of collision and the cannon ball's original velocity. It will also alert the `PeggleGameEngine` that a collision between a cannon ball and peg has occurred through the `cannonBallHitsPeg()` method, which will call `changeImage()` method of `PeggleGameRenderer` to change the image of the peg to one that lights up. Finally, after the internal physics logic has been handled, `gameInterval()` of `PeggleGameEngine` will need to update the new position of the cannon ball on the UI screen after the collision. The `moveImages()` method of `PeggleGameRenderer` will be called to do so.

The performance constraints for the gameplay feature are as follows:
* Due to the effect of gravity added on the cannon ball and the cannon can only be fired towards the bottom half part of the game board, there are certain parts on the top left and top right hand side of the game board that the cannon ball cannot reach when the cannon ball is first fired from the cannon. Hence, the pegs that are placed there can only be cleared if the ball hits a peg below and bounces up.
* If you place a peg directly below the cannon and you fire the cannon ball straight down, it will hit the peg, bounce up and hit the top wall, bounce back down and hit the peg again, repeating this forever. This is because the pegs that are hit will only be removed once the cannon ball reaches the bottom and is removed from the game board. Hence, when the user designs the level, they should avoid such cases where the cannon ball will not be able to go down.
* Similar to the previous example, the cannon ball will not be able to go down if it is trapped within a cluster of pegs.

## Rules of the Game
Please write the rules of your game here. This section should include the
following sub-sections. You can keep the heading format here, and you can add
more headings to explain the rules of your game in a structured manner.
Alternatively, you can rewrite this section in your own style. You may also
write this section in a new file entirely, if you wish.

### Cannon Direction
Please explain how the player moves the cannon.

### Win and Lose Conditions
Please explain how the player wins/loses the game.

## Level Designer Additional Features

### Peg Rotation
Please explain how the player rotates the triangular pegs.

### Peg Resizing
Please explain how the player resizes the pegs.

## Bells and Whistles
Please write all of the additional features that you have implemented so that
your grader can award you credit.

## Tests
If you decide to write how you are going to do your tests instead of writing
actual tests, please write in this section. If you decide to write all of your
tests in code, please delete this section.

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
