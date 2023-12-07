package {{.PkgName}}

import (
    "context"
	"net/http"

    {{.ImportPackages}}

	"github.com/noahlsl/public/constants/enums"
	"github.com/noahlsl/public/core/logsx"
    "github.com/noahlsl/public/models/result"
    "github.com/zeromicro/go-zero/core/logx"
    {{if .HasRequest}}
	"github.com/zeromicro/go-zero/rest/httpx"
	{{end}}
)

func {{.HandlerName}}(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
	    ctx := context.WithValue(r.Context(), "base", r.Header.Get("base"))
		{{if .HasRequest}}var req types.{{.RequestType}}
		if err := httpx.Parse(r, &req); err != nil {
            logx.WithContext(ctx).Errorw(err.Error(), logsx.GetFields(r)...)
            result.ResultErr(w, r, enums.ErrSysBadRequest, err)
			return
		}

		{{end}}l := {{.LogicName}}.New{{.LogicType}}(ctx, svcCtx)
		{{if .HasResp}}resp, {{end}}err := l.{{.Call}}({{if .HasRequest}}&req{{end}})
		if err != nil {
            logx.WithContext(ctx).Errorw(err.Error(), logsx.GetFields(r)...)
            result.ResultErr(w, r, enums.ErrSysBadRequest, err)
            return
		}

        {{if .HasResp}} result.Result(w, r, resp)
        {{else}}
        result.Result(w, r, nil)
        {{end}}
	}
}
