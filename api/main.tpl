package main

import (
	"flag"

	{{.importPackages}}
    "github.com/zeromicro/go-zero/core/logx"
	"gitlab.galaxy123.cloud/base/public/models/version"
)

var (
	serverName string // 服务名称
	buildTime  string // 编译时间
	commitId   string // 最新CommitId
	branch     string // 代码分支名称

	e = flag.String("e", "", "the etcd address")
	p = flag.String("p", "your-project", "the project name")
    v = flag.String("v", "dev", "the server env")
    s = flag.String("s", "{{.serviceName}}", "the server name")
)

func main() {
	flag.Parse()
    // 解析配置文件
	var c config.Config
    c.Parse(*e,*p,*v,*s)
    // 获取编译版本信息
    ver := version.NewVersion(serverName, buildTime, commitId, branch)
    // 创建服务
	server := rest.MustNewServer(c.RestConf)
	defer server.Stop()
   // 初始化服务依赖
	ctx := svc.NewServiceContext(c,ver)
	defer ctx.Close()
	handler.RegisterHandlers(server, ctx)

	logx.Infof("Starting server at %s:%d...\n", c.Host, c.Port)
	server.Start()
}
