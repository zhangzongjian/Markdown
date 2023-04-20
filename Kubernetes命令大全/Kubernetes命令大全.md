# 安装Kubernetes参考资料

[https://www.cnblogs.com/zengtaoyunwei/articles/15421076.html](https://www.cnblogs.com/zengtaoyunwei/articles/15421076.html)

（其中9443端口应改为6443）

# 常用命令

通用操作：get create delete describe

对象类型：namespaces nodes pods

通用参数：

* -n NAMESPACES 指定命名空间
* -o wide 显示更多列信息
* -A 展示所有命名空间下的对象
* -w/--watch 监控资源变动
* --show-labels 显示标签
* -l label 根据标签过滤资源

| 命令                                                         | 描述                   | 类型   | 备注                            |
|------------------------------------------------------------|----------------------|------|-------------------------------|
| kubectl get cs                                             | 查看集群健康状态             | 系统   |                               |
| kubectl get events                                         | 查看k8s事件              | 系统   |                               |
| kubectl get namespaces                                     | 查询所有命名空间             | 命名空间 |                               |
| kubectl create namespaces test                             | 创建命名空间               | 命名空间 |                               |
| kubectl delete namespaces test                             | 删除命名空间               | 命名空间 |                               |
| kubectl config set-context --current --namespace=NS        | 设置首选命名空间             | 命名空间 |                               |
| kubectl get nodes                                          | 查看所有节点               | 节点   |                               |
| kubectl delete nodes NAME                                  | 删除节点                 | 节点   | 驱逐 + 移除管理，待验证                 |
| kubectl describe nodes NAME                                | 获取节点详细信息             | 节点   |                               |
| kubectl label nodes NAME key=value --overwrite             | 新增节点标签               | 节点   | --overwrite 覆盖设置              |
| kubectl label nodes NAME key-                              | 删除节点标签               | 节点   |                               |
| kubectl taint nodes NAME key=value:NoSchedule              | 新增节点污点               | 节点   | value可为空；NoSchedule 禁止新的Pod调度 |
| kubectl taint nodes NAME key=value:NoSchedule-             | 删除节点污点               | 节点   |                               |
| kubectl top nodes                                          | 查看资源使用情况             | 节点   | 需安装metric-server组件            |
| kubectl cordon NODE_NAME                                   | 封锁节点                 | 节点   | 不会再调度创建pod                    |
| kubectl drain NODE_NAME --ignore-daemonsets                | 驱逐节点                 | 节点   | 删除节点上的pod，到其他节点重新创建           |
| kubectl uncordon NODE_NAME                                 | 封锁节点解除               | 节点   | 驱逐也用这个解除                      |
| kubectl get pods                                           | 查看所有pod              | pod  |                               |
| kubectl describe pods NAME                                 | 获取pod详细信息            | pod  |                               |
| kubectl get pods NAME -o yaml                              | 查看pod的yaml信息         | pod  |                               |
| kubectl delete pods NAME                                   | 删除pod                | pod  |                               |
| kubectl get pods --show-labels                             | 显示pod标签              | pod  |                               |
| kubectl logs POD_NAME --tail 20                            | 显示pod日志（docker logs） | pod  | -f 实时监控                       |
| kubectl top pods                                           | 查看资源使用情况             | pod  | 需安装metric-server组件            |
| kubectl exec POD_NAME -- ls /tmp                           | 执行pod容器内命令           | pod  |                               |
| kubectl cp POD_NAME:PATH PATH                              | 复制pod容器内文件           | pod  | 类似docker cp                   |
| kubectl patch pods POD_NAME -p '{"spec": {"replicas": 3}}' | 通过补丁更新资源配置           | pod  |                               |

## 格式化展示yaml配置

-o=custom-columns

kubectl get pods -o=custom-columns=
name:.metadata.name,
ns:.metadata.namespace,
request-cpu:.spec.containers[0].resources.requests.cpu,
limit-cpu:.spec.containers[0].resources.limits.cpu,
request-memory:.spec.containers[0].resources.requests.memory,
limit-memory:.spec.containers[0].resources.limits.memory,
nodeName:.spec.nodeName,
node:.spec.nodeName,
affinity:.spec.affinity

# k8s 创建可视化管理面板 dashboard

[https://blog.51cto.com/u_15956038/6167800](https://blog.51cto.com/u_15956038/6167800)
