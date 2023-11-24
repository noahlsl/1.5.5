package middleware

import (
	"net/http"

	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/core/stores/redis"
	"gitlab.galaxy123.cloud/base/public/constants/enums"
	"gitlab.galaxy123.cloud/base/public/core/logsx"
	"gitlab.galaxy123.cloud/base/public/middleware"
	"gitlab.galaxy123.cloud/base/public/models/result"
)


type {{.name}} struct {
	BeforeFns []func(w http.ResponseWriter, r *http.Request) error
	AfterFns  []func(w http.ResponseWriter, r *http.Request)
}

func New{{.name}}(r *redis.Redis, key string, args ...any) *{{.name}} {
	var (
		beforeFns []func(w http.ResponseWriter, r *http.Request) error
		afterFns  []func(w http.ResponseWriter, r *http.Request)
	)
	// 跨域处理中间件
	beforeFns = append(beforeFns, middleware.OriginalCorsMiddleware)

	// 请求参数获取中间件
	beforeFns = append(beforeFns, middleware.OriginalParamMiddleware)

	// Token 校验中间件 	key 是redis 的 token key
	tokenMiddleware := middleware.NewTokenMiddleware(r, key, args...)
	beforeFns = append(beforeFns, tokenMiddleware.OriginalHandle)

	// 请求参数打印中间件-限调试模式
	logMiddleware := middleware.NewLogMiddleware()
	beforeFns = append(beforeFns, logMiddleware.OriginalHandle)

	// 请求数据幂等性中间件 num 是请求的间隔时间(单位秒)
	idempotenceMiddleware := middleware.NewIdempotenceMiddleware(r, 2)
	beforeFns = append(beforeFns, idempotenceMiddleware.OriginalHandle)

	// 获取登录信息参数
	// baseMiddleware := middleware.NewBaseDataMiddleware(r, keys.RedisKeyAdminData)
	// beforeFns = append(beforeFns, baseMiddleware.OriginalHandle)
	return &{{.name}}{
		BeforeFns: beforeFns,
    	AfterFns:  afterFns,
	}
}

func (m *{{.name}})Handle(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		for _, fn := range m.BeforeFns {
			err := fn(w, r)
			if err != nil {
				logx.Errorw(err.Error(), logsx.GetFields(r)...)
				result.ResultErr(w, r, enums.ErrSysBadRequest, err)
				return
			}
		}

		next(w, r)

		for _, fn := range m.AfterFns {
			fn(w, r)
		}
	}
}
