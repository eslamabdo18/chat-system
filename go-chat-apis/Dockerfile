FROM golang:1.19.2

# Set the Current Working Directory inside the container
# RUN mkdir /go/src/github.com/eslamabdo18/go-chat-apis
WORKDIR /go/src/github.com/eslamabdo18/go-chat-apis

# Copy everything from the current directory to the PWD (Present Working Directory) inside the container
COPY . .

# Download all the dependencies
RUN go get -d -v ./...

# Install the package
RUN go install -v ./...

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# This container exposes port 8080 to the outside world
EXPOSE 8080

# Run the executable
CMD ["go",'run',"cmd/main.go"]