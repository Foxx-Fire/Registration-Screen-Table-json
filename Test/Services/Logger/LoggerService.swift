//
//  LoggerService.swift
//  Test
//
//  Created by FoxxFire on 20.07.2025.
//

import UIKit
import OSLog

class OSLogLogger: LoggerService {

    // MARK: - Properties

    static let shared: LoggerService = OSLogLogger()
    private let log: OSLog? = {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return nil
        }
        return OSLog(subsystem: bundleIdentifier, category: "Logger")
    }()
    private let queue = DispatchQueue(label: "logger.serialQueue")

    // MARK: - Init

    private init() {}

    // MARK: - Internal

    func logEvent(message: String, type: LoggerEventType) {
        queue.async { [weak self] in
            guard let self = self, let log = self.log else {
                return
            }
            var logType: OSLogType

            switch type {
            case .warning:
                logType = .info
            case .error:
                logType = .error
            case .attention:
                logType = .default
            case .other:
                logType = .debug
            }
            os_log("%@", log: log, type: logType, message)
        }
    }
}

