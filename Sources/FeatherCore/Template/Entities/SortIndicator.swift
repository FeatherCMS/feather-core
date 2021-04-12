//
//  SortIndicator.swift
//  TauFoundation
//
//  Created by Tibor Bodecs on 2020. 10. 23..
//

public struct SortIndicator: UnsafeEntity, NonMutatingMethod, StringReturn {

    public var unsafeObjects: UnsafeObjects? = nil
    
    public static var callSignature: [CallParameter] {
        [
            /// field key
            .init(label: "for", types: .string),
            /// if this is the default order we always return the indicator
            .init(label: "default", types: .bool, optional: true, defaultValue: .bool(false)),
            /// default sort value
            .init(label: "sort", types: .string, optional: true, defaultValue: .string("asc")),
        ]
    }
    
    public func evaluate(_ params: CallValues) -> TemplateData {
        guard let req = req else { return .error("Needs unsafe access to Request") }

        let isSortedAscending = (req.query["sort"] ?? params[2].string!) == "asc"
        let arrow = isSortedAscending ? "▴" : "▾"

        let fieldKey = params[0].string!
        let isDefaultOrder = params[1].bool!
        let order: String? = req.query["order"]

        /// if this is the default order and the current order query is nil we return the arrow, alternatively we return the indicator if the order equals the field key
        if (isDefaultOrder && order == nil) || order == fieldKey {
            return .string(arrow)
        }
        return .string(nil)

    }
}
