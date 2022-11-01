package chatmessages

import "github.com/gin-gonic/gin"

func RegisterRoutes(r *gin.Engine) {
	routes := r.Group("/api/v1/applications/:app_token/chats")
	routes.POST("/:chat_number/messages", AddMessage)

}
