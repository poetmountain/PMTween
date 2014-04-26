PMTween is an elegant and flexible tweening library for iOS. It offers sensible default functionality that abstracts most of the hard work away, allowing you to focus on your animations and other tween tasks. But PMTween also makes it easy to dive in and modify for your own needs, whether that be custom tweening classes, supporting custom object types, or new easing equations.

## Features

* Powerful – PMTween makes both simple and complex tweening tasks easy and elegant.
* Flexible – Tweens can be grouped, sequenced, and nested in most any configuration you might need.
* Extensible - PMTween was built to easily support custom value types, easing equations, and functionality.
* PMTween supports notifications and blocks for many kinds of status events.


## Overview

PMTweenUnit is the base-level tweening class, PMTweenGroup groups multiple tweens together, and PMTweenSequence plays tweens in sequence. Because all of these classes adopt the PMTweening protocol, you can add any of these classes into a PMTweenGroup or PMTweenSequence. They can be nested as many levels deep as you'd like, and PMTweenGroup and PMTweenSequence respect the tweening properties of their children. This also makes it easy to add your own custom tweening classes. Just conform to the PMTweening protocol and your custom class will work with any of the default PMTween tweening classes. However, PMTweenUnit offers such modularity that in most cases you can just replace the parts you need with your own implementation.


## Getting Started

### Installation with CocoaPods

#### Podfile
``` ruby
pod "PMTween", "~> 1.0.0"
```

### Examples

#### Basic tween

Here's the most basic type of tween, which just tweens an arbitrary data structure directly. PMTweenUnit is the workhorse tweening class in PMTween; it handles all the actual property updating. Note that nil is passed in for the easingBlock, which means it will use the default PMTweenEasingLinear easing type.

``` objective-c
PMTweenUnit *tween = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:1.0 options:PMTweenOptionNone easingBlock:nil];
[tween startTween];
```

Here's another basic example. Notice that this time we've passed an options bitmask into the options parameter which will make it tween in reverse back to the starting value (after hitting the endingValue), and also repeat its tween for multiple cycles. In this case, it would repeat the total tween operation (forwards and back).

We've also defined a completeBlock, which will be called when the tween has completed all repeat cycles. Notice that the block's parameter specifies "NSObject<PMTweening>", and not PMTweenUnit. It denotes that this could be any object that conforms to the PMTweening protocol, and PMTweenUnit (like all PMTween tweening classes) does adopt it. If you want to access specific properties from your tweening class that are not specified by the PMTweening protocol, you will need to cast the 'tween' object to your specific class type first.

``` objective-c
PMTweenUnit *tween = [[PMTweenUnit alloc] initWithProperty:@(0) startingValue:0 endingValue:100 duration:1.0 options:PMTweenOptionRepeat|PMTweenOptionReverse easingBlock:nil];
tween.completeBlock = ^void(NSObject<PMTweening> *tween) {
    NSLog(@"tween complete!");
};
tween.numberOfRepeats = 2;
[tween startTween];
```

#### Tweening an object's property

A more common need is to tween an object property, such as the x position of a UIView. Let's see how that looks. Notice that this method requires a key path. This is the object hierarchy from the object down to the property you want to tween. Even though the 'x' value of a CGPoint can't be set directly on a CGRect, PMTween is smart enough to handle this updating for you.

Notice also that we've defined an easingBlock this time. You can also assign a different easing block to use when reversing a tween by setting a PMTweenUnit's reverseEasingBlock property. PMTween includes all the standard Robert Penner easing types, but you can also easily make your own easing classes and pass them in. Maybe you want to modify the easing by applying a Perlin noise filter or shifting the value with gyroscope data. Who knows? I don't. That's why PMTween makes it easy for you to do your own thing.

``` objective-c
PMTweenEasingBlock easing = [PMTweenEasingCubic easingInOut];
PMTweenUnit *tween = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.origin.x" startingValue:self.tweenView.frame.origin.x endingValue:200 duration:1.0 options:PMTweenOptionNone easingBlock:easing];
[tween startTween];
```

#### Using a PMTweenGroup

PMTweenGroup manages multiple class instances. It's handy for controlling and synchronizing multiple tween objects. You can of course have groups within other groups.

Notice in this example that a tempo object is being set on the PMTweenGroup. What is that? Well it provides the tempo for the tween, or in other words the rate at which the tween should update its easing calculations. This is only an example and not necessary to set – all PMTween tweening classes create their own tempo objects internally by default. But if you do want to use your own custom tempo, keep in mind that a group collection will set all child tween object tempos to nil to avoid having hundreds of CADisplayLink timers running. So if you've got a lot of tween objects, put them in a group (or assign them to a PMTweenBeat!), and set your custom tempo on the top-most tween collection object.

