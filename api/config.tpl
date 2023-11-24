package config

import (
	"strings"

	"github.com/jinzhu/copier"
	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/stores/redis"
	"github.com/zeromicro/go-zero/rest"
	"gitlab.galaxy123.cloud/base/public/core/dbx"
	"gitlab.galaxy123.cloud/base/public/core/etcdx"
	"gitlab.galaxy123.cloud/base/public/core/redisx"
	"gitlab.galaxy123.cloud/base/public/core/serverx"
)

type Config struct {
	rest.RestConf
	RedisConf redis.RedisConf
    DataSource string
}

var defaultCfgFile = "etc/config.yaml"

func (c *Config) Parse(e,p,v,s string)*Config {
    defer func() { c.Telemetry.Name = p }()
	if e == "" {
		conf.MustLoad(defaultCfgFile, c)
		return c
	}

	address := strings.Split(e, ",")
	//连接ETCD读取远程配置
	etcd := (&etcdx.Cfg{Endpoints: address}).NewClient()
	// 读取远程的服务配置
	cfg := serverx.AnyLoad[*Config](etcd, p, v,s)
	_ = copier.Copy(c, cfg)
	// 读取远程的Redis配置
	c.RedisConf = redisx.Load(etcd,p, v)
	// 读取远程的MySQL配置
	dc := dbx.Load(etcd, p,v)
	c.DataSource = dc.DataSource()
	return c
}