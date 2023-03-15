# 基于哪个镜像构建
from    ubuntu:12.04
# 设置环境变量
env     MY_HOME=/tmp/zzj
# Dockerfile内变量
arg     pkg_name=apache-tomcat-10.1.7.tar.gz
# 设置容器到宿主机的挂载目录
# 避免重要的数据，因容器重启而丢失，这是非常致命的
# 效果同 docker run -it -v container_path:host_path -v container_path:host_path f33e50c05326
volume  /tmp/zzj:/zzj
# 切换目录，目录不存在自动创建
workdir /opt/tomcat
# 拷贝文件到容器
copy    ${pkg_name} /opt/tomcat
# 构建镜像执行的命令
run    tar -zxvf ${pkg_name}

healthcheck netstat -anp | grep 8080 -q

CMD- 容器启动的命令，如果有多个则以最后一个为准，也可以为ENTRYPOINT提供参数
HEALTHCHECH- 健康检测指令
ARG- 变量属性值，但不在容器内部起作用
EXPOSE- 暴露端口
ADD- 添加文件，如果是压缩文件也解压
COPY- 添加文件，以复制的形式
ENTRYPOINT- 容器进入时执行的命令