``` objective-c
PMTweenEasingBlock easing = [PMTweenEasingCubic easingInOut];
PMTweenUnit *tween = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.size.width" startingValue:self.tweenView.frame.size.width endingValue:200 duration:1.0 options:PMTweenOptionNone easingBlock:easing];
PMTweenUnit *tween2 = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.size.height" startingValue:self.tweenView.frame.size.height endingValue:300 duration:2.0 options:PMTweenOptionNone easingBlock:easing];
    
PMTweenGroup *group = [[PMTweenGroup alloc] initWithTweens:@[tween, tween2] options:PMTweenOptionReverse];
[group setTempo:[PMTweenCATempo tempo]];
[group startTween];
```

#### Using a PMTweenSequence

PMTweenSequence plays a collection of tweens in order, chaining tweens together extremely easily. This is a really powerful class, as you can play in sequence any assortment of PMTweenUnits, PMTweenGroups, or other PMTweenSequence classes, as well as your own custom tween classes. It's tweens all the way down. Note that we pass in an array of sequence steps – it will play the sequence in that order.

When a PMTweenSequence is set to reverse, by default it will play as discrete elements when reversing (in other words, each child tween would just play forwards, but in reverse order). But by setting the sequence's reversingMode to PMTweenSequenceReversingContiguous you can set the whole sequence to play in reverse seamlessly, as if it was one contiguous tween. This is really great for complex animations.

``` objective-c
PMTweenEasingBlock easing = [PMTweenEasingCubic easingInOut];
PMTweenUnit *tween = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.origin.x" startingValue:self.tweenView.frame.origin.x endingValue:200 duration:1.0 options:PMTweenOptionNone easingBlock:easing];
PMTweenUnit *tween2 = [[PMTweenUnit alloc] initWithObject:self.tweenView  propertyKeyPath:@"frame.size.height" startingValue:self.tweenView.frame.size.height endingValue:300 duration:2.0 options:PMTweenOptionNone easingBlock:easing];
    
PMTweenSequence *sequence = [[PMTweenSequence alloc] initWithSequenceSteps:@[tween1, tween2] options:PMTweenOptionReverse];
[sequence startTween];
```

See the included [demo project](https://github.com/poetmountain/PMTween/tree/master/Examples) for additional examples of PMTween usage, as well as perusing the [documentation](https://poetmountain.github.io/PMTween/).


### Class reference

<table>
  <tr><th colspan="2" style="text-align:center;">Tween Classes</th></tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMValidationUnit.html">PMTweenUnit</a></td>
    <td>PMTweenUnit handles a single tween operation on an NSValue, interpolating between specified starting and ending values.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenGroup.html">PMTweenGroup</a></td>
    <td>PMTweenGroup handles the tweening of one or more objects which conform to the PMTweening protocol, either being instances of PMTweenUnit or other custom classes. The PMTweenGroup class is a good solution when you want to easily synchronize the operation of many tweens.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenSequence.html">PMTweenSequence</a></td>
    <td>PMTweenSequence allows objects which conform to the PMTweening protocol to be chained together in a sequential series of tween steps.</td>
  </tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenObjectUpdater.html">PMTweenObjectUpdater</a></td>
    <td>PMTweenObjectUpdater is used internally by PMTweenUnit to update elements of data structures and objects while tweening. You can implement your own handling of object updating by setting a PMTweenUnit's structValueUpdater property with a class conforming to the PMTweenObjectUpdating protocol.</td>
  </tr>
  
  <tr><th colspan="2" style="text-align:center;">Tempo Classes</th></tr>
  <tr>
    <td><a href="https://poetmountain.github.io/PMTween/Classes/PMTweenTempo.html">PMTweenTempo</a></td>
    <td>PMTweenTempo is an abstract class that provides a basic structure for sending a tempo by which to update tween interpolations.</td>
  </tr>
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

PMTween is tested using [Specta](https://github.com/specta/specta)/[Expecta](https://github.com/specta/expecta/). You can install the test dependencies using CocoaPods by running the terminal command 'pod install' from within the Tests directory.
		
## Credits

PMTween was created by [Brett Walker](https://twitter.com/petsound) of [Poet & Mountain](https://poetmountain.com).

## Compatibility

* Requires iOS 6.0 or later
* PMTween uses ARC

## License

PMValidation is licensed under the MIT License. I'd love to know if you use PMTween in your app!