package svc

import (
	{{.configImport}}

	"github.com/noahlsl/public/models/version"
	"github.com/noahlsl/public/core/logsx"
	"github.com/noahlsl/public/core/dbx"
	"gorm.io/gorm"
	//"github.com/noahlsl/public/models/result"
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
