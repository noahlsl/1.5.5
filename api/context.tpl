package svc

import (
	{{.configImport}}

	"gitlab.galaxy123.cloud/base/public/models/version"
	"gitlab.galaxy123.cloud/base/public/core/logsx"
	"gitlab.galaxy123.cloud/base/public/core/dbx"
	"gorm.io/gorm"
	//"gitlab.galaxy123.cloud/base/public/models/result"
)

type ServiceContext struct {
	Config {{.config}}
	Ver         *version.Version
	{{.middleware}}
    Rdb        *redis.Redis
    DB         *gorm.DB
}

func NewServiceContext(c {{.config}}, ver *version.Version) *ServiceContext {
    rdb := redis.MustNewRedis(c.RedisConf)
    db := ent.MustNewDB(c.DataSource, c.Log.Level)
	// result.SetReply(helper.NewErrManger())
	logsx.MustSetUp(c.Log)
	return &ServiceContext{
		Config: c,
		Ver:ver,
		{{.middlewareAssignment}}
        Rdb:        rdb,
        DB:         dbx.MustGDB(c.DataSource, c.Log.Level),
	}
}

// Close 资源回收
func (c *ServiceContext) Close() {
    if c.DB!=nil{
        _ = c.DB.Close()
    }
}
