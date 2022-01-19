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
        let orders = descriptor.properties.filter { $0.isOrderingAllowed }.map { "\"" + $0.name + "\"" }.joined(separator: ",\n")
        let search = descriptor.properties.filter { $0.isSearchable }.map { "\\.$" + $0.name + " ~~ term" }.joined(separator: ",\n")
        let columns = descriptor.properties.filter { $0.isOrderingAllowed }.map { ".init(\"" + $0.name + "\")" }.joined(separator: ",\n")
        
        let cells = descriptor.properties.filter { $0.isOrderingAllowed }.map {
            ".init(model.\($0.name), link: LinkContext(label: model.\($0.name), permission: ApiModel.permission(for: .detail).key))"
        }.joined(separator: ",\n")
        
        let details = descriptor.properties.filter { $0.isOrderingAllowed }.map {
            ".init(\"\($0.name)\", model.\($0.name)),"
        }.joined(separator: ",\n")

        return """
        struct \(module)\(descriptor.name)AdminController: AdminController {
            typealias ApiModel = \(module).\(descriptor.name)
            typealias DatabaseModel = \(module)\(descriptor.name)Model
            
            typealias CreateModelEditor = \(module)\(descriptor.name)Editor
            typealias UpdateModelEditor = \(module)\(descriptor.name)Editor
            
            var listConfig: ListConfiguration {
                .init(allowedOrders: [
                    \(orders)
                ])
            }

            func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
                [
                    \(search)
                ]
            }

            func listColumns() -> [ColumnContext] {
                [
                    \(columns)
                ]
            }
            
            func listCells(for model: DatabaseModel) -> [CellContext] {
                [
                    \(cells)
                ]
            }
            
            func detailFields(for model: DatabaseModel) -> [DetailContext] {
                [
                    .init("id", model.uuid.string),
                    \(details)
                ]
            }
            
            func deleteInfo(_ model: DatabaseModel) -> String {
                model.uuid.string
            }
        }
        """
    }
}

