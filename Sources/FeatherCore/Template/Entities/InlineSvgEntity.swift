//
//  InlineSvgEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

struct InlineSvgEntity: NonMutatingMethod, Invariant, StringReturn {

    static var callSignature: [CallParameter] {
        [
            .string,
            .string(labeled: "class", optional: true, defaultValue: "")
        ]
    }

    func evaluate(_ params: CallValues) -> TemplateData {
        let name = params[0].string!
        
        let path = Application.Paths.svg
            .appendingPathComponent(name)
            .appendingPathExtension("svg")

        do {
            var svg = try String(contentsOf: path, encoding: .utf8)
            if let cls = params[1].string, !cls.isEmpty {
                svg = svg.replacingOccurrences(of: "<svg", with: "<svg class=\"\(cls)\" ")
            }
            return .string(svg)
        }
        catch {
            return .string(nil)
        }
    }
}
