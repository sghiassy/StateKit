# StateKit

[![CI Status](http://img.shields.io/travis/Shaheen Ghiassy/StateKit.svg?style=flat)](https://travis-ci.org/Shaheen Ghiassy/StateKit)
[![Version](https://img.shields.io/cocoapods/v/StateKit.svg?style=flat)](http://cocoadocs.org/docsets/StateKit)
[![License](https://img.shields.io/cocoapods/l/StateKit.svg?style=flat)](http://cocoadocs.org/docsets/StateKit)
[![Platform](https://img.shields.io/cocoapods/p/StateKit.svg?style=flat)](http://cocoadocs.org/docsets/StateKit)

<img title="State Kit Logo" src="http://cl.ly/image/1W471N2V3d3v/StateKit-Logo.png" width="800" />

StateKit is a framework to capture, document and manage application state in tree data structure to keep your application's flow control sane.

## Quick Example

```objective-c
NSDictionary *chart = @{@"root":@{
                                @"enterState":^(SKStateChart *sc) {
                                    [sc goToState:@"loading"];
                                },
                                @"apiRespondedSuccessfully":^(SKStateChart *sc) {
                                    [sc goToState:@"regularView"];
                                },
                                @"subStates":@{
                                        @"regularView":@{
                                                @"enterState":^(SKStateChart *sc) {
                                                    // setup the regular view
                                                }},
                                        @"loading":@{
                                                @"enterState":^(SKStateChart *sc) {
                                                    // fetch data from the api
                                                    // show the loading spinner
                                                },
                                                @"exitState":^(SKStateChart *sc) {
                                                    // remove loading spinner
                                                }}}}};

SKStateChart *stateChart = stateChart = [[SKStateChart alloc] initWithStateChart:chart];
```

The above StateChart would produce a tree structure like the following

<img title="Quick Example Tree Structure" src="http://lnk.ghiassy.com/1EcWQOW" width="400" />

The story of what happens in this particular state chart is as follows:

The state chart always start with `root` as the current state. As we enter the `root` state, this chart has an `enterState` block in the `root` state and is therefor run. In the `enterState` there is code directing the state chart to the `loading` state. As the state chart traverses into the `loading` state, the state chart runs the `loading` state's `enterState` block where we fetch data from the api and render the spinner to the view.

When the api responds successfully we send the appropriate message to the state chart `[stateChart sendMessage:@"apiRespondedSuccessfully"]`. The state chart would lookup the appropriate message handler and run the correlating block. In this example, the block directs the state chart to traverse to the `regularView` state.

As the state chart traverse from the `loading` state to the `regularView` state, we can cleanly take care of alloc/deallcing objects with a high-level of precision. As we exit the `loading` state we clean up the loading UI and as we enter the `regularView` state we setup the appropriarte UI.

## Documentation

- [Syntax](#syntax)
  - [Root State](#root-state)
  - [Messages](#a-states-messages)
  - [Sub States](#sub-states)
- [Messages](#messages)
  - [Message Bubbling](#message-bubbling)
    - [Message Bubbling Example](#an-example)
- [State Traversals](#state-traversals)
- [State Events](#state-events)

## Syntax

The syntax for a creating a state chart is as follows:

#### Root State

All state charts must have a root state - otherwise StateKit will throw an exception. Below is the minimum viable state chart.

```objective-c
NSDictionary *chart = @{@"root":@{}};
```

#### A State's Messages

Messages are defined as the top level of the state's correlated dictionary. To add the messages `apiRespondedSuccess` and `apiRespondedError` to the root state we would add the following

```objective-c
NSDictionary *chart = @{@"root":@{
                                @"apiRespondedSuccess":^(SKStateChart *sc) {
                                    // show the page
                                },
                                @"apiRespondedError":^(SKStateChart *sc) {
                                    // show the error page
                                }}};
```

When the `root` state receives either of the messages, the associated block will be run. 

Note that the reference to the state chart is passed into the function as `sc`. While you could potentially reference the state chart instance from a variable outside of the dictionary, it is advised to use the passed in reference.

#### Sub-states

Substates are defined in a dictionary under the keyword `subStates`. If we wanted to add a `loading` substate to the above the example we would get:

```objective-c
NSDictionary *chart = @{@"root":@{
                                @"apiRespondedSuccess":^(SKStateChart *sc) {
                                    // show the page
                                },
                                @"apiRespondedError":^(SKStateChart *sc) {
                                    // show the error page
                                },
                                @"subStates":@{
                                        @"loading":@{
                                                // put the loading's state messages and substates here
                                                }}}};
```

Substates key/value pair must be string/dictionary. Put a block as the key/value pair under the `subStates` dictionary will throw an exception.

## Messages

Events are at the heart of a state chart. After the state chart has been created, the outside world can start to send messages to the state chart keeping it abreast of what is going on. The state chart will intercept the event and run the appropriate message block per the current state..

```objective-c
[stateChart sendMessage:@"userPressedTheRedButton"]
```

### Message Bubbling

Messages are first sent to the current state to see if there is a receieved for the message. If the current state does not respond to the message, the state chart will begin to bubble up the tree to find any parent states that respond to the message. If the current state plus any of the current state's parent states do not respond to the message, the message will be quietly ignored.

<img title="Message Bubbling Theorertical Example" src="http://lnk.ghiassy.com/1JkhhK3" width="400" />

#### An Example

Here is an example of message bubbling and how it works in various situations. Assume the following state chart:

```objective-c
NSDictionary *chart = @{@"root":@{
                              @"subStates":@{
                                      @"a":@{
                                              @"subStates":@{
                                                      @"d":@{
                                                              @"userPressedButton":^(SKStateChart *sc) {
                                                                  NSLog(@"state d says hi");
                                                              },
                                                              @"subStates":@{
                                                                      @"j":@{}
                                                                      }
                                                              }
                                                      }
                                              },
                                      @"b":@{
                                              @"userPressedButton":^(SKStateChart *sc) {
                                                  NSLog(@"state b says hi");
                                              },
                                              @"subStates":@{
                                                      @"e":@{},
                                                      @"f":@{
                                                              @"subStates":@{
                                                                      @"g":@{
                                                                              @"userPressedButton":^(SKStateChart *sc) {
                                                                                  NSLog(@"state g says hi");
                                                                              },
                                                                              @"subStates":@{
                                                                                      @"h":@{},
                                                                                      @"i":@{}
                                                                                      }}}}}},
                                      @"c":@{
                                              @"subStates":@{
                                                      @"k":@{}
                                                      }}}}};
```

Which would translate itself into the following tree:

<img title="Message Bubbling Example" src="http://lnk.ghiassy.com/1BUEHF1" width="400" />

Sending the message `userPressedButton` to the start chart would mean different things depending on the current state that the state chart is in.

Here is a table showing the output of sending the message `userPressedButton` to the state chart given various current states

| Current State | Output          |
| ------------- | --------------- |
| root          | *nothing*       |
| A             | *nothing*       |
| B             | state b says hi |
| C             | *nothing*       |
| D             | state d says hi |
| E             | state b says hi |
| F             | state b says hi |
| G             | state g says hi |
| H             | state g says hi |
| I             | state g says hi |
| J             | state d says hi |
| K             | *nothing*       |

#### The fact that the same message can mean different actions depending on the state chart's data structure is very powerful.

## State Traversals

State Traversals are another important aspect of a state chart. When transitioning from one state to another state the state chart does not directly go from one to another. Instead the state chart traverses the tree to get from one state to another. This tree traversal, combined with [State Events](#state-events) makes for a really power combination for memory management and application flow-control.

The logic to transition from one state to another takes on the following steps

1. The state chart does a [breadth first search](http://en.wikipedia.org/wiki/Breadth-first_search) on the underlying [tree data structure](http://en.wikipedia.org/wiki/Tree_%28data_structure%29) to find the state to transition to.
2. The state chart then find the [lowest common anscestor](http://en.wikipedia.org/wiki/Lowest_common_ancestor) between the two states.
3. The state chart then traverses up the tree from the current state to the lowest common ancestor. As the state chart traverses up the tree it will run the `exitState` block of each state it touches if they are present on the state.
4. Once the state chart reaches the lowest common ancestor, it will start to traverse down the tree to the destination state. For each state it touches it will run the `enterState` block if its present.
5. The operation completes once the state chart reaches the destiation state.

Graphically, this would look like:

<img title="State Traversal Visual Example" src="http://cl.ly/image/2B2f1G030D0K/Screen%20Shot%202015-01-24%20at%202.03.15%20PM.png" width="500" />

## State Events

As the state chart [traverses states](#state-traversals), it will check each state it touches and run event blocks on the state if they are present. Adding event blocks to a state is not required.

As the state chart traverses down into the state it will run the `enterState` block if present. And as the state chart traverses up the tree it will run the `exitState` block if its present.

<img title="State Traversal Visual Example" src="http://cl.ly/image/2B2f1G030D0K/Screen%20Shot%202015-01-24%20at%202.03.15%20PM.png" width="300" />

In the above example, the `exitState` block would be run on state `G` and `D`. Furthermore it would run the `enterState` block on states `E` and `H`. Note that nothing was run on state `B`since we did not enter or exit that state.

## Dos and Don'ts

### Don't tell the StateChart what state to go to

Many developers new to start charts naturally gravitate to telling the state chart what state to move to. DON'T DO THIS. The outside world tells the state chart what is going on by sending it messages and its the state chart's job interpret the message and change states if necessary.


DONT
```objective-c
[statechart goToState:"red"];
```
DO

```objective-c
[stateChart sendMessage:@"userPressedTheRedButton"]
```

Then in your state chart DO:

```objective-c
@"userPressedTheRedButton":^(SKStateChart *sc) {
    [sc goToState:@"red"];
}
```

### Don't be scared to send lots of messages - even garbage ones

Sending messages to the state chart is one of its key operations. Don't be scared to send lots of messages. And don't be scared to send messages that aren't currently valid - many times that's good coding practice.

For example, think of a timer. Every minute on the minute it sends the message "minuteUpdated" to the state chart. If the state chart is in a state that it cares about receiving the message "minuteUpdated" it can choose to take action. If the state chart is in a state that it doesn't care about the message "minuteUpdated", then nothing happens - this is a good thing.

### Don't cram all your logic into the state chart

The state chart is like the conducter of a symphony. It knows all the players and tells them when to play their instrument. But it doesn't play the instruments for them. Likewise the state chart should call functions but detailed logic should stay out of the stay chart.

DO

```objective-c
@"enterState":(SKStateChart *sc) {
  [view setupUI];
}
```

DONT

```objective-c
@"enterState":(SKStateChart *sc) {
  UILabel *label = [[UILabel alloc] init];
  label = [[UILabel alloc] init];
  label.text = @"StateKit!!!";
  label.font = [UIFont systemFontOfSize:26];
  label.textColor = [UIColor blueColor];
  [self.view addSubview:label];
  // ... more view logic
}
```

### Keep state names unique

When traversing to a new state, the state chart does a breadth-first-search of the tree, start at root to find the new state. While state names are not enforced to be unique, the outcome of the bfs search might produce unexpected results. So its best to avoid duplicate state names.

### Be careful putting goToStates instructions in state event blocks

When transition between states, the state chart will call [event blocks](#state-events) as it traverses the tree. Be careful putting `goToState` directives in these blocks because you can take your state chart for awhile ride before it reaches it end destination.

### Don't reference self in the state chart

To avoid retain cycles, reference weak-self inside the state chart

DO 

```objective-c
__weak UIViewController *weakSelf = self;
NSDictionary *chart = @{@"root":@{
                                @"enterState":^(SKStateChart *sc) {
                                    weakSelf.title = @"hi";
                                }}};
```

DONT

```objective-c
NSDictionary *chart = @{@"root":@{
                                @"enterState":^(SKStateChart *sc) {
                                    self.title = @"hi";
                                }}};
```

## Gotchas

#### Inifinite Loop

It is possible to create a valid state chart that transition states indefinitly. The chart will throw an exception if there are more than 100 state transitions in one operation

## Why use a StateChart?

They say you can judge a developer's abilities by their handle on an application's flow control. Flow control can be handled in many ways, but with front-end application's accurately capturing state and working with state to manage flow control is impertivie.

### Benefits

#### Idempotent Code

By capturing all the various states and flow-control in your state chart, your code becomes cleaner and idempotent. Functions are only called when they are needed and need minimal logic-branching, because if they weren't needed, they wouldn't be called. This reduces cyclomatic-complexity and increases developer happiness.

#### Self-Documenting

This is important. By capturing state in one and only one place, you can see at an overview level all the variability in one place. Its great!

#### Capturing logic branching in one place

A single source of truth for state, what can be better.

### Crappy ways of managing state

#### Object Pointers as an indication of state

A lot of applications guess state by looking at object pointers. By seeing if an object has already been instantiated the developer will guess that something has happened. 

```objective-c
if (self.map) {
	// Is this state?
}
```

The problem with this is that referencing the memory address of an object is only a proxy for the real state. Setting `self.map = nil` doesn't change application state it will just break your code.

Additionally, the check, `if (self.map)`, will start littering your code and loose meaning to future devs.

Instead, for any logic that requires the map to be instantiated, nest those states under the map state. By definition, all of those sub-states now have a guarantee that the map was created, because you couldn't have dropped into a child state without first having created the map

```objective-c
        NSDictionary *chart = @{@"root":@{
                                        @"subStates":@{
                                                @"map":@{
                                                        @"enterState":^(SKStateChart *sc) {
                                                            // allocate map here
                                                        },
                                                        @"subStates":@{
                                                                // now any depth of breadth of states from
                                                                // here on out by definition now the map
                                                                // has already been created.
                                                                // You couldn't have gotten to that state
                                                                // without the map having already been created
                                                                }}}}
```

#### BOOLs BOOLs BOOLs

This is such a bad way to manage state its almost humorous. Have you even seen a class definition like this:

```objective-c
@interface MyClass

@property (nonatomic, assign) BOOL mapCreated;
@property (nonatomic, assign) BOOL userTouchedButton;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) BOOL shouldShowBanner;
@property (nonatomic, assign) BOOL shouldRemoveBanner;
// etc, etc, etc
```

Don't do this. Managing states in BOOLs is like managing integers with bit manipulation - it gets hairy fast. In the above example there are already 2^5 combinations, and many of those combinations are invalid. 

#### API Masking

Another common area is to shove state into API calls - basically relying on the fact that the API will take some amount of milliseconds to respond and within that timeframe you can do other operations.

This works (rolling my eyes) but your application now depends on network latency?? And what if in the future you implement data-caching in your app that returns responses immediatly? And maybe even on the same thread? That's not going to be fun to fix.

## StateKit is NOT a Finite State Machine

Statekit is a type of [Finite State Machine](http://en.wikipedia.org/wiki/Finite-state_machine) but not a FSM in the classical sense.

FSMs manage state as a graph - StateKit manages state as a tree. And while all trees are graphs, not all graphs are trees. This distinction, while subtle, is important.

Additionally State Kit adds event logic and tree traversal logic that allows for rapid application development.

With experience you will be able to recognize which problems are better represented in a StartChart vs. a Finite State Machine.

If you are looking for a Finite State Machine in the classical sense see these repos:
- [TransitionKit](https://github.com/blakewatters/TransitionKit)
- [StateMachine](https://github.com/luisobo/StateMachine)

## Unit Tests

StateKit is fully united tested.

To run the unit tests open file `./Example/StateKit.xcworkspace`. Then press `command-U` to run the tests.

## Installation

StateKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "StateKit"

Import StateKit into the necessary class

    #import <SKStateChart.h>

and instantiate your state chart

    NSDictionary *chart = @{@"root":@{}};
    SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:chart];

#### If you like StateKit, star it on GitHub to help spread the word,

## Author

Shaheen Ghiassy, shaheen@groupon.com

## License

StateKit is available under the MIT license. See the LICENSE file for more info.
