package config

import {{.authImport}}

type Config struct {
	rest.RestConf
	{{.auth}}
	{{.jwtTrans}}
	RedisConf redis.RedisConf
	DataSource string
}


const (
	serverName = "{{.serviceName}}"
)

func (c *Config) Parse(e string) *Config {
	defer func() { c.Telemetry.Name = c.Name }()
	if e == "" {
		conf.MustLoad(fmt.Sprintf("etc/%s.yaml", serverName), c)
		return c
	}

	address := strings.Split(e, ",")
	//连接ETCD读取远程配置
	etcd := (&etcdx.Cfg{Endpoints: address}).NewClient()
	// 读取远程的服务配置
	cfg := serverx.AnyLoadYaml[*Config](etcd, serverName)
	_ = copier.Copy(c, cfg)
	// 读取远程的Redis配置
	c.RedisConf = redisx.LoadYaml(etcd)
	// 读取远程的MySQL配置
	dc := dbx.LoadYaml(etcd)
	c.DataSource = dc.DataSource()
	// 读取远程的Minio配置
	c.MinioConf = miniox.LoadYaml(etcd)
	return c
}
