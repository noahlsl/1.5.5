package svc

import (

	{{.imports}}
	"gitlab.galaxy123.cloud/base/public/models/version"
    "gitlab.galaxy123.cloud/base/public/core/logsx"
)

type ServiceContext struct {
	Config config.Config
	Ver    *version.Version
}

func NewServiceContext(c config.Config, ver *version.Version) *ServiceContext {
	// rdb := c.RedisConf.NewClusterClient()
	// db := dbx.MustDB(c.DataSource)
    logsx.MustSetUp(c.Log)
	return &ServiceContext{
		Config:c,
		Ver:    ver,
	}
}

// Close 资源回收
func (c *ServiceContext) Close() {
	// TODO
}
