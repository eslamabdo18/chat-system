package utlits

import (
	// "github.com/bsm/redislock"
	"github.com/go-redis/redis"
)

var client *redis.Client

func GetRedisClient() (*redis.Client, error) {
	if client == nil {
		client = redis.NewClient(&redis.Options{
			Addr:     "localhost:6379",
			Password: "",
			DB:       0,
		})

		err := client.Ping().Err()
		if err != nil {
			return nil, err
		}
		// locker, err := lock.Obtain(client, "lock.foo", nil)
	}
	return client, nil
}
