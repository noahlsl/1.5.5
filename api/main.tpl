package main

import (
	"flag"
	"fmt"

	{{.importPackages}}
    "github.com/noahlsl/public/middleware"
    "github.com/noahlsl/public/models/version"
)

var e = flag.String("e", "", "the etcd address")

func main() {
	flag.Parse()

	var c config.Config
	conf.MustLoad(*configFile, &e)
    // 获取编译版本信息
    ver := version.NewVersion(serverName, buildTime, commitId, branch)

	server := rest.MustNewServer(c.RestConf, rest.WithCors())
	server.Use(middleware.BaseCtxMiddleware)
	defer server.Stop()

	ctx := svc.NewServiceContext(c, ver)
	defer ctx.Close()
	handler.RegisterHandlers(server, ctx)

	fmt.Printf("Starting server at %s:%d...\n", c.Host, c.Port)
	server.Start()
}
