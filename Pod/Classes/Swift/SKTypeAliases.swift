//
//  SKTypeAliases.swift
//  Groupon
//
//  Created by Adam Eisfeld on 1/22/16.
//  Copyright © 2016 Groupon Inc. All rights reserved.
//

import Foundation

/// An alias for converting a closure to StateKit's expected block
typealias SKStateBlock = @convention(block) (sc: SKStateChart) -> Void