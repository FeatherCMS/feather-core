//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 20..
//

extension DateFormatter {

    private func configure() {
        calendar = Calendar(identifier: .iso8601)
        locale = Locale(identifier: "en_US_POSIX")
    }

    static let asset: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd_HH-mm-ss"
        formatter.configure()
        return formatter
    }()
}
