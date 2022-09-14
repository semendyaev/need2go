FROM golang:latest AS build

WORKDIR /app
ADD index.go .
RUN go build -a -tags netgo -ldflags '-w -extldflags "-static"' -o server-app *.go

FROM scratch
COPY --from=build /app/server-app /server-app

ENTRYPOINT ["/server-app"]