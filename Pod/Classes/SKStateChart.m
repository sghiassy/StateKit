//
//  SKStateChart.m
//  Pods
//
//  Created by Shaheen Ghiassy on 1/19/15.
//
//

#import "SKStateChart.h"
#import "SKState.h"

@interface SKStateChart ()

@property (nonatomic, copy) NSDictionary *stateChart;

@property (nonatomic, copy) NSString *currentStateName;
@property (nonatomic, strong) NSDictionary *currentStateTree;

@end

static NSString *kDefaultRootState = @"root";
static NSString *kSubStringKey = @"subStates";


@implementation SKStateChart

- (instancetype)initWithStateChart:(NSDictionary *)stateChart {
    self = [super init];

    if (self) {
        [self setRootState:stateChart];
        [self initializeDictionaryAsATree:_currentStateTree withStateName:kDefaultRootState andParentState:nil];

        [self didEnterState:_currentStateTree];
        _stateChart = _currentStateTree;
    }

    return self;
}

- (void)setRootState:(NSDictionary *)stateChart {
    _currentStateName = kDefaultRootState;
    _currentStateTree = [stateChart objectForKey:_currentStateName];
    NSAssert(_currentStateTree != nil, @"The stateChart you input does not have a root state");
}

- (SKState *)initializeDictionaryAsATree:(NSDictionary *)stateTree withStateName:(NSString *)name andParentState:(SKState *)parentState {
//    stateTree = stateTree.mutableCopy; // Cast the dictionary to a mutable copy
    SKState *state = [[SKState alloc] init];
    state.name = name;
    state.parentState = parentState;

    for (id key in stateTree) {
        id value = [stateTree valueForKey:key];

        if ([key isEqualToString:kSubStringKey]) {
            NSDictionary *subStates = (NSDictionary *)value;

            for (id stateKey in subStates) {
                NSDictionary *subTree = [subStates objectForKey:stateKey];
                SKState *subState = [self initializeDictionaryAsATree:subTree withStateName:stateKey andParentState:state];
                [state setSubState:subState];
            }
        } else {
            [state setEvent:key forBlock:value];
        }
    }

    NSString *description = state.description;

    NSLog(@"%@", description);
    return state;
}

#pragma mark - Messages

- (void)sendMessage:(NSString *)message {
    MessageBlock messageBlock = [self.currentStateTree objectForKey:message];

    if (messageBlock) {
        messageBlock(self);
    } else {
        NSLog(@"Something");
    }
}

- (void)goToState:(NSString *)goToState {
    NSDictionary *subStates = [self.currentStateTree objectForKey:@"subStates"];
    NSDictionary *newState = [subStates objectForKey:goToState];

    if (newState != nil) {
        [self didExitState:self.currentStateTree];

        self.currentStateTree = newState;
        self.currentStateName = goToState;
        [self didEnterState:self.currentStateTree];
    }
}

#pragma mark - Traveral Methods

- (void)didEnterState:(NSDictionary *)state {
    MessageBlock rootBlock = [state objectForKey:@"enterState"];

    if (rootBlock) {
        rootBlock(self);
    }
}

- (void)didExitState:(NSDictionary *)state {
    MessageBlock rootBlock = [state objectForKey:@"exitState"];

    if (rootBlock) {
        rootBlock(self);
    }
}

#pragma mark - Getters

- (NSString *)currentState {
    return [self.currentStateName copy];
}

@end
