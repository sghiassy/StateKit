//
//  SKSwiftHelpers.swift
//
//  Created by Adam Eisfeld on 1/22/16.
//

import Foundation

/// An alias for converting a closure to StateKit's expected block
typealias SKStateBlock = @convention(block) (_ sc: SKStateChart) -> Void

/// A convenience function for converting an SKStateBlock to AnyObject so that it may be inserted into a Swift dictionary
func SKStateBlockify(block:@escaping (_ sc: SKStateChart) -> Void) -> AnyObject {
	return unsafeBitCast(block as SKStateBlock, to: AnyObject.self)
}
