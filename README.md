# README

- bundle install
- rails s

Endpoints
Base url for routes is: localhost:3000/properties

GET
- /index - will return all properties sorted by created time
  params: sort_by= {params} -> price, beds, baths
  ie:
  - localhost:3000/properties/index?sort_by=price
  - localhost:3000/properties/index?sort_by=beds
  - localhost:3000/properties/index?sort_by=baths
  - localhost:3000/properties/index?sort_by=upvote
  - localhost:3000/properties/index?sort_by=netscore
  - localhost:3000/properties/index?sort_by=downvote //asc order

GET
- /show - Returns single property
 - query param -> id

 ie: localhost:3000/properties/show?id=1

POST
- /upvote - Add the vote value to upvote
 - body:
  {
    "property": {
        "id": 1,
        "vote": 3
    }
  }

POST
- /downvote - it will negate the value of vote from downvote
 - body:
  {
    "property": {
        "id": 1,
        "vote": 3
    }
  }
