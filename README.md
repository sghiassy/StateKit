# StateKit

[![CI Status](http://img.shields.io/travis/Shaheen Ghiassy/StateKit.svg?style=flat)](https://travis-ci.org/Shaheen Ghiassy/StateKit)
[![Version](https://img.shields.io/cocoapods/v/StateKit.svg?style=flat)](http://cocoadocs.org/docsets/StateKit)
[![License](https://img.shields.io/cocoapods/l/StateKit.svg?style=flat)](http://cocoadocs.org/docsets/StateKit)
[![Platform](https://img.shields.io/cocoapods/p/StateKit.svg?style=flat)](http://cocoadocs.org/docsets/StateKit)

![State-Kit-Logo](http://lnk.ghiassy.com/1CnHYv9)



StateKit is a framework to capture, manage and manage application state as tree data structure.

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
                                                    // tell the view to show data
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

![Quick Example Tree Structure](http://lnk.ghiassy.com/1EDXItt)

## Why use a StateChart?

They say you can judge a developer's abilities by their handle on an application's flow control. Flow control can be handled in many ways, but with front-end application's accurately capturing state and working with state to manage flow control is impertivie.

### Benefits

#### Idempotent Code

#### Self-Documenting

#### Capturing logic branching in one place

#### Nuanced states

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

## Author

Shaheen Ghiassy, shaheen@groupon.com

## License

StateKit is available under the MIT license. See the LICENSE file for more info.
