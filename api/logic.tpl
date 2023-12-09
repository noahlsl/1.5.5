package {{.pkgName}}

import (
	{{.imports}}
	"github.com/noahlsl/public/helper/structx"
)

type {{.logic}} struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func New{{.logic}}(ctx context.Context, svcCtx *svc.ServiceContext) *{{.logic}} {
	return &{{.logic}}{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *{{.logic}}) {{.function}}({{.request}}) {{.responseType}} {
	key := fmt.Sprintf("%v:%v", "{{.function}}", structx.StructToStr(req))
	// 获取本地缓存
	cache, ok := l.svcCtx.Cache.Get(key)
	if ok {
		resp = cache.({{.responseType}})
		return resp, nil
	}
	// todo: add your logic here and delete this line

	// 重新设置缓存
	l.svcCtx.Cache.Set(key, resp, cache.DefaultExpiration)
	{{.returnString}}
}
