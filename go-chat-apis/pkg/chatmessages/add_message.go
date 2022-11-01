package chatmessages

import (
	"log"
	"net/http"
	"strconv"

	"github.com/eslamabdo18/go-chat-apis/pkg/common/utlits"
	"github.com/gin-gonic/gin"
	"github.com/spf13/viper"
)

func GetMsgNumber(token string) {

}

func AddChat(c *gin.Context) {
	// body := AddChatRequestBody{}
	token := c.Param("app_token")
	chatNumber := c.Param("chat_number")
	log.Println("the token is" + token)

	nextNum, err := GetChatNumber(token, chatNumber)
	log.Println(err)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// Push to redis q
	queue := viper.Get("REDIS_MSG_Q").(string)
	worker := viper.Get("MSG_WORKER").(string)
	err = utlits.Push(queue, worker, token, strconv.FormatInt(nextNum, 10))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}
	resp := chatResponse{Number: nextNum, AppToken: token}

	c.Bind(&resp)
	c.JSON(http.StatusCreated, resp)
}
