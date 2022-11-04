package chatmessages

import (
	"log"
	"net/http"
	"strconv"

	lock "github.com/bsm/redis-lock"
	"github.com/eslamabdo18/go-chat-apis/pkg/common/utlits"
	"github.com/gin-gonic/gin"
	"github.com/imroc/req"
	"github.com/spf13/viper"
)

type messageRequestInput struct {
	Body string `json:"body"`
}
type messageResponse struct {
	Number     int64  `json:"number"`
	ChatNumber int64  `json:"chat_number"`
	AppToken   string `json:"app_token"`
	Body       string `json:body`
}

type chatResponse struct {
	Number       int64  `json:"number"`
	CreatedAt    string `json:"created_at"`
	UpdatedAt    string `json:"updated_at"`
	MessageCount int64  `json:"message_count"`
}

func GetMsgNumber(token string, chatNumber string) (int64, error) {
	// create the key
	key := viper.Get("CHAT_NUM_REDIS_KEY").(string) + token + "_" + chatNumber
	// get the redis client
	client, err := utlits.GetRedisClient()
	// check if the client sussfully created
	if err != nil {
		// c.JSON(http.StatusBadRequest, gin.H{"error": err})
		return -1, err
	}
	// obtain locker on the key because if 2 clients tried to update the key at the same time
	// the lock will lock one of them to avoid the race
	lock, err := lock.Obtain(client, key+"_LOCK", nil)
	if err != nil {
		defer lock.Unlock()
		return -1, err
	}
	lock.Lock()
	// check if the key exist or not
	found, err := client.Exists(key).Result()
	if err != nil {
		defer lock.Unlock()
		// log.Println(err)
		return -1, err
	}
	if found == 0 {
		// Todo: get the latest numbber form the db
		res, err := GetChat(token, chatNumber)
		if err != nil {
			defer lock.Unlock()
			return -1, err
		}
		log.Println(key)
		client.Set(key, res.MessageCount, 1)

	}
	nextNum, err := client.Incr(key).Result()
	defer lock.Unlock()
	if err != nil {
		return -1, err
	}
	return nextNum, nil
}

func GetChat(appToken string, chatNumber string) (chatResponse, error) {
	var resp chatResponse
	url := viper.Get("CHAT_APP_END_POINT").(string) + "api/v1/applications/" + appToken + "/chats/" + chatNumber
	r, err := req.Get(url)
	if err != nil {
		return resp, err
	}

	r.ToJSON(&resp)
	return resp, nil
}

func AddMessage(c *gin.Context) {
	token := c.Param("app_token")
	chatNumber := c.Param("chat_number")
	var messageInput messageRequestInput
	err := c.BindJSON(&messageInput)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	log.Println("the token is" + token)

	nextNum, err := GetMsgNumber(token, chatNumber)
	log.Println(err)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// Push to redis q
	queue := viper.Get("REDIS_MSG_Q").(string)
	worker := viper.Get("MSG_WORKER").(string)
	err = utlits.Push(queue, worker, token, chatNumber, strconv.FormatInt(nextNum, 10), messageInput.Body)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}
	chatNumInt64, _ := strconv.ParseInt(chatNumber, 10, 64)
	resp := messageResponse{Number: nextNum, ChatNumber: chatNumInt64, AppToken: token, Body: messageInput.Body}

	c.JSON(http.StatusCreated, resp)
}
