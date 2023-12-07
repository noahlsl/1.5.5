package svc

import (

	{{.imports}}
	"github.com/noahlsl/public/models/version"
    "github.com/noahlsl/public/core/logsx"
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
