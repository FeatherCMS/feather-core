//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

#warning("this is an admin menu item")
public struct FrontendMenu: Codable {

    public let key: String
    public let notes: String?

    public let link: FrontendMenuItem?
    public let items: [FrontendMenuItem]

    public init(key: String,
                notes: String? = nil,
                link: FrontendMenuItem? = nil,
                items: [FrontendMenuItem] = []) {
        self.key = key
        self.notes = notes
        self.link = link
        self.items = items
    }
   
    
}


