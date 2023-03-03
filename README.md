# 2D Train Demo
A demo train/railroad implementation that can be used in games built using Godot



![Screenshot](https://raw.githubusercontent.com/moonbench/simple-godot-train/master/Demo/Resources/Screenshot.png)

## Running the demo
* Open the project in Godot (tested in Godot 3.5)
* Press Play

## Mechanism Concept
### Tracks
The tracks ([Scenes/Track.tscn](Scenes/Track.tscn)) extend the Path2D node and can be drawn in the editor using the control points.

Visually, the rails of the track are applied as a texture on a Line2D node that follows the same points as the track. The crossties along the length of the track are implemented with a MeshInstance2D node and code in the track's script that places them.

The tracks have TrackJunction ([Scenes/TrackJunction.tscn](Scenes/TrackJunction.tscn)) instances at their head and tail ends. These junctions are small Area2D nodes that detect the overlap with other junctions. These allow track pieces to automatically connect to each other.

Tracks are marked as `tool` in their scripts, so they can render the rail and crosstie sprites along the path in the editor. However, this only happens once when the scene is loaded in the editor, so to see any changes you have to close and re-open the scene. (I'd like to fix this but am not sure how to have the path emit any sort of signal when it is changed.)

### Track Switches
Switches ([Scenes/TrackSwitch.tscn](Scenes/TrackSwitch.tscn)) are a wrapper around two tracks, with the logic to change which of the two tracks has a wheel added to it when the switch recieves an `enter_from_head` signal.

### Train Vehicles
The vehicles ([Scenes/TrainVehicle.tscn](Scenes/TrainVehicle.tscn)) sit on top of two wheels ([Scenes/TrainWheel.tscn](Scenes/TrainWheel.tscn)) which extend PathFollow2D nodes. These wheels follow the Path2D lines.

Each wheel can have an assigned "follower" wheel, and if a wheel has a follower then whenever the wheel moves its follower moves the same distance. Followers are used both to connect the back wheel of a train car to the front wheel, and to connect one train car to another one.

When a train wheel reaches the head or tail of a section of track it emits a `at_track_head` or `at_track_tail` signal. This signal is connected to whichever piece of track the wheel is currently "riding", and when this signal is recieved the track moves the wheel to the connected track.

### Train Engine
The train engine ([Scenes/TrainEngine.tscn](Scenes/TrainEngine.tscn)) is another train vehicle that applies power to its front wheel to move it. This front wheel pulls the engine's back wheel, which in turn follows the front wheel of the next following car, and so on.

## The Process
When the level scene loads, the track junctions use their `area_entered` signal to detect overlapping junctions with other tracks. Tracks are connected by linking the `wheel_at_head` or `wheel_at_tail` of one track segment to the correct `enter_from_head` or `enter_from_tail` of another track (and vice versa.) 

For switches the `wheel_at_tail` and `enter_from_tail` are replaced with `wheel_at_right` or `wheel_at_left` and `enter_from_right` or `enter_from_left`.

Trains are placed on the track by calling the `add_to_track()` method on a train and providing the track as an argument. Train vehicles can be configured to follow each other by calling the `set_follower_car()` on each lead vehicle.

When "force" is applied to the train engine (which is built on top of the TrainVehicle parent class) it pushes its front wheel and thus the rest of the train. When the front wheel moves, it calles the `move_as_follower()` method on the back wheel, which moves and then calls the `move_as_follower()` on the next car's front wheel, and this is repeated for all wheels along the train. This method is responsible for either moving the "follower" to the correct distance behind the leader on the track, or if they are on different tracks (because one is on the other side of a junction) it moves the follower by the same distance the leader moved.

## Parameters
There are a number of elements you can change to make the trains behave as you want. Specifically:
* Customizable wheel-separation and vehicle-follow distances
* Friction forces (kinetic, air, rolling)
* Braking strength
* Environment conditions (gravity strength, air density)
* Vehicle mass

## Using this in your own projects
The code in the [Demo](Demo) folder is just one example of how these pieces can be used in a game. The code responsible for the trains and tracks exists in the [Scenes](Scenes) and [Scripts](Scripts) folders in the main directory. You can take these scenes and scripts for the tracks/vehicles/wheels/etc from there to use them in your own projects, and can reference the demo scenes in [Demo](Demo) as templates for how to work with them.
