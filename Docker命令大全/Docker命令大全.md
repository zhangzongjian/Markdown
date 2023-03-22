# 常用命令

| 命令                                           | 描述          | 类型  | 备注                                     |
|----------------------------------------------|-------------|-----|----------------------------------------|
| systemctl daemon-reload                      | 重载服务配置      | 服务  |                                        |
| systemctl restart docker                     | 重启docker服务  | 服务  |                                        |
| systemctl enable docker.service              | 开机自启动       | 服务  |                                        |
| docker system info                           | 显示docker信息  | 服务  |                                        |
| docker system df                             | docker磁盘使用率 | 服务  |                                        |
| docker system events                         | 查看docker事件  | 服务  | docker events实时监听；精确到秒得用timestamp      |
| docker system events --since="2022-03-12"    | 查看docker事件  | 服务  | date -d @1678562863 时间戳转格式             |
| docker system events --filter image=$imageId | 查看docker事件  | 服务  | date -d "2010-07-20 10:25:30" +%s 转时间戳 |
| docker system prune                          | docker空间清理  | 服务  | 慎用                                     |

| 命令                                             | 描述                 | 类型  | 备注                     |
|------------------------------------------------|--------------------|-----|------------------------|
| docker pull tomcat:10.0.7                      | 从仓库拉取镜像            | 镜像  | 类似git的pull/commit/push |
| docker images                                  | 查看本地镜像仓库           | 镜像  |                        |
| docker rmi $imageId                            | 删除本地镜像             | 镜像  | -f --force 强制删除        |
| docker save $iamgeId > image.tar               | 保持镜像至归档文件          | 镜像  | 含镜像历史记录和元数据（含tag）      |
| docker save $iamgeId&#124; gzip > image.tar.gz | 保持镜像至归档文件          | 镜像  | gzip 将归档文件压小一点         |
| docker load < image.tar                        | 导入镜像归档文件           | 镜像  | 含镜像历史记录和元数据（含tag）      |
| docker tag $imageId repo:tag                   | 给镜像打标签             | 镜像  | 创建别名                   |
| docker rmi repo:tag                            | 删除标签               | 镜像  | 如果镜像只有一个标签，则删除镜像       |
| docker build . [-t repo:tag]                   | 构建镜像               | 镜像  | 使用Dockerfile文件构建镜像     |
| docker inspect $imageId                        | 查看镜像元数据            | 镜像  |                        |
| docker history $imageId                        | 查看镜像构建历史           | 镜像  | --no-trunc显示详细         |
| docker image prune                             | 清理&#60;none&#62;镜像 | 镜像  | 无标签且没被使用的镜像            |

| 命令                                          | 描述           | 类型  | 备注                             |
|---------------------------------------------|--------------|-----|--------------------------------|
| docker ps                                   | 查看容器列表       | 容器  | -a 列出所有，包括未运行的                 |
| docker run -itd [--name test] $imageId      | 创建容器，并后台运行   | 容器  | $imageId放最后，--net=host与宿主机共享ip |
| docker rm $containerId                      | 删除容器         | 容器  | -f --force 强制删除                |
| docker kill $containerId                    | 杀掉容器进程       | 容器  | 同stop，容器id还在                   |
| docker exec -it $containerId bash           | 进入容器         | 容器  | 也可指定容器name进入                   |
| docker exec -it $containerId COMMAND        | 执行容器内的命令     | 容器  |                                |
| docker stop/start/restart $containerId      | 启停容器         | 容器  |                                |
| docker attach $containerId                  | 容器前台运行       | 容器  | 同Linux的fg命令                    |
| docker logs $containerId [--tail 100]       | 查看容器日志       | 容器  | -f 同Linux的tailf                |
| docker port $containerId                    | 查看容器的端口映射表   | 容器  | 宿主机netstat也能查看端口，但是看不到是哪个容器的   |
| docker stats $containerId                   | 查看容器资源使用情况   | 容器  | CPU MEM IO                     |
| docker top $containerId                     | 查看容器进程       | 容器  | PID                            |
| docker commit $containerId [repo:tag]       | 将容器更改保存至新镜像  | 容器  | -c Dockerfile                  |
| docker cp $containerId:PATH PATH            | 容器与宿主机之间拷贝文件 | 容器  | 同Linux的scp，可双向                 |
| docker diff $containerId                    | 查看容器里文件结构的更改 | 容器  | 就是对比刚从镜像创建时和当前的文件变化            |
| docker inspect $containerId                 | 查看容器元数据      | 容器  |                                |
| docker export $containerId > filesystem.tar | 导出容器文件系统     | 容器  | 保存至归档文件，保存容器快照                 |
| docker import filesystem.tar [repo:tag]     | 导入归档文件至新镜像   | 容器  | 和export配套使用                    |
| docker rename old_name new_name             | 容器重命名        | 容器  |                                |
| docker container prune                      | 清理stop状态容器   | 容器  |                                |

