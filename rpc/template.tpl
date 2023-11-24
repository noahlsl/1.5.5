syntax = "proto3";

package {{.package}};
option go_package="./{{.package}}";

message VersionRequest {

}

message VersionResponse {
  string ServerName = 1;// 服务名称
  string BuildTime = 2;// 编译时间
  string CommitId = 3;// 提交gitID
  string Branch = 4;// 代码分支
  string Listen = 5;// 监听的端口和地址
}

service {{.serviceName}} {
  rpc GetVersion(VersionRequest) returns(VersionResponse);
}
