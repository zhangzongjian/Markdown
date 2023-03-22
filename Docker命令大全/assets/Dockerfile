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