# 设置仓库

`/etc/docker/daemon.json`

```
{
  "registry-mirrors" : [
    "https://pee6w651.mirror.aliyuncs.com",
    "https://dockerhub.azk8s.cn",
    "https://hub-mirror.c.163.com"
  ],
  "insecure-registries" : [
    "192.168.1.7:5000",
    "192.168.1.7:80"
  ]
}
```

registry-mirrors 远程仓库拉取地址 pull

insecure-registries 声明非安全(http)私有仓库（pull/push `服务器IP:端口/镜像名称:版本号`）

设置后重启 `systemctl daemon-reload; systemctl restart docker`

## 安装私有仓库

[参考资料] [https://blog.csdn.net/mw5258/article/details/126291484](https://blog.csdn.net/mw5258/article/details/126291484)

### 官方镜像Registry方式（简陋）

`docker pull docker.io/registry` 下载registry镜像

```
# 启动私有仓库容器
docker rm registry --force 2>/dev/null
docker run -d --name=registry --net=host registry:latest
```

`docker exec -it registry sh` 进入容器

`/etc/docker/registry/config.yml` 配置文件

`/var/lib/registry` 默认存储目录

### docker-distribution方式（简陋）

```
wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/docker-distribution-2.6.2-2.git48294d9.el7.x86_64.rpm
rpm -ivh docker-distribution-2.6.2-2.git48294d9.el7.x86_64.rpm
```

`systemctl start docker-distribution.service` 启动私有仓库服务

`/etc/docker-distribution/registry/config.yml` 配置文件

`/var/lib/registry` 默认存储目录

### Harbor服务器（WEB管理）

#### 安装docker-compose

Harbor是使用docker-compose来管理的

```
wget https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.21.2/docker-compose-Linux-x86_64 -O /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

#### 安装harbor

```
wget https://storage.googleapis.com/harbor-releases/release-2.4.0/harbor-offline-installer-v2.4.3.tgz
tar -xzvf harbor-offline-installer-v2.4.3.tgz -C /usr/local/
cd /usr/local/harbor
sed '/^ *#/d' harbor.yml.tmpl | sed '/https/,/private_key/d'  > harbor.yml  # https配置干掉
# hostname: 192.168.1.7 # 设置服务IP
./install.sh
```

#### 访问web前台

http://192.168.1.7  admin/Harbor12345

#### 重启harbor

`cd /usr/local/harbor; docker-compose stop; docker-compose start`

docker修改配置重启后，harbor系列容器会挂掉，需要重启harbor

#### 推送镜像须知

* http记得设置 `/etc/docker/daemon.json` insecure-registries
* 需要先登录 `docker login -u admin -p Harbor12345 http://192.168.1.7`

    * 登录会话存放在 `/root/.docker/config.json`
* 需要带上项目名称 `docker push 192.168.1.7/library/opensuse:tomcat`

    * harbor前台创建项目，library是harbor默认的项目

#### Harbor API

http://192.168.1.7/devcenter-api-2.0

### 查看私有仓库

`curl http://192.168.1.7:5000/v2/_catalog`

`curl -u 'admin:Harbor12345' http://192.168.1.7/v2/_catalog`

`curl http://192.168.1.7:5000/v2/{repository}/tags/list`

## 推送镜像

本地镜像标签格式: `服务器IP:端口/镜像名称:版本号`

docker push `服务器IP:端口/镜像名称:版本号`

http推送会根据 `服务器IP:端口` 匹配是否配置了insecure-registries，否则会出现以下错误：

```
The push refers to repository [192.168.1.7:5000/opensuse]
Get "https://192.168.1.7:5000/v2/": http: server gave HTTP response to HTTPS client
```

# 数据管理/挂载目录

[参考资料] [https://michaelyou.github.io/2017/09/17/Docker%E6%95%B0%E6%8D%AE%E7%AE%A1%E7%90%86-Volume%EF%BC%8C-bind-mount%E5%92%8Ctmpfs-mount/](https://michaelyou.github.io/2017/09/17/Docker%E6%95%B0%E6%8D%AE%E7%AE%A1%E7%90%86-Volume%EF%BC%8C-bind-mount%E5%92%8Ctmpfs-mount/)

![typesofmounts.png](assets/types-of-mounts.png)

挂载的目录，容器内外读写同步，多容器数据共享

`docker inspect $containerId | sed -n '/Mounts/,/]/ p'` 查看容器挂载情况

## volume

挂载到宿主机docker管理的卷路径目录 `/var/lib/docker/volumes/`

`docker volume prune` 清理卷路径下无容器关联的卷

`docker run -itd -v /home/container -v tomcat_date:/home/container1 --rm opensuse:tomcat` 匿名卷，指名卷

--rm 容器停止后自动删除容器(含匿名卷)
--volumes-from otherContainer 共享其他容器的挂载目录

```
"Mounts": [
            {
                "Type": "volume",
                "Name": "78cac3923a5e0f55bd7996b57664c6018643256f34063a36c36486f6c021bc8f",
                "Source": "/var/lib/docker/volumes/78cac3923a5e0f55bd7996b57664c6018643256f34063a36c36486f6c021bc8f/_data",
                "Destination": "/home/container",
                "Driver": "local",
                "Mode": "",
                "RW": true,
                "Propagation": ""
            },
            {
                "Type": "volume",
                "Name": "tomcat_data",
                "Source": "/var/lib/docker/volumes/tomcat_data/_data",
                "Destination": "/home/container1",
                "Driver": "local",
                "Mode": "z",
                "RW": true,
                "Propagation": ""
            },

]
```

## bind mount

挂载到宿主机任意目录

`docker run -itd -v /home/host:/home/container -v /home/host1:/home/container1 opensuse:tomcat`

```
"Mounts": [
            {
                "Type": "bind",
                "Source": "/home/host",
                "Destination": "/home/container",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            },
            {
                "Type": "bind",
                "Source": "/home/host1",
                "Destination": "/home/container1",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            }
]
```

mount方式目录映射注意事项：

- 目录不存在自动创建
- 映射以宿主机为主映射进去，容器内目录会被重写
- 宿主机目录不存在，容器内目录会被重写为空
- 映射文件，容器内目录不会被重写

如果我们想要将容器目录映射出去呢？

- volume匿名卷（缺点：不能指定宿主机路径）
- 构建镜像时将容器内目录压缩，容器启动再解压回去，之后目录就是同步的

# 网络管理

```
localhost:/tmp/zzj # docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
e26ae0795173   bridge    bridge    local
1ae0e00c07e2   host      host      local
1e223ca5e95d   none      null      local
```

## bridge

每个容器都独立网卡，且容器间互通，宿主机与容器互通。

创建容器需要设置端口映射 `-p 宿主端口：容器端口` 才能外部访问

```
localhost:~ #docker run -itd -p 8080:8080 --net=bridge opensuse:tomcat
localhost:~ # netstat -anp | grep 8080
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      5925/docker-proxy
tcp6       0      0 :::8080                 :::*                    LISTEN      5931/docker-proxy
```

## host

共享宿主机ip，此模式下端口映射被废弃，且宿主机能看到容器内进程

```
localhost:~ #docker run -itd --net=host opensuse:tomcat
localhost:~ # netstat -anp | grep 8080
tcp6       0      0 :::8080                 :::*                    LISTEN      8580/java
```

# 查看镜像内容

镜像包都是镜像分层的压缩文件

```
localhost:/tmp/zzj # tar -tvf opensuse_tomcat_images.tar | head -5
drwxr-xr-x 0/0               0 2023-03-18 02:17 1b17d833eb1a70546b6120986aecab7ff8437f8f81e900196418a9925bbf4c9a/
-rw-r--r-- 0/0               3 2023-03-18 02:17 1b17d833eb1a70546b6120986aecab7ff8437f8f81e900196418a9925bbf4c9a/VERSION
-rw-r--r-- 0/0             482 2023-03-18 02:17 1b17d833eb1a70546b6120986aecab7ff8437f8f81e900196418a9925bbf4c9a/json
-rw-r--r-- 0/0        12447744 2023-03-18 02:17 1b17d833eb1a70546b6120986aecab7ff8437f8f81e900196418a9925bbf4c9a/layer.tar
drwxr-xr-x 0/0               0 2023-03-18 02:17 2ab7f0cb0d8df50a4786b8741ead5cdc83c64e8bd5521a7e178bec2380c5d0ab/
```

其实我们想看的是镜像文件系统，可以先创建容器，然后导出容器。vim即可查看内容

```
localhost:/tmp/zzj # tar -tvf filesystem.tar | head -5
-rwxr-xr-x 0/0               0 2023-03-21 00:03 .dockerenv
drwxr-xr-x 0/0               0 2023-03-17 02:17 bin/
lrwxrwxrwx 0/0               0 2019-05-29 02:00 bin/arch -> /usr/bin/arch
lrwxrwxrwx 0/0               0 2019-05-29 02:00 bin/awk -> /etc/alternatives/awk
lrwxrwxrwx 0/0               0 2019-05-29 02:00 bin/basename -> /usr/bin/basename
```

# 构建镜像

## Dockerfile

docker build 构建镜像专用文件，固定文件名

`docker cp + docker exec + docker commit 也能达到Dockerfile效果，但是效率低，而且需要启动容器（对比效果，以及镜像大小）`

```
# 基于哪个镜像构建，会自动下载镜像
from    opensuse:my
# 设置环境变量
env     JAVA_HOME=/opt/jdk-11
env     PATH=$JAVA_HOME/bin:$PATH
# Dockerfile内变量
arg     tomcat_pkg=apache-tomcat-10.1.7.tar.gz
arg     jdk_pkg=jdk-11_linux-x64_bin.tar.gz
# 设置需要挂载的容器目录，只能挂匿名卷
volume  ["/home/container", "/home/container1"]
# 拷贝文件到容器
copy    ${tomcat_pkg} /opt
copy    ${jdk_pkg} /opt
# 构建镜像执行的命令，Dockerfile指令越多镜像层数越多，尽量一条run
run     cd /opt ; tar -zxvf ${tomcat_pkg} >/dev/null ; rm ${tomcat_pkg} ; \
        cd /opt && tar -zxvf ${jdk_pkg} >/dev/null ; rm ${jdk_pkg}
# 容器健康检测指令，容器内执行
healthcheck --interval=5s --timeout=5s --retries=2 CMD ["/bin/bash", "-c", "netstat -anp | grep 8080"]
# 进入容器后自动cd到该目录
workdir /opt/apache-tomcat-10.1.7/bin
# 大致用法同entrypoint，两者区别： https://www.cnblogs.com/sparkdev/p/8461576.html
# 与entrypoint同时存在，则cmd只能作为entrypoint的参数
#cmd     ["/bin/bash", "-c", "/opt/apache-tomcat-10.1.7/bin/startup.sh; tail -f /dev/null"]
# 让容器以程序的形式运行，程序结束容器也就exit了
entrypoint ["/bin/bash", "-c", "/opt/apache-tomcat-10.1.7/bin/startup.sh; tail -f /dev/null"]
```

## docker build

使用Dockerfile构建镜像

可以理解为：指定镜像创建容器，执行一系列指令，最后commit将容器保存为镜像，执行完删除容器

## docker save/load

save 保存本地镜像到归档文件

load 镜像归档文件到本地镜像

## docker export/import

export 导出容器文件系统到归档文件，保存容器快照

import 导入归档文件到本地镜像

## docker commit

将容器保存为镜像，并存入本地镜像，保存容器快照

# Docker Compose

Compose 是用于定义和运行多容器 Docker 应用程序的工具。通过 Compose，您可以使用 YML 文件来配置应用程序需要的所有服务。然后，使用一个命令，就可以从
YML 文件配置中创建并启动所有服务。

（其实就是yml配置的方式管理 `docker run` 各种原生命令及参数，而且具备管理多容器、容器依赖关系等功能）

```
wget https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.21.2/docker-compose-Linux-x86_64 -O /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

## 使用示例：

教程及配置参考 [https://www.runoob.com/docker/docker-compose.html](https://www.runoob.com/docker/docker-compose.html)

`docker-compose.yml` 同目录下执行compose命令

`docker-compose up -d` 创建并启动容器，-d 后台运行

`docker-compose down` 停止并移除容器

`docker-compose start` 启动服务

`docker-compose stop` 停止服务

```
version: '2.3'
services:
  tomcat:
    image: opensuse:tomcat
    container_name: opensuse_tomcat
    volumes:
      - type: bind # 目录不存在报错
        source: /home/test/host
        target: /home/test/container
    network_mode: host
```
