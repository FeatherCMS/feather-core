//
//  TranslationEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 16..
//

struct TranslationEntity: UnsafeEntity, NonMutatingMethod, StringReturn {

    var unsafeObjects: UnsafeObjects? = nil

    static var callSignature: [CallParameter] { [.string] }

    func evaluate(_ params: CallValues) -> TemplateData {

        guard let app = app else { return .error("Needs unsafe access to Application") }

        let name = "translation-dictionary"
        let key = params[0].string!
        let translations: [[String: String]] = app.invokeAll(name)
        let dict = translations.flatMap { $0 }.reduce([String:String]()) { (dict, tuple) in
            var nextDict = dict
            nextDict.updateValue(tuple.1, forKey: tuple.0)
            return nextDict
        }
        let value = dict[key]
        return .string(value ?? key)
    }
}


