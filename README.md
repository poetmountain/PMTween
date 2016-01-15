PMTween is an elegant and flexible tweening library for Objective-C, currently supporting the iOS and tvOS platforms. It offers sensible default functionality that abstracts most of the hard work away, allowing you to focus on your animations and other tween tasks. But PMTween also makes it easy to dive in and modify for your own needs, whether that be custom tweening classes, supporting custom object types, or new easing equations.


## Overview

* PMTween makes both simple and complex tweening tasks easy to create.
* Tweens can be grouped, sequenced, and nested in most any configuration you might need.
* Includes both static and physics-based tween classes.
* PMTween was built to easily support custom value types, easing equations, and functionality.
* Provides notifications and blocks for many kinds of status events.

All of the base tweening classes in PMTween adopt the PMTweening protocol, and you can add any of these classes to a PMTweenGroup or PMTweenSequence instance. They can be nested as many levels deep as you'd like, and PMTweenGroup and PMTweenSequence respect the tweening properties of their children. If you want to use your own custom tween classes, simply adopt the protocol. However, PMTweenUnit offers such modularity that in most cases you can just replace the parts you need with your own implementation.

**In other words, this code:**

``` objc
PMTweenEasingBlock easing = [PMTweenEasingCubic easingInOut];
PMTweenEasingBlock easing2 = [PMTweenEasingCircular easingInOut];

PMTweenUnit *tween1 = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.origin.x" startingValue:self.tweenView.frame.origin.x endingValue:110 duration:1.5 options:PMTweenOptionNone easingBlock:easing];
PMTweenUnit *tween2 = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"backgroundColor.blue" startingValue:0.30 endingValue:1.0 duration:1.2 options:PMTweenOptionNone easingBlock:easing];
PMTweenUnit *tween3 = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.size.width" startingValue:self.tweenView.frame.size.width endingValue:120 duration:0.9 options:PMTweenOptionNone easingBlock:easing2];
PMTweenUnit *tween4 = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.origin.y" startingValue:self.tweenView.frame.origin.y endingValue:100 duration:1.0 options:PMTweenOptionNone easingBlock:easing];

PMTweenGroup *group = [[PMTweenGroup alloc] initWithTweens:@[tween1, tween2] options:PMTweenOptionNone];

PMTweenSequence *sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[group, tween3, tween4] options:PMTweenOptionReverse|PMTweenOptionRepeat];
sequence.reversingMode = PMTweenSequenceReversingContiguous;
[sequence startTween];
```

**produces this animation:**

