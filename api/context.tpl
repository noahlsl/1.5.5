package svc

import (
	{{.configImport}}
    "github.com/noahlsl/public/models/version"
)

type ServiceContext struct {
	Config {{.config}}
	Ver        *version.Version
	{{.middleware}}
}

func NewServiceContext(c {{.config}}, ver *version.Version) *ServiceContext {
	return &ServiceContext{
		Config: c,
        Ver:        ver,
		{{.middlewareAssignment}}
	}
}

// Close 资源回收
func (c *ServiceContext) Close() {
}