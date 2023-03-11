# 常用命令

| 命令                     | 描述           | 类型 | 备注 |
| ------------------------ | -------------- | ---- | ---- |
| systemctl daemon-reload  | 重载服务配置   | 服务 |      |
| systemctl restart docker | 重启docker服务 | 服务 |      |
| docker info              | 显示docker信息 | 服务 |      |

| 命令                                           | 描述               | 类型 | 备注                                       |
| ---------------------------------------------- | ------------------ | ---- | ------------------------------------------ |
| docker pull tomcat:10.0.7                      | 从仓库拉取镜像     | 镜像 |                                            |
| docker images                                  | 查看本地镜像       | 镜像 |                                            |
| docker rmi $imageId                            | 删除本地镜像       | 镜像 | -f --force 强制删除                        |
| docker save $iamgeId > image.tar              | 保持镜像至归档文件 | 镜像 |                                            |
| docker save $iamgeId&#124; gzip > image.tar.gz | 保持镜像至归档文件 | 镜像 | gzip 将归档文件压小一点                    |
| docker load < image.tar                        | 导入镜像归档文件   | 镜像 |                                            |
| docker export $containerId > image.tar        | 将容器导出镜像     | 镜像 | 丢失镜像的历史记录和元数据                 |
| docker import image.tar [repo:tag]            | 导入镜像归档文件   | 镜像 | 丢失镜像的历史记录和元数据，[]表示参数可选 |
| docker tag $imageId repo:tag                   | 给镜像打标签       | 镜像 | 创建别名                                   |
| docker rmi repo:tag                            | 删除标签           | 镜像 |                                            |
| docker build .                                 | 创建镜像           | 镜像 | 使用指定目录下的Dockerfile文件构建镜像     |
| docker inspect $imageId                        | 查看镜像元数据     | 镜像 |                                            |
| docker history $imageId                        | 查看镜像构建历史   | 镜像 | --no-trunc显示详细                         |

| 命令                                   | 描述         | 类型 | 备注                      |
| -------------------------------------- | ------------ | ---- | ------------------------- |
| docker ps                              | 查看容器列表 | 容器 | -a 列出所有，包括未运行的 |
| docker run -d [--name test] $imageId | 创建容器     | 容器 | -d 后台运行               |
| docker rm $containerId                 | 删除容器     | 容器 | -f --force 强制删除       |
|                                        |              |      |                           |
|                                        |              |      |                           |

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

# 构建镜像
