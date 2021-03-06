1.3.7
=====
* PMTweenCATempo now uses NSRunLoopCommonModes

1.3.6
=====
* Fixed bug with Bounce easingIn type
* PMTweenPhysicsUnit now uses a higher-resolution timestamp

1.3.5
=====
* Fixed bug in the Back easingOut easing equation
* Moved the call of PMTweenUnit's updateBlock to after the property update

1.3.4
=====
* PMTween header import now properly includes the constants from PMTweening
* Improved dispatch timer dealloc checks in PMTweenPhysicsUnit

1.3.3
=====
* PMTweenPhysicsSystem (used internally by PMTweenPhysicsUnit) now uses a fixed timestep, which though rudimentary, helps smooth out tween value jittering
* Fixed bug with physics timer not properly removed

1.3.2
=====
* PMTweenPhysicsUnit now updates its physics system independently of property updates, at a frequency of 120 fps by default (to provide double the resolution of a normal 60fps app). This can be changed by PMTweenPhysicsUnit's new property physicsTimerInterval.
* PMTweenPhysicsSystem now handles friction values with less accumulated error.
* PMTweenPhysicsUnit's velocity is now expressed in units per second. Prior to this the velocity acted as units per frame, which obviously caused inconsistent simulations.
* Minor updates to the Examples project.

1.3.1
=====
* Updated project architecture to use single header import
* Fixed string equality check in PMTweenSupport when comparing keyPaths
* Miscellaneous project cleanup

1.3.0
=====
* Added support for CGVector structs as property tweening targets.
* Added support for tvOS as a target.
* Updated init methods to use instancetype.
* Changed minimum iOS target to 7.0.

1.2.2
=====
* Fixed additional warnings
* Modified one test
* updated Podspec

1.2.1
=====
* Updated Podspec

1.2.0
=====
* Implemented additive animation in PMTweenUnit!
* Updated PMTweenObjectUpdater to provide additive updating support.
* Updated tests.
* Updated Examples project to include additive demos.

1.1.2
=====
* Fixed multiple tweens targeting same object property incorrectly overriding initial value of first tween.

1.1.1
=====
* Fixed PMTweenUnit and PMTweenPhysicsUnit failing to tween object properties specified by a single-element keyPath.
* Fixed NSNumber object properties with a nil value not tweening. Such properties are now initialized with the specified starting value during the init method.
* Changed all init methods to return instancetype instead of id.
* More tests.

1.1.0
=====
* Added PMTweenPhysicsUnit and PMTweenPhysicsSystem classes to provide dynamic, physics-based tweening! PMTweenPhysicsUnit adopts PMTweening, so you get all the standard PMTween functionality – use it in groups and sequences, add reversing, pause it, etc. See the documentation and examples project for more info.
* Fixed bug where PMTweening classes set to reversing wouldn't reverse properly inside a PMTweenGroup that wasn't itself reversing.
currentValue property wasn't being set to startingValue in PMTweenUnit on setup.
* New tests.
* Updated examples project.

1.0.1
=====
* PMTweenBeat: Fixed this class not having a default tempo or setting child tween tempos to nil.
* PMTweenGroup: Base init method was not calling setTempo.

1.0.0
=====
* First release
