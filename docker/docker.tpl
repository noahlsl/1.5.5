FROM golang:{{.Version}}alpine AS builder

LABEL stage=gobuilder

# 配置文件ETCD 地址
ENV ETCD_ADDRESS=''
# 程序运行环境
ENV SERVER_ENV=''

ENV CGO_ENABLED 0
{{if .Chinese}}ENV GOPROXY https://goproxy.cn,direct
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
{{end}}{{if .HasTimezone}}
RUN apk update --no-cache && apk add --no-cache tzdata
{{end}}
WORKDIR /build


# ADD go.mod .
# ADD go.sum .
# RUN go mod download
# 使用vendor模式解决外部依赖包问题
COPY . .
{{if .Argument}}COPY {{.GoRelPath}}/etc /app/etc
{{end}}RUN go build -ldflags="-s -w" -o /app/{{.ExeFile}} {{.GoMainFrom}}


FROM {{.BaseImage}}

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
{{if .HasTimezone}}COPY --from=builder /usr/share/zoneinfo/{{.Timezone}} /usr/share/zoneinfo/{{.Timezone}}
ENV TZ {{.Timezone}}
{{end}}
WORKDIR /app
COPY --from=builder /app/{{.ExeFile}} /app/{{.ExeFile}}{{if .Argument}}
COPY --from=builder /app/etc /app/etc{{end}}
{{if .HasPort}}
EXPOSE {{.Port}}
{{end}}
CMD ["./{{.ExeFile}}"{{.Argument}}, "-e", "$ETCD_ADDRESS", "-v", "$SERVER_ENV"]
