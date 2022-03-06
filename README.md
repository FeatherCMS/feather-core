# FeatherCore

Shared libraries for Feather CMS.

```
curl \
-X POST \
-H 'Content-Type: application/json' \
-d '{"email": "root@feathercms.com", "password": "FeatherCMS"}' \
"http://localhost:8080/api/login/" | jq


curl \
    -X GET \
    -H 'Authorization: Bearer R3QPYGEk43nF5UZsdmxcwc34zTkiEPDcmtLd1nAiiuQoSeLldQnT01g4A8QiGcHD' \
    -H 'Content-Type: application/json' \
    "http://localhost:8080/api/system/variables/" | jq


curl \
-X POST "http://localhost:8080/api/system/variables/" \
-H 'Authorization: Bearer R3QPYGEk43nF5UZsdmxcwc34zTkiEPDcmtLd1nAiiuQoSeLldQnT01g4A8QiGcHD' \
-H 'Content-Type: application/json' \
-d ' \
{\
    "asdf": "486B0B47-9785-43C9-B52C-AABC5D77718D"
}' | jq
    
    
# file upload 

curl \
-X POST \
--data-binary @my_picture.png \
"http://localhost:8080/api/system/files/?path=user/accounts&name=my_picture&ext=png"


# create directory
curl \
-X POST "http://localhost:8080/api/system/files/directory/" \
-H 'Content-Type: application/json' \
-d '{"path": "user/accounts", "name": "my_dir" }' | jq

# list directory

curl -X GET "http://localhost:8080/api/system/files/?path=user"| jq 

```
