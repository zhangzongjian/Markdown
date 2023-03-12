# 常用命令

| 命令                     | 描述           | 类型 | 备注 |
| ------------------------ | -------------- | ---- | ---- |
| systemctl daemon-reload  | 重载服务配置   | 服务 |      |
| systemctl restart docker | 重启docker服务 | 服务 |      |
| docker info              | 显示docker信息 | 服务 |      |

| 命令                                           | 描述               | 类型 | 备注                            |
| ---------------------------------------------- | ------------------ | ---- | ------------------------------- |
| docker pull tomcat:10.0.7                      | 从仓库拉取镜像     | 镜像 | 类似git的pull/commit/push       |
| docker images                                  | 查看本地镜像列表   | 镜像 |                                 |
| docker rmi $imageId                            | 删除本地镜像       | 镜像 | -f --force 强制删除             |
| docker save $iamgeId > image.tar              | 保持镜像至归档文件 | 镜像 | 含镜像历史记录和元数据（含tag） |
| docker save $iamgeId&#124; gzip > image.tar.gz | 保持镜像至归档文件 | 镜像 | gzip 将归档文件压小一点         |
| docker load < image.tar                        | 导入镜像归档文件   | 镜像 | 含镜像历史记录和元数据（含tag） |
| docker tag $imageId repo:tag                   | 给镜像打标签       | 镜像 | 创建别名                        |
| docker rmi repo:tag                            | 删除标签           | 镜像 |                                 |
| docker build .                                 | 构建镜像           | 镜像 | 使用Dockerfile文件构建镜像      |
| docker inspect $imageId                        | 查看镜像元数据     | 镜像 |                                 |
| docker history $imageId                        | 查看镜像构建历史   | 镜像 | --no-trunc显示详细              |

| 命令                                         | 描述                     | 类型 | 备注                                                |
| -------------------------------------------- | ------------------------ | ---- | --------------------------------------------------- |
| docker ps                                    | 查看容器列表             | 容器 | -a 列出所有，包括未运行的                           |
| docker run -itd [--name test] $imageId     | 创建容器，后台运行       | 容器 | -d 后台运行，类似命令&执行；-it 类似nohup退出就停了 |
| docker rm $containerId                       | 删除容器                 | 容器 | -f --force 强制删除                                 |
| docker kill $containerId                     | 杀掉容器进程             | 容器 | 同stop，容器id还在                                  |
| docker exec -it $containerId bash            | 进入容器                 | 容器 | 也可指定容器name进入                                |
| docker exec -it $containerId COMMAND         | 执行容器内的命令         | 容器 |                                                     |
| docker stop/start/restart $containerId       | 启停容器                 | 容器 |                                                     |
| docker attach $containerId                   | 容器前台运行             | 容器 | 同Linux的fg命令                                     |
| docker events                                | 查看容器事件             | 容器 | docker events实时监听；精确到秒得用timestamp        |
| docker events --since="2022-03-12"           | 查看容器事件             | 容器 | date -d @1678562863 时间戳转格式                    |
| docker events --filter image=$imageId        | 查看容器事件             | 容器 | date -d "2010-07-20 10:25:30" +%s 转时间戳          |
| docker logs $containerId [--tail 100]       | 查看容器日志             | 容器 | -f 同Linux的tailf                                   |
| docker port $containerId                     | 查看容器的端口映射表     | 容器 | 宿主机netstat也能查看端口，但是看不到是哪个容器的   |
| docker stats $containerId                    | 查看容器资源使用情况     | 容器 | CPU MEM IO                                          |
| docker top $containerId                      | 查看容器进程             | 容器 | PID                                                 |
| docker commit $containerId [repo:tag]      | 将容器更改保存至新镜像   | 容器 | -c Dockerfile                                       |
| docker cp $containerId:PATH PATH             | 容器与宿主机之间拷贝文件 | 容器 | 同Linux的scp，可双向                                |
| docker diff $containerId                     | 查看容器里文件结构的更改 | 容器 | 就是对比刚从镜像创建时和当前的文件变化              |
| docker inspect $containerId                  | 查看容器元数据           | 容器 |                                                     |
| docker export $containerId > filesystem.tar | 导出容器文件系统         | 容器 | 保存至归档文件，应用场景：制作基础镜像              |
| docker import filesystem.tar [repo:tag]     | 导入归档文件至新镜像     | 容器 | 和export配套使用                                    |
| docker rename old_name new_name             | 容器重命名               | 容器 |                                                     |

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

## Dockerfile

docker build

docker save

docker export

docker commit
