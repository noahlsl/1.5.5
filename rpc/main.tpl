package main

import (
	"flag"

	{{.imports}}

	"github.com/zeromicro/go-zero/core/service"
	"github.com/zeromicro/go-zero/zrpc"
	"github.com/zeromicro/go-zero/core/logx"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
    "gitlab.galaxy123.cloud/base/public/models/version"
)

var (
	serverName string // 服务名称
	buildTime  string // 编译时间
	commitId   string // 最新CommitId
	branch     string // 代码分支名称

    f = flag.String("f", "etc/{{.serviceName}}.yaml", "the config file")
	e = flag.String("e", "", "the etcd address")
	p = flag.String("p", "ebet", "the project name")
    v = flag.String("v", "dev", "the server env")
    s = flag.String("s", "{{.serviceName}}", "the server name")
)

func main() {
	flag.Parse()
    // 解析配置文件
	var c config.Config
    c.Parse(*f,*e,*p,*v,*s)
    // 获取编译版本信息
    ver := version.NewVersion(serverName, buildTime, commitId, branch)
    // 初始化依赖
	ctx := svc.NewServiceContext(c,ver)
    defer ctx.Close()
	s := zrpc.MustNewServer(c.RpcServerConf, func(grpcServer *grpc.Server) {
{{range .serviceNames}}       {{.Pkg}}.Register{{.Service}}Server(grpcServer, {{.ServerPkg}}.New{{.Service}}Server(ctx))
{{end}}
		if c.Mode == service.DevMode || c.Mode == service.TestMode {
			reflection.Register(grpcServer)
		}
	})
	defer s.Stop()

	logx.Infof("Starting rpc server at %s...\n", c.ListenOn)
	s.Start()
}
