# FeatherCore

Todos:

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


## Routes

Admin       Method  Prefix                        Suffix

LIST        GET     /admin/module     /model/
CREATE      GET     /admin/module     /model/create/
CREATE      POST    /admin/module     /model/create/
DETAIL      GET     /admin/module     /model/:id/
UPDATE      GET     /admin/module     /model/:id/update
UPDATE      POST    /admin/module     /model/:id/update
DELETE      GET     /admin/module     /model/:id/delete
DELETE      POST    /admin/module     /model/:id/delete

Api         Method  Prefix                        Suffix

LIST        GET     /admin/module     /model/
CREATE      POST    /admin/module     /model/
DETAIL      GET     /admin/module     /model/:id/
UPDATE      PUT     /admin/module     /model/:id/update
PATCH       PATCH   /admin/module     /model/:id/delete
DELETE      DELETE  /admin/module     /model/:id/delete



Admin       Method  Prefix                        Suffix

LIST        GET     /admin/module/parent/:id/     /model/
CREATE      GET     /admin/module/parent/:id/     /model/create/
CREATE      POST    /admin/module/parent/:id/     /model/create/
DETAIL      GET     /admin/module/parent/:id/     /model/:id/
UPDATE      GET     /admin/module/parent/:id/     /model/:id/update
UPDATE      POST    /admin/module/parent/:id/     /model/:id/update
DELETE      GET     /admin/module/parent/:id/     /model/:id/delete
DELETE      POST    /admin/module/parent/:id/     /model/:id/delete

Api         Method  Prefix                        Suffix

LIST        GET     /admin/module/parent/:id/     /model/
CREATE      POST    /admin/module/parent/:id/     /model/
DETAIL      GET     /admin/module/parent/:id/     /model/:id/
UPDATE      PUT     /admin/module/parent/:id/     /model/:id/update
PATCH       PATCH   /admin/module/parent/:id/     /model/:id/delete
DELETE      DELETE  /admin/module/parent/:id/     /model/:id/delete


prefix path component needs req object
suffix path component can be static

list -> create (path + rowId + list suffix), update (path + rowId + update suffix), delete (path + rowId + delete suffix)
detail -> update (path + update suffix), delete (path + delete suffix)
update -> detail (path - update suffix), delete (path - update + delete suffix)
delete -> list (path - delete)

parent
list -> child list (path + rowId + list suffix)
detail -> child list (path + list suffix)
update -> child list (path - update + list suffix)

### Table actions
req + rowId + action

### LinkContext
By default it'll work with relative URLs

path: String 
isBlank: Bool = false
absolute: Bool = false
dropLast: Int = 0 -> drop n last component


## API cURL examples

```bash
curl -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d '{"email": "root@feathercms.com", "password": "FeatherCMS"}' \
    http://localhost:8080/api/login/


curl -X GET \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer TOKEN" \
    http://localhost:8080/api/admin/web/menus


curl -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer TOKEN" \
    -d '{"key": "foo", "name": "foo"}' \
    http://localhost:8080/api/admin/web/menus

```

