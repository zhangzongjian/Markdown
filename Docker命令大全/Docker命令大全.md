# 常用命令

| 命令                                           | 描述                 | 类型 | 备注                        |
| ---------------------------------------------- | -------------------- | ---- | --------------------------- |
| systemctl daemon-reload                        | 重载服务配置         | 服务 |                             |
| systemctl restart docker                       | 重启docker服务       | 服务 |                             |
| docker info                                    | 显示 Docker 系统信息 | 服务 |                             |
| docker pull tomcat:10.0.7                      | 拉取镜像             | 镜像 |                             |
| docker images                                  | 查看本地镜像         | 镜像 | -f 强制删除                 |
| docker save IMAGE_ID -o image.tar              | 保持镜像至归档文件   | 镜像 | -o 或者 重定向 指定归档文件 |
| `docker save IMAGE_ID \| gzip > image.tar.gz` | 保持镜像至归档文件   | 镜像 | gzip压缩让文件更小          |
|                                                |                      |      |                             |
|                                                |                      |      |                             |
|                                                |                      |      |                             |
|                                                |                      |      |                             |
|                                                |                      |      |                             |
|                                                |                      |      |                             |
|                                                |                      |      |                             |
|                                                |                      |      |                             |

# 设置仓库

```
{
    "registry-mirrors" : [
        "https://pee6w651.mirror.aliyuncs.com",
        "https://dockerhub.azk8s.cn",
        "https://hub-mirror.c.163.com"
    ]
}
```

设置后重启

`systemctl daemon-reload`

`systemctl restart docker`
