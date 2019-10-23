//
//  TypeAlias.swift
//  Bloomr
//
//  Created by Jacob on 11/14/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit

// Define type alias used within the app

public typealias VoidBlock = (() -> Void)
public typealias AnyScreen = AnyObject
public typealias TextFieldLengthRange = (min: Int, max: Int)

// use to receive callback from connector
public typealias CompletionBlock = (_ result: Any?, _ error: ServiceErrorAPI?) -> Void
