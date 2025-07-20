//
//  LoggerServiceProtocol.swift
//  Test
//
//  Created by FoxxFire on 20.07.2025.
//

import Foundation

protocol LoggerService: AnyObject {
    func logEvent(message: String, type: LoggerEventType)
}
