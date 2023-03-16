# 基于哪个镜像构建
from    opensuse:my
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
run     tar -zxvf ${pkg_name}
# 容器健康检测指令
healthcheck --interval=5s --timeout=5s --retries=2 CMD ["netstat -anp | grep 8080 -q"]
# 暴露容器端口
expose 8008
# 大致用法同entrypoint，两者区别： https://www.cnblogs.com/sparkdev/p/8461576.html
# 运行容器执行的命令，其实就是docker run imageId COMMAND中的默认COMMAND
# 与entrypoint同时存在，则cmd只能作为参数
cmd     "tail -f /dev/null"
# 让容器以程序的形式运行，程序结束容器也就exit了
# 运行容器一定会执行的命令
entrypoint ["/opt/tomcat/apache-tomcat-10.1.7/bin/startup.sh"]