# StateKit

[![CI Status](http://img.shields.io/travis/Shaheen Ghiassy/StateKit.svg?style=flat)](https://travis-ci.org/Shaheen Ghiassy/StateKit)
[![Version](https://img.shields.io/cocoapods/v/StateKit.svg?style=flat)](http://cocoadocs.org/docsets/StateKit)
[![License](https://img.shields.io/cocoapods/l/StateKit.svg?style=flat)](http://cocoadocs.org/docsets/StateKit)
[![Platform](https://img.shields.io/cocoapods/p/StateKit.svg?style=flat)](http://cocoadocs.org/docsets/StateKit)

<img title="State Kit Logo" src="http://cl.ly/image/1W471N2V3d3v/StateKit-Logo.png" width="800" />

StateKit is a framework to capture, document and manage application state in tree data structure.

## Quick Example

```objective-c

NSDictionary *chart = @{@"root":@{
                                @"enterState":^(SKStateChart *sc) {
                                    [sc goToState:@"loading"];
                                },
                                @"apiRespondedSuccessfully":^(SKStateChart *sc) {
                                    [sc goToState:@"regularView"];
                                },
                                @"apiRespondedError":^(SKStateChart *sc) {
                                    [sc goToState:@"errorView"];
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
                                                }},
                                        @"errorView":@{
                                                @"enterState":^(SKStateChart *sc) {
                                                    // tell the view to show the error view
                                                },
                                                @"exitState":^(SKStateChart *sc) {
                                                    // dealloc error view objects
                                                },
                                                @"userPressedRetryButton":^(SKStateChart *sc) {
                                                    [sc goToState:@"loading"];
                                                }}
                                        }
                                }};

SKStateChart *stateChart = stateChart = [[SKStateChart alloc] initWithStateChart:chart];

```

The above StateChart would produce a tree structure like the following

<img title="Quick Example Tree Structure" src="http://lnk.ghiassy.com/1EcWQOW" width="400" />

The state chart always start with `root` as the current state. As we enter the `root` state, the directive in the `enterState` of the `root` state says to go to state `loading`. As the state chart enters the `loading` state we fetch data from the api and render the spinner to the view. 

What's nice is that when your api code responds with success, we can transition the app to show the new data by simply sending the appropriate message to the state chart. In this example we would simply do `[stateChart sendMessage:@"apiRespondedSuccessfully"]`. This would transition the state chart from the `loading` state to the `regularView` state. 

As we perform this state transition from `loading` state to `regularView` state we can cleanly take care of allocating and deallocating objects with high levels of precision. As we exit the `loading` state we clean up the loading UI and as we enter the `regularView` state we setup the appropriarte UI. 

## Documentation

##### [Syntax](#syntax)
##### [Messages](#messages)
##### [State Traversals](#state-traversals)
##### [State Events](#state-events)

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

When the `root` state receives either message the associated block will be run. This is a very javascripty-way of doing things with anonymous functions/blocks. It might be a little off-putting at first if this is a new pattern, but this is the foundation of functional programming which has proved itself at scale. 

Also note that the reference to the state chart is passed into the function as `sc` for you to reference. While you could potentially reference the state chart varaible from a variable outside the chart dictionary it is advised to use the passed in reference.

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

## Messages

Events are at the heart of a state chart. After the state chart has been created the outside world send messages to the start chart telling it what is going on. The state chart will intercept the event and run the associated logic accordingly.

```objective-c
[stateChart sendMessage:@"userPressedTheRedButton"]
```

### Message Bubbling

Messages are sent to the current state and bubble up until a receiver intercepts the message. If the current state and none of the current state's parent states have a reciever for the message than the message will simply be ignored. 

![Message Bubbling Theorertical Example](http://lnk.ghiassy.com/1JkhhK3)

#### An Example

![Message Bubbling Example](http://lnk.ghiassy.com/1BUEHF1)

For which the correlating code would be

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
                                                                                            }
                                                                                    }
                                                                            }
                                                                    }
                                                            }
                                                    },
                                            @"c":@{
                                                    @"subStates":@{
                                                            @"k":@{}
                                                            }
                                                    }
                                            }
                                    }
                            };
```

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

## State Traversals

## State Events

As the state chart 

## Dos and Don'ts

### Don't tell the StateChart what state to go to

Many developers new to start charts naturally gravitate to telling the state chart what state to move to. DON'T DO THIS. The outside world tells the state chart what is going on by sending it messages and its the state chart's job to manipulate state.

DO
```objective-c
[stateChart sendMessage:@"userPressedTheRedButton"]
```

DONT
```objective-c
[statechart goToState:"red"];
```

### Don't be scared to send lots of messages - even garbage ones

Sending messages to the state chart is one of its key operations. Don't be scared to send lots of messages. And don't be scared to send messages that aren't valid - many times that's good coding practice.

For example, think of a timer. Every minute on the minute it sends the message "minuteUpdated" to the state chart. If the state chart is in a state that it cares about receiving the message "minuteUpdated" it can do its thing. If its in a state that it doesn't care about the message "minuteUpdated", then nothing happens. This is a good thing.

### Don't cram all your logic into the state chart

The state chart is like the conducter of a symphony. It knows all the players and tells them when to play their instrutment. But it doesn't play the instruments for them. Likewise the state chart should call functions but detailed logic should stay out of the stay chart

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

You can create

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

The Finite-State-Machine pattern ([FSM](http://en.wikipedia.org/wiki/Finite-state_machine)) is an excellent and well proven pattern - but StateKit is not a traditional FSM but it is a type of FSM well suited for application development.

FSMs manage application state as a graph - StateKit manages state as a tree. And while all trees are graphs, not all graphs are trees. This distinction, while subtle, is important. 

For example, in a graph any node can directly point to any other node. Conversely in a tree, getting from one node to another requires traversing the tree by passing through the least-common-anscetor. This traversal has great properties for application development. 

With experience you will be able to recognize which problems are better represented in a StartTree vs. a FSM.

If you are looking for a Finite State Machine in the traditional sense see these repos:
- [TransitionKit](https://github.com/blakewatters/TransitionKit)
- [StateMachine](https://github.com/luisobo/StateMachine)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

none

## Unit Tests

StateKit is fully united tested.

To run the unit tests open file `./Example/StateKit.xcworkspace`. Then press `command-U` to run the tests.

## Installation

StateKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "StateKit"

#### If you like StateKit, star it on GitHub to help spread the word,

## Author

Shaheen Ghiassy, shaheen@groupon.com

## License

StateKit is available under the MIT license. See the LICENSE file for more info.
