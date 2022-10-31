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
	// redisChatQ := viper.Get("REDIS_CHAT_Q").(string)
	r := gin.Default()

	// r.GET("/", func(c *gin.Context) {
	// 	c.JSON(200, gin.H{
	// 		"port":      port,
	// 		"chat queu": redisChatQ,
	// 	})
	// })

	chats.RegisterRoutes(r)

	r.Run(port)
}
