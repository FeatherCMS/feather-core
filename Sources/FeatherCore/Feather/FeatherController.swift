//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Foundation

public protocol FeatherController: ListController,
                            DetailController,
                            CreateController,
                            UpdateController,
                            PatchController,
                            DeleteController
{
    
}
