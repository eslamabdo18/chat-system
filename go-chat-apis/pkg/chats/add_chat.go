package chats

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

type AddChatRequestBody struct {
	AppToken string `json:"app_token"`
}
type chatResponse struct {
	Number   int64  `json:"number"`
	AppToken string `json:"app_token"`
}
type applicationResponse struct {
	Name      string `json:"name"`
	AppToken  string `json:"app_token"`
	CreatedAt string `json:"created_at"`
	UpdatedAt string `json:"updated_at"`
	ChatCount int64  `json:"chat_count"`
}

func GetChatNumber(token string) (int64, error) {

	// create the key
	key := viper.Get("CHAT_NUM_REDIS_KEY").(string) + token
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
		res, err := GetChatsCount(token)
		if err != nil {
			defer lock.Unlock()
			return -1, err
		}
		log.Println(key)
		client.Set(key, res.ChatCount, 1)

	}
	nextNum, err := client.Incr(key).Result()
	defer lock.Unlock()
	if err != nil {
		return -1, err
	}
	return nextNum, nil
}

func GetChatsCount(appToken string) (applicationResponse, error) {
	var resp applicationResponse
	url := viper.Get("CHAT_APP_END_POINT").(string) + "api/v1/applications/" + appToken
	r, err := req.Get(url)
	if err != nil {
		return resp, err
	}

	r.ToJSON(&resp)
	return resp, nil
}

func AddChat(c *gin.Context) {
	// body := AddChatRequestBody{}
	token := c.Param("app_token")
	log.Println("the token is" + token)

	// log.Println("redis" + redis)
	// key := "CHAT_" + token

	nextNum, err := GetChatNumber(token)
	log.Println(err)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// Push to redis q
	queue := viper.Get("REDIS_CHAT_Q").(string)
	worker := viper.Get("CHAT_WORKER").(string)
	err = utlits.Push(queue, worker, token, strconv.FormatInt(nextNum, 10))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}
	resp := chatResponse{Number: nextNum, AppToken: token}

	// c.Bind(&resp)
	c.JSON(http.StatusCreated, resp)
}