![sequence](http://poetmountain.github.io/PMTween/screenshots/sequence.gif)


### New in 1.2.0

New in the 1.2.0 release is support for additive animations in PMTweenUnit. Additive animation allows multiple tweens to produce a compound effect, instead of overwriting each other as they update the same property. Additive animation is now the default behavior for tweening animations in iOS 8, and is great for making user interface animations fluid and responsive. Of course with PMTweenUnit you are not limited to tweening UIView properties, so additive tweening may be applied to any compatible property. Simply set `additive` to YES on any PMTweenUnit instances whose tweening updates you wish to composite. Please see the documentation and updated [Examples project](https://github.com/poetmountain/PMTween/tree/master/Examples) for more information and things you should keep in mind when using this mode. Special thanks to [Andy Matuschak](https://twitter.com/andy_matuschak) and [Kevin Doughty](https://twitter.com/DoughtyKevin) for making the concept clearer.

![additive](http://poetmountain.github.io/PMTween/screenshots/additive.gif)


### New in 1.1.0

New in the 1.1.0 release is PMTweenPhysicsUnit, which provides dynamic, physics-based tweening. (Thanks to [Pop](https://github.com/facebook/pop) lib for the inspiration!) Since it adopts the PMTweening protocol, you can combine it with the other PMTween classes as you see fit.

For more information, see the included [examples](https://github.com/poetmountain/PMTween/tree/master/Examples) of PMTween usage, and peruse the [documentation](https://poetmountain.github.io/PMTween/).


## Getting Started

### Installation

If you use CocoaPods:

##### Podfile
```ruby
pod "PMTween", "~> 1.2.0"
```

Or add the Classes directory to your project.


### Examples

#### Basic tween

Here's the most basic type of tween, which just tweens an arbitrary data structure directly. PMTweenUnit is the workhorse tweening class in PMTween; it handles all the actual property updating. Note that nil is passed in for the easingBlock, which means it will use the default PMTweenEasingLinear easing type.

```objc
PMTweenUnit *tween = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:1.0 options:PMTweenOptionNone easingBlock:nil];
[tween startTween];
```

Here's another basic example. Notice that this time we've passed an options bitmask into the options parameter which will make it tween in reverse back to the starting value (after hitting the endingValue), and also repeat its tween for multiple cycles. In this case, it would repeat the total tween operation (forwards and back).

We've also defined a completeBlock, which will be called when the tween has completed all repeat cycles. Notice that the block's parameter specifies `NSObject<PMTweening>`, and not PMTweenUnit. It denotes that this could be any object that conforms to the PMTweening protocol. If you want to access specific properties from your tweening class that are not specified by the PMTweening protocol, you will need to cast the 'tween' object to your specific class type first.

```objc
PMTweenUnit *tween = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:1.0 options:PMTweenOptionRepeat|PMTweenOptionReverse easingBlock:nil];
tween.completeBlock = ^void(NSObject<PMTweening> *tween) {
    NSLog(@"tween complete!");
};
tween.numberOfRepeats = 2;
[tween startTween];
```

#### Tweening an object's property

A more common need is to tween an object property, such as the x position of a UIView. Check the example below. Notice that this method requires a key path. This is the object hierarchy from the object down to the property you want to tween. Even though the 'x' value can't be set directly on a frame's origin, PMTween is smart enough to handle this updating for you. PMTween handles most common UIKit properties; see the docs or the code for exactly what it supports, and let me know what it's missing.

Notice also that we've defined an easingBlock this time. You can also assign a different easing block to use when reversing a tween by setting a PMTweenUnit's reverseEasingBlock property. PMTween includes all the standard Robert Penner easing types, but you can also easily use your own easing classes. Maybe you want to modify the easing by applying a Perlin noise filter or shifting the value with gyroscope data. Who knows? I don't. That's why PMTween makes it easy for you to do your own thing.

```objc
PMTweenEasingBlock easing = [PMTweenEasingCubic easingInOut];
PMTweenUnit *tween = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.origin.x" startingValue:self.tweenView.frame.origin.x endingValue:200 duration:1.0 options:PMTweenOptionNone easingBlock:easing];
[tween startTween];
```

#### Using a PMTweenGroup

PMTweenGroup manages multiple class instances. It's handy for controlling and synchronizing multiple tween objects. You can of course have groups within other groups.

Notice in this example that a tempo object is being set on the PMTweenGroup. It provides a tempo, or in other words a rate at which the tween should update its easing calculations. This is not necessary to set unless you want to use your own custom tempo object – all PMTween tweening classes by default create their own tempo objects internally.

```objc
PMTweenEasingBlock easing = [PMTweenEasingCubic easingInOut];
PMTweenUnit *tween = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.size.width" startingValue:self.tweenView.frame.size.width endingValue:200 duration:1.0 options:PMTweenOptionNone easingBlock:easing];
PMTweenUnit *tween2 = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.size.height" startingValue:self.tweenView.frame.size.height endingValue:300 duration:2.0 options:PMTweenOptionNone easingBlock:easing];
    
PMTweenGroup *group = [[PMTweenGroup alloc] initWithTweens:@[tween, tween2] options:PMTweenOptionReverse];
[group setTempo:[PMTweenCATempo tempo]];
[group startTween];
```

#### Using a PMTweenSequence

PMTweenSequence plays a collection of tweens in order. Chaining tweens together is extremely easy. This is a powerful class, as you can play in sequence any assortment of PMTweenUnits, PMTweenGroups, or other PMTweenSequence classes, as well as your own custom tween classes. It's tweens all the way down. Note that we pass in an array of sequence steps – it will play the sequence in that order.

When a PMTweenSequence is set to reverse, by default it will play as discrete elements when reversing (in other words, each child tween would just play forwards, but in reverse order). But by setting the sequence's reversingMode to PMTweenSequenceReversingContiguous you can set the whole sequence to play in reverse seamlessly, as if it was one contiguous tween. This is really great for complex animations.

```objc
PMTweenEasingBlock easing = [PMTweenEasingCubic easingInOut];
PMTweenUnit *tween = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.origin.x" startingValue:self.tweenView.frame.origin.x endingValue:200 duration:1.0 options:PMTweenOptionNone easingBlock:easing];
PMTweenUnit *tween2 = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.size.height" startingValue:self.tweenView.frame.size.height endingValue:300 duration:2.0 options:PMTweenOptionNone easingBlock:easing];
    
PMTweenSequence *sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[tween1, tween2] options:PMTweenOptionReverse];
[sequence startTween];
```


## Class reference

<table>
  <tr><th colspan="2" style="text-align:center;">Tween Classes</th></tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenUnit.html">PMTweenUnit</a></td>
    <td>PMTweenUnit handles a single tween operation on an NSValue, interpolating between specified starting and ending values.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenPhysicsUnit.html">PMTweenPhysicsUnit</a></td>
    <td>PMTweenPhysicsUnit handles a single physics-based tween operation on an NSValue, using a physics system to update a value with decaying velocity.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenGroup.html">PMTweenGroup</a></td>
    <td>PMTweenGroup handles the tweening of one or more objects which conform to the PMTweening protocol, either being instances of PMTweenUnit or other custom classes. The PMTweenGroup class is a good solution when you want to easily synchronize the operation of many tweens.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenSequence.html">PMTweenSequence</a></td>
    <td>PMTweenSequence allows objects which conform to the PMTweening protocol to be chained together in a sequential series of tween steps.</td>
  </tr>
  
  <tr><th colspan="2" style="text-align:center;">Tempo Classes</th></tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenCATempo.html">PMTweenCATempo</a></td>
    <td>PMTweenCATempo is a concrete subclass of PMTweenTempo, and uses a CADisplayLink object to send out tempo updates that are synchronized with the refresh rate of the display.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenBeat.html">PMTweenBeat</a></td>
    <td>PMTweenBeat broadcasts updates from a PMTweenTempo object to multiple objects which adopt the PMTweening protocol. This allows you to use a single tempo object for all tween objects, avoiding a performance impact when tweening many objects.</td>
  </tr>
	
  <tr><th colspan="2" style="text-align:center;">Easing Types</th></tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenEasingLinear.html">PMTweenEasingLinear</a></td>
    <td>Provides a linear easing equation.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenEasingQuadratic.html">PMTweenEasingQuadratic</a></td>
    <td>Provides quadratic easing equations.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenEasingQuartic.html">PMTweenEasingQuartic</a></td>
    <td>Provides quartic easing equations.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenEasingQuintic.html">PMTweenEasingQuintic</a></td>
    <td>Provides quintic easing equations.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenEasingCubic.html">PMTweenEasingCubic</a></td>
    <td>Provides cubic easing equations.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenEasingSine.html">PMTweenEasingSine</a></td>
    <td>Provides easing equations based on sine.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenEasingCircular.html">PMTweenEasingCircular</a></td>
    <td>Provides circular easing equations.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenEasingElastic.html">PMTweenEasingElastic</a></td>
    <td>Provides easing equations that behave in an elastic fashion.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenEasingExpo.html">PMTweenEasingExpo</a></td>
    <td>Provides exponential easing equations.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenEasingBack.html">PMTweenEasingBack</a></td>
    <td>Provides back easing equations.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenEasingBounce.html">PMTweenEasingBounce</a></td>
    <td>Provides easing equations that have successively smaller value peaks, like a bouncing ball.</td>
  </tr>
  <tr>
</table>


## Tests

PMTween is tested using [Specta](https://github.com/specta/specta)/[Expecta](https://github.com/specta/expecta/). You can install the test dependencies using CocoaPods by running 'pod install' from within the Tests directory.
		
## Credits

PMTween was created by [Brett Walker](https://twitter.com/petsound) of [Poet & Mountain](http://poetmountain.com).

## Compatibility

* Requires iOS 7.0 or later, tvOS 9.0 or later
* PMTween uses ARC

## License

PMTween is licensed under the MIT License. I'd love to know if you use PMTween in your app!