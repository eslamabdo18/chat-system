package main

import (
	"github.com/eslamabdo18/go-chat-apis/pkg/chats"
	"github.com/gin-gonic/gin"
	"github.com/spf13/viper"
)

func main() {
	viper.SetConfigFile("./pkg/common/envs/.env")
	viper.ReadInConfig()

	port := viper.Get("PORT").(string)

	r := gin.Default()

	chats.RegisterRoutes(r)

	r.Run(port)
}
