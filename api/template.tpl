syntax = "v1"

info (
	title: // TODO: add title
	desc: // TODO: add description
	author: "{{.gitUser}}"
	email: "{{.gitEmail}}"
)

type VersionRequest {
}

type VersionResponse {
    Server    string `json:"server"`     // 服务名称
    BuildTime string `json:"build_time"` // 编译时间
    CommitId  string `json:"commit_id"`  // 提交gitID
    Branch    string `json:"branch"`     // 代码分支
    Listen    string `json:"listen"`     // 监听的端口和地址
}

service {{.serviceName}} {
    @doc "get server version"
	@handler GetVersion // TODO: set handler name and delete this comment
	get /{{.serviceName}}/v1/version returns(VersionResponse)
}
