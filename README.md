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

They say you can judge a developer's abilities by their handle on an application's flow control. 

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
