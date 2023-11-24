

import (
	"{{.name}}/version.api"
)

@server(
	prefix : /oa/{{.name}}/v1
	group: base
)

service {{.name}} {
	@doc "获取服务版本信息"
	@handler GetVersion
	get /{{.name}}/version (VersionReq) returns (VersionRes)
}

type (
    VersionReq{}

    VersionRes {
        Server string `json:"server"`         // 服务名称
        BuildTime string `json:"build_time"`  // 编译时间
        CommitId string `json:"commit_id"`    // 最后提交CommitId
        Branch string `json:"branch"`         // 代码分支
        Listen string `json:"listen"`         // 监听地址
    }
)