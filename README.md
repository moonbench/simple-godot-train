# 2D Godot Train
A simple implementation of a 2D train mechanic for use in Godot games.

![Screenshot](https://raw.githubusercontent.com/moonbench/simple-godot-train/master/Demo/Resources/Screenshot.png)

This provides train tracks and switches (built using Path2D nodes), and train engines and vehicles (using PathFollow2D nodes.)

There are a number of elements you can change to make the trains behave as you want. Specifically:
* Customizable wheel-separation and vehicle-follow distances
* Friction forces (kinetic, air, & rolling)
* Environment conditions (gravity strength, air density)
* Vehicle mass

This also includes a few demo train track sample scenes and a chase camera.

## Running the demo project
Open the game in Godot and press Play.

## Using this in your own projects
The code responsible for the trains and tracks exists within the `/Scenes` and `/Scripts` folders.

Examples of how the train and track code can be used exist within the `/Demo` folder.
