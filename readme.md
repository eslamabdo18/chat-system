# Chat System

Chatting system APIs using ruby on rails and go (gin) apis

1.  [APIs Documentation](https://documenter.getpostman.com/view/12162243/2s8YYEPQvR)

## 🧑🏽‍💻 Technologies used

Project created with :

1. **Ruby on rails:** I used ruby to create the main core management functionality.
2. **Go:** I used go to create the chats and the messages and i used `Gin` with it
3. **Redis:** Redis here played many roles, I used it as a message queue so i can handle the big number of requests and also i used it as in memory database.
4. **Elasticsearch:** i used it so i can search through the messages
5. **Sidekiq:** sidekiq is a message worker i used it so i can create asynchronous tasks with redis mq
6. All the testing tools like `rspec-rails` `FactoryBot` `Shoulda Matcher` `Faker`

## ⚡️ Quick start

> Make sure that `docker` and `docker-compose` are installed with `docker` running, also make sure that ports `3000` , `9200` , `6379` and ports `8080` are available for the services to run on.

    git clone https://github.com/eslamabdo18/chat-system.git
    cd chat-system
    docker-compose up --build

> This may take sometime to run the project

and to run the specs

    docker exec -it chat-rails-api bundle exec rspec

if you want to open sinatra to monitor the background task please click [here](http://localhost:3000/sidekiq)

> the docker should be running so you can open sinatra

## 👀 APIs Routes

You can also find the postman collection from [here](https://documenter.getpostman.com/view/12162243/2s8YYEPQvR)

```
Method  URI Pattern
----  -----------
GET   api/v1/applications/
POST  api/v1/applications/ -> provide the name in the body
GET   api/v1/applications/:app_token
PUT   api/v1/applications/:app_token?name={name}

GET   api/v1/applications/{access_token}/chats
GET   api/v1/applications/:app_token/chats/{chat_number}
# go apis -> chat and messages creation
POST /api/v1/applications/:app_token/chats

GET   api/v1/applications/:app_token/chats/{chat_number}/messages
GET   api/v1/applications/:app_token/chats/:chat_number/messages/:message_number
# go message create api
POST api/v1/applications/:app_token/chats/:chat_number/messages
GET   api/v1/applications/:app_token/chats/:chat_number/messages/search?query={query}


```

## 💡 How to use

**Create Application**

```
# using cURL
curl -X POST http://localhost:3000/api/v1/applications -H "Content-Type: application/json"  -d  '{"name": "instabug"}

# using httpPie
http POST :3000/api/v1/applications name=instabug
```

> output:

    {
        "app_token": "YdoWmSSQ3y66sQnafppQhF4n",
        "name": "instabug",
        "chat_count": 0,
        "created_at": "2022-11-04T12:44:13.722Z",
        "updated_at": "2022-11-04T12:44:13.722Z"
    }

**create chat within this application**

```
# using cURL
curl -X POST http://localhost:8080/api/v1/applications/YdoWmSSQ3y66sQnafppQhF4n/chats

# using httpPie
http POST :8080/api/v1/applications/YdoWmSSQ3y66sQnafppQhF4n/chats
```

> output:

    {
        "app_token": "YdoWmSSQ3y66sQnafppQhF4n",
        "number": 1
    }

**now lets create message inside this chat**

```
http POST :8080/api/v1/applications/YdoWmSSQ3y66sQnafppQhF4n/chats/1/messages body="chat system using rails and go"
```

> output:

```
{
    "Body": "chat system using rails and go",
    "app_token": "YdoWmSSQ3y66sQnafppQhF4n",
    "chat_number": 1,
    "number": 1
}
```

**lets try the search**

```
#using curl
curl -X GET 'http://localhost:3000/api/v1/applications/YdoWmSSQ3y66sQnafppQhF4n/chats/1/messages/search?query=rails'

#using httpie
http GET :3000/api/v1/applications/YdoWmSSQ3y66sQnafppQhF4n/chats/1/messages/search query="rails"
```

> output:

```
{
     "body": "chat system using rails and go",
     "created_at": "2022-11-04T13:13:25.551Z",
     "number": 2,
     "updated_at": "2022-11-04T13:13:25.551Z"
}

```

## 🗒 Appendix

In this project I use `rails` for creating all the applications and retrieving chats and messages data, for messages and chats creation i use Go (Gin)

#### Main app (rails)

- First of all i needed to optmize the `db ` so i added indices in app_token and chat/message number.
- also I validated the uniqueness of both chat and message number to handle the race condition
- used sidekiq to listen on redis queue and when the Go app add any process in it and there is an available worker it will take it and assign it to the worker.
- for the message search i used `elasticsearch` with `searchkick` to search throughout the messages
  > in the elasticsearch i created a queue too so i can handle the reindexing the db in asynchronous tasks

#### Chat/Message Creation

to create new chat/message we need to get the next chat/message number to achieve that i used `redis's atomic increment `operation that does exactly what we need .

> if the key exists in `redis` then we will get the `incr` directly. if not i will get the current number form the main app and set it and get the next chat/message number of course with this implementation could happen a race condition. A race condition may occur in the chat/message creation side when two concurrent requests that use the same application/chat are unable to find a key/value pair in `Redis` , when this happens they both send a request to the main Rails API and set the count in store with the same value and i solved this problem using `redis lock`

only the number and the token will be returned from this api call and the rest of message/chat creation will be delayed to a workers running in the background by serializing the message/chat into `JSON` object and send it to `Redis Message queue` using `Pub/Sub` , and i used `sidekiq` to handle the workers in the main app and i used this approach to create a scaleable system.
