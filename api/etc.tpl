Name: {{.serviceName}}
Host: {{.host}}
Port: {{.port}}

Etcd:
  Hosts:
    - 127.0.0.1:2379

#监控
#Prometheus:
#  Host: 0.0.0.0
#  Port: 4008
#  Path: /metrics

#链路追踪
#Telemetry:
#  Name: {{.serviceName}}-api
#  Endpoint: http://jaeger:14268/api/traces
#  Sampler: 1.0
#  Batcher: jaeger

Log:
  ServiceName: {{.serviceName}}-api
  Level: debug
  Stat: false
  TimeFormat: 2006-01-02 15:04:05

RedisConf:
  Host: 127.0.0.1:6379
  Type: node
  Pass:


DataSource: root:123456@tcp(127.0.0.1:3306)/test?charset=utf8mb4&parseTime=true&loc=Asia%2FShanghai

# RPC示例
# 服务发现模式
#PmsRpc:
#  Etcd:
#    Hosts:
#      - localhost:2379
#    Key: pms.rpc

# 直连模式
#PmsRpc:
#  Endpoints:
#    - 127.0.0.1:2002
#  NonBlock: true