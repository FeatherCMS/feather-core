//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 09..
//

extension SystemModule {

    func installPermissionsHook(args: HookArguments) -> [PermissionCreateObject] {
        [
            SystemModule.hookInstallPermission(for: .custom("admin"))
        ]
    }
    
    func installVariablesHook(args: HookArguments) -> [VariableCreateObject] {
        [
            .init(key: "siteNoindex",
                  name: "Site noindex",
                  notes: "Disable site indexing by search engines"),
            
            .init(key: "siteLogo",
                  name: "Site logo",
                  notes: "Logo of the website"),
            
            .init(key: "siteTitle",
                  name: "Site title",
                  value: "Feather",
                  notes: "Title of the website"),
            
            .init(key: "siteExcerpt",
                  name: "Site excerpt",
                  value: "Feather is an open-source CMS written in Swift using Vapor 4.",
                  notes: "Excerpt for the website"),
            
            .init(key: "siteCss",
                  name: "Site CSS",
                  notes: "Global CSS injection for the site"),
            
            .init(key: "siteJs",
                  name: "Site JS",
                  notes: "Global JavaScript injection for the site"),
            
            .init(key: "siteFooterTop",
                  name:  "Site footer top section",
                  value: """
                        <img class="size" src="/img/icons/icon.png" alt="Logo of Feather" title="Feather">
                        <p>This site is powered by <a href="https://feathercms.com/" target="_blank">Feather CMS</a> &copy; 2020 - {year}</p>
                    """,
                  
                  notes: "Top footer content placed above the footer menu"),

            .init(key: "siteFooterBottom",
                  name: "Site footer bottom",
                  notes: "Bottom footer content placed under the footer menu"),
        ]
    }

}
