# 基于哪个镜像构建
from    opensuse:my
# 设置环境变量
env     JAVA_HOME=/opt/jdk-11
env     PATH=$JAVA_HOME/bin:$PATH
# Dockerfile内变量
arg     tomcat_pkg=apache-tomcat-10.1.7.tar.gz
arg     jdk_pkg=jdk-11_linux-x64_bin.tar.gz
# 设置容器到宿主机的挂载目录
# 避免重要的数据，因容器重启而丢失，这是非常致命的
# 效果同 docker run -it -v container_path:host_path -v container_path:host_path f33e50c05326
volume  "/tmp/zzj" "/zzj"
# 拷贝文件到容器
copy    ${tomcat_pkg} /opt
copy    ${jdk_pkg} /opt
# 构建镜像执行的命令，Dockerfile指令越多镜像层数越多，尽量一条run
run     cd /opt ; tar -zxvf ${tomcat_pkg} >/dev/null ; rm ${tomcat_pkg} ; \
        cd /opt && tar -zxvf ${jdk_pkg} >/dev/null ; rm ${jdk_pkg}
# 容器健康检测指令
healthcheck --interval=5s --timeout=5s --retries=2 CMD ["netstat -anp | grep 8080 -q"]
# 暴露容器端口
expose 8080
# 切换容器的工作目录
workdir /opt/apache-tomcat-10.1.7
# 大致用法同entrypoint，两者区别： https://www.cnblogs.com/sparkdev/p/8461576.html
# 运行容器执行的命令，其实就是docker run imageId COMMAND中的默认COMMAND
# 与entrypoint同时存在，则cmd只能作为参数
#cmd     "/opt/apache-tomcat-10.1.7/bin/startup.sh"
# 让容器以程序的形式运行，程序结束容器也就exit了
# 运行容器一定会执行的命令
entrypoint ["/bin/bash"]