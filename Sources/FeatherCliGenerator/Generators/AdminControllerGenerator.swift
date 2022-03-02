//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

public struct AdminControllerGenerator {
    
    let descriptor: ModelDescriptor
    let module: String
    
    public init(_ descriptor: ModelDescriptor, module: String) {
        self.descriptor = descriptor
        self.module = module
    }
    
    public func generate() -> String {
        let orders = descriptor.properties.filter { $0.isOrderingAllowed }.map { "\"" + $0.name + "\"," }.joined(separator: "\n")
        let search = descriptor.properties.filter { $0.isSearchable }.map { "\\.$" + $0.name + " ~~ term," }.joined(separator: "\n")
        let columns = descriptor.properties.filter { $0.isOrderingAllowed }.map { ".init(\"" + $0.name + "\")," }.joined(separator: "\n")
        
        let cells = descriptor.properties.filter { $0.isOrderingAllowed }.map {
            ".init(model.\($0.name), link: LinkContext(label: model.\($0.name), permission: ApiModel.permission(for: .detail).key)),"
        }.joined(separator: "\n")
        
        let details = descriptor.properties.filter { $0.isOrderingAllowed }.map {
            ".init(\"\($0.name)\", model.\($0.name)),"
        }.joined(separator: "\n")

        let ctrl = Object(type: "struct",
                          name: "\(module)\(descriptor.name)AdminController",
                          inherits: ["AdminController"],
                          typealiases: [
                            .init(name: "ApiModel", value: "\(module).\(descriptor.name)"),
                            .init(name: "DatabaseModel", value: "\(module)\(descriptor.name)Model"),
                            .init(name: "CreateModelEditor", value: "\(module)\(descriptor.name)Editor"),
                            .init(name: "UpdateModelEditor", value: "\(module)\(descriptor.name)Editor"),
                        ], properties: [
                            .init(name: "listConfig",
                                  type: "ListConfiguration",
                                  getter: """
                                    .init(allowedOrders: [
                                    \(orders.indentLines())
                                    ])
                                    """)
                        ], functions: [
                            .init(name: "listSearch",
                                  arguments: [
                                    .init(name: "term", type: "String", label: "_")
                                  ],
                                  returns: "[ModelValueFilter<DatabaseModel>]",
                                  body: """
                                    [
                                    \(search.indentLines())
                                    ]
                                    """),
                            
                                .init(name: "listColumns",
                                      returns: "[ColumnContext]",
                                      body: """
                                        [
                                        \(columns.indentLines())
                                        ]
                                        """),
                            
                                .init(name: "listCells",
                                      arguments: [
                                        .init(name: "model", type: "DatabaseModel", label: "for")
                                      ],
                                      returns: "[CellContext]",
                                      body: """
                                        [
                                        \(cells.indentLines())
                                        ]
                                        """),
                            
                                .init(name: "detailFields",
                                      arguments: [
                                        .init(name: "model", type: "DatabaseModel", label: "for")
                                      ],
                                      returns: "[DetailContext]",
                                      body: """
                                        [
                                            .init("id", model.uuid.string),
                                        \(details.indentLines())
                                        ]
                                        """),
                            
                                .init(name: "deleteInfo",
                                      arguments: [
                                        .init(name: "model", type: "DatabaseModel", label: "_")
                                      ],
                                      returns: "String",
                                      body: """
                                        model.uuid.string
                                        """),
                        ])

        return ctrl.debugDescription
    }
}
