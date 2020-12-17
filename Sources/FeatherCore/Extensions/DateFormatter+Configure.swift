//
//  DateFormatter+Configure.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 20..
//

public extension DateFormatter {

    func configure() {
        calendar = Calendar(identifier: .iso8601)
        locale = Locale(identifier: "en_US_POSIX")
    }
}
