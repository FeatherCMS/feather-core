# FeatherCore

Todos:

- module & model path -> replace pathComponent.description calls
- eliminate FeatherPermission object, use UserPermission.Detail
- finish up controllers
- metadata support
- api




## Libraries

- FeatherCore -> Entire core package
- FeatherCoreApi -> Api objects only (can be shared with frontend libs)
- FeatherCoreSdk -> Frontend SDK 



## Metadata query naming conventions & status description

- draft
    It's a draft, it is visible via the public URL, but it has a noindex flag
    
- published
    It's a published metadata, it's visible for everyone and it can be indexed by robots
    
- archive
    It's an archived metadata it's not visible for the public nor indexed by robots

---
    
- visible:
    draft or published (everything what is not archived)
    
- public:
    published metadata with a publish date greater than now

