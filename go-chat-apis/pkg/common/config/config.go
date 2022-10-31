package config

import "github.com/spf13/viper"

type Config struct {
	Port               string `mapstructure:"PORT"`
	ChatEndpoint       string `mapstructure:"CHAT_APP_END_POINT"`
	RedisChatQ         string `mapstructure:"REDIS_CHAT_Q"`
	ChatWorker         string `mapstructure:"CHAT_WORKER"`
	ChatNumberRedisKey string `mapstructure:"CHAT_NUM_REDIS_KEY"`
	RedisUri           string `mapstructure:"REDIS_URL"`
}

func LoadConfig() (c Config, err error) {
	viper.AddConfigPath("./pkg/common/config/envs")
	viper.SetConfigName("dev")
	viper.SetConfigType("env")

	viper.AutomaticEnv()

	err = viper.ReadInConfig()

	if err != nil {
		return
	}

	err = viper.Unmarshal(&c)

	return
}
