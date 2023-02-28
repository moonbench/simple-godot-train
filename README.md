# 2D Train/Railroad Game Mechanic Demo
A demo implementation of 2D train tracks, switches, and vehicles for use games built with Godot (3.5)

![Screenshot](https://raw.githubusercontent.com/moonbench/simple-godot-train/master/Demo/Resources/Screenshot.png)

This provides train tracks and switches (built using Path2D nodes), and train engines and vehicles (using PathFollow2D nodes.)

There are a number of elements you can change to make the trains behave as you want. Specifically:
* Customizable wheel-separation and vehicle-follow distances
* Friction forces (kinetic, air, & rolling)
* Environment conditions (gravity strength, air density)
* Vehicle mass

This also includes a few demo train track sample scenes and a chase camera.

## Running the demo project
Open the project in the Godot (3.5) editor and press Play.

## Using this in your own projects
The code responsible for the trains and tracks exists in the `/Scenes` and `/Scripts` folders.

Example implementations showing how the train and track code can be used exist within the `/Demo` folder.
