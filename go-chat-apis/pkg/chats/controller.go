package chats

import (
	"github.com/gin-gonic/gin"
)

func RegisterRoutes(r *gin.Engine) {
	routes := r.Group("/api/v1/applications")
	routes.POST("/:app_token/chats", AddChat)

}
