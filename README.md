# StateKit

<img title="StateKit Logo" src="http://cloud.shaheenghiassy.com/image/252G1229101R/StateKit-Logo.png" width="800" />

[StateKit](https://github.com/sghiassy/StateKit) is a framework for iOS and OSX, to capture, document and manage state, in order to keep your application code calm & sane.

## Quick Example

Lets see a quick, small example of using [StateKit](https://github.com/sghiassy/StateKit) to manage a loading state and regular state.

We create the state chart like so:

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

The above dictionary is interpreted into a tree data structure like so:

<img title="Quick Example Tree Structure" src="http://cloud.shaheenghiassy.com/image/3B1P131T060Y/Screen%20Shot%202015-01-24%20at%202.41.09%20PM.png" width="400" />

Lets follow the story of what happens in this particular state chart:

On `init`, the state chart always starts with `root` as the current state. As we enter the `root` state, the state chart sees there is an `enterState` block in the `root` state and therefore runs the associated block. The block directs the state chart to go to the `loading` state. So the state chart continues traversing the tree into the `loading` state. As we enter the `loading` state, the `enterState` block on the `loading` state is run. Here we can tell the application to fetch data from the api and render the spinner to the view. Note, how the state chart is directing the application on what to do.

When the API responds successfully, we send the appropriate message to the state chart `[stateChart sendMessage:@"apiRespondedSuccessfully"]`. From the standpoint of the application's code, we have nothing further to do, we assume that the state chart will direct any future steps if necessary.

When the state chart recieves the message `apiRespondedSuccessfully`, the state chart would lookup the appropriate message handler and run the message handler's block. In this example, the block directs the state chart to traverse to the `regularView` state.

As the state chart traverses from the `loading` state to the `regularView` state, we can cleanly take care of alloc/deallcing objects with a high-level of precision. As we exit the `loading` state we clean up the loading UI (aka remove/dealloc the spinner, etc) and as we enter the `regularView` state we setup the appropriarte UI.

This is a basic example of a state chart, but demonstrates how application flow control can be intellilgently managed and directed by the state chart.

## Why use a state chart?

They say you can measure a developer's ability by their handle on an application's flow control. Flow control can be handled in many ways, but especially with front-end application, accurately capturing and working with state to manage flow control across an application is impertivie.

[StateKit](https://github.com/sghiassy/StateKit) gives you the power to easily create complex flow control in an easy to read and maintainable manner.

### Benefits

  * **Reduce Cyclomatic Complexity** - Because most if not all branching logic can be described and captured in the state chart, your functions are safe to assume they will only be called when needed. This guarantee, allows for less error checking and less logic branching in your functions which reduces [cyclomatic comlexity](http://en.wikipedia.org/wiki/Cyclomatic_complexity).
  * **Calm your code** - With a proper state chart managing flow control, functions can now begin to calm down. Their code, which used to brace for being called inappropriartly or had to check to figure out what had happened previously, can now dispense with those worries. Functions can now safely assume (given the right state chart structure) that they are being called only when actually needed and can safely assume any necessary allocations or setup actions have been taken care of a parent application's state before they were called.
  * **Garbage-in, Sanity-out** - As applications grow, the environment that the code works in, continually gets more convoluted. NSNotificationEvents, User events, Timer events and broken code all contribute towards degrading clean flow control and the developer's sanity. By delegating events / messages to the state chart, you can use an appropriate data structure to interpret the chaos and produce clean, purified flow control.
  * **Better Memory Management** - By creating the appropriate tree structure we can precisly define where/when objects should be allocated and deallocated. Nested states need not worry about objects having not been created as parent states will already have taken care of this fact. 
  * **Self-Documenting** - By capturing state in a tree, you can see, at an overview, all the logic branching for a file in one place in a way that visually describes what is going on.
  * **Single Source of Truth** - A single source of truth for state, what can be better.

## Documentation

- [Quick Example](#quick-example)
- [Why use a State Chart](#why-use-a-statechart)
- [Syntax](#syntax)
  - [Root State](#root-state)
  - [Messages](#a-states-messages)
  - [Sub States](#sub-states)
- [Messages](#messages)
  - [Message Bubbling](#message-bubbling)
    - [Message Bubbling Example](#an-example)
- [State Traversals](#state-traversals)
- [State Events](#state-events)
- [Do's and Dont's](#dos-and-donts)
- [Gotchas](#gotchas)
- [StateKit is not a FSM](#statekit-is-not-a-finite-state-machine)
- [Unit Tests](#unit-tests)
- [Installation](#installation)
- [Author](#author)
- [License](#license)

## Syntax

The syntax for a creating a state chart is as follows:

#### Root State

All state charts must have a root state - otherwise [StateKit](https://github.com/sghiassy/StateKit) will throw an exception. Below is the minimum viable state chart.

```objective-c
NSDictionary *chart = @{@"root":@{}};
SKStateChart *stateChart = stateChart = [[SKStateChart alloc] initWithStateChart:chart];
```

#### A State's Messages

Messages are defined at the top level of the state's dictionary entry. To add the messages `apiRespondedSuccess` and `apiRespondedError` to the root state we would do the following:

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

_Note: Messages' key/value pair must be of type string/block._

_Note that the reference to the state chart is passed into the function as `sc`. While you could potentially reference the state chart instance from a variable outside of the dictionary, it is advised to use the passed in reference._

#### Sub-states

Substates are defined in a dictionary under the keyword `subStates`. If we wanted to add a `loading` subState to the above example we would write:

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

_Note: Substates key/value pair must be of type string/dictionary._

## Messages

Events are at the heart of a state chart. After the state chart has been created, the outside world can start to send messages to the state chart; keeping it abreast of what is going on. The state chart will interpret the message(s) and run the appropriate receiver block (if any).

```objective-c
[stateChart sendMessage:@"userPressedTheRedButton"]
```

### Message Bubbling

Messages are first sent to the current state to see if there is a receiver for the message. If the current state does not respond to the message, the state chart will begin to bubble up the tree to find any parent states that respond to the message. If the current state plus any of the current state's parent states, do not respond to the message, the message will be quietly ignored.

<img title="Message Bubbling Theorertical Example" src="http://lnk.ghiassy.com/1JkhhK3" width="400" />

#### A Example

Here is a contrived but helpful example of how message bubbling works under varioius circumstantes. Assume the following state chart:

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

Here is a table showing the output of sending the message `userPressedButton` to the state chart given various starting current states.

| Under Current State | Sending `userPressedButton` would Output          |
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

###### The fact that the same message can mean different actions depending on the state chart's data structure is very powerful and is considered good practice.

## State Traversals

State Traversals are another important aspect of a state chart. When transitioning from one state to another state, the state chart does not directly go from one to another. Instead the state chart traverses the tree to get from one state to another. This tree traversal, combined with [State Events](#state-events) makes for a powerful combination to precisely manage an application's flow control.

The logic to transition from one state to another state, takes the following steps:

1. The state chart does a [breadth first search](http://en.wikipedia.org/wiki/Breadth-first_search) on the underlying [tree data structure](http://en.wikipedia.org/wiki/Tree_%28data_structure%29) to find the state to transition to.
2. The state chart then finds the [lowest common ancestor](http://en.wikipedia.org/wiki/Lowest_common_ancestor) between the two states.
3. The state chart then traverses up the tree from the current state to the [lowest common ancestor](http://en.wikipedia.org/wiki/Lowest_common_ancestor). As the state chart traverses up the tree it will run the `exitState` block of each state it touches if they are present on the state.
4. Once the state chart reaches the [lowest common ancestor](http://en.wikipedia.org/wiki/Lowest_common_ancestor), it will start to traverse down the tree to the destination state. For each state it touches it will run the `enterState` block if its present.
5. The operation completes once the state chart reaches the destination state.

Graphically, this would look like:

<img title="State Traversal Visual Example" src="http://cloud.shaheenghiassy.com/image/1R2U3P140d1Q/Screen%20Shot%202015-01-24%20at%206.03.20%20PM.png" width="500" />

## State Events

As the state chart [traverses states](#state-traversals), it will check each state it touches and run event blocks on the state if they are present. Adding event blocks to your state chart is not required.

As the state chart traverses down into the state it will run the `enterState` block if present. And as the state chart traverses up the tree it will run the `exitState` block if its present.

<img title="State Traversal Visual Example" src="http://cloud.shaheenghiassy.com/image/1R2U3P140d1Q/Screen%20Shot%202015-01-24%20at%206.03.20%20PM.png" width="300" />

In the above example, the `exitState` block would be run on state `G` and `D`. The `enterState` block would be run on states `E` and `H`.

_Note that nothing was run on state `B`since we did not enter or exit that state._

## Do's and Dont's

### Don't tell the state chart what state to go to

Many developers new to state charts naturally gravitate towards telling the state chart what state to move to. DON'T DO THIS. The outside world tells the state chart what is going on by sending it messages and its the state chart's job to interpret the message and manipulate state accordingly (if at all).


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

For example, think of a timer. Every minute, on the minute it sends the message `minuteUpdated` to the state chart. If the state chart is in a state that it cares about receiving the message `minuteUpdated` it can choose to take action. If the state chart is in a state that it doesn't care about the message `minuteUpdated`, then nothing happens - this is a good thing.

### Don't cram all your logic into the state chart

The state chart is like the conducter of a symphony. It knows all the players and tells them when to play their instrument. But it doesn't play the instruments for them. Likewise the state chart should call functions but detailed logic should stay out of the state chart.

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

When traversing to a new state, the state chart does a [breadth first search](http://en.wikipedia.org/wiki/Breadth-first_search) of the tree, starting at the root state and proceeding until it finds the destination state. While state names are not enforced to be unique, the outcome of the [bfs](http://en.wikipedia.org/wiki/Breadth-first_search) search might produce unexpected results. So its best to avoid duplicate state names.

### Be careful putting goToStates instructions in state event blocks

When transitioning between states, the state chart will call [event blocks](#state-events) as it traverses the tree. Be careful putting `goToState` directives in these blocks because you can take your state chart for a wild ride before it reaches its end destination.

But as you can see from the provided examples, there is a time and place to put a `goToState` directive in an `enterState` block - just be careful.

### Don't reference self in the state chart

To avoid retain cycles, reference weak-self inside the state chart.

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

It is possible to create a valid state chart that transition states indefinitly. This is obviously bad - don't do it. 

To aid, [StateKit](https://github.com/sghiassy/StateKit) will throw an exception if there are more than 100 state transitions in one operation

## StateKit is NOT a Finite State Machine

[StateKit](https://github.com/sghiassy/StateKit) is a type of [Finite State Machine](http://en.wikipedia.org/wiki/Finite-state_machine) but not a FSM in the classical sense.

FSMs manage state as a graph - [StateKit](https://github.com/sghiassy/StateKit) manages state as a tree. And while all trees are graphs, not all graphs are trees. This distinction, while subtle, is important.

Additionally [StateKit](https://github.com/sghiassy/StateKit) adds event and tree traversal logic to the underlying data structure that allows for rapid application development.

With experience you will be able to recognize which problems are better represented in a state chart vs. a [Finite State Machine](http://en.wikipedia.org/wiki/Finite-state_machine).

If you are looking for a classical [Finite State Machine](http://en.wikipedia.org/wiki/Finite-state_machine) for iOS or OS X Development see:
- [TransitionKit](https://github.com/blakewatters/TransitionKit)
- [StateMachine](https://github.com/luisobo/StateMachine)

## Unit Tests

[StateKit](https://github.com/sghiassy/StateKit) is fully united tested.

To run the unit tests open file `./Example/StateKit.xcworkspace`. Then press `command-U` to run the tests.

## Installation

[StateKit](https://github.com/sghiassy/StateKit) is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "StateKit"

##### If you like StateKit, star it on GitHub to help spread the word

Import [StateKit](https://github.com/sghiassy/StateKit) into the necessary class

```objective-c
#import <SKStateChart.h>
```

and create/instantiate your state chart

```objective-c
NSDictionary *chart = @{@"root":@{}};
SKStateChart *stateChart = [[SKStateChart alloc] initWithStateChart:chart];
```

## Author

Shaheen Ghiassy, shaheen@groupon.com

## License

[StateKit](https://github.com/sghiassy/StateKit) is available under the MIT license. See the LICENSE file for more info.
