# 安装Kubernetes参考资料

https://www.cnblogs.com/zengtaoyunwei/articles/15421076.html

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

| 命令                                                | 描述                       | 类型       | 备注                    |
| --------------------------------------------------- | -------------------------- | ---------- | ----------------------- |
| kubectl get cs                                      | 查看集群健康状态           | 系统       |                         |
| kubectl get events                                  | 查看k8s事件                | 系统       |                         |
| kubectl get namespaces                              | 查询所有命名空间           | 命名空间   |                         |
| kubectl create namespaces test                      | 创建命名空间               | 命名空间   |                         |
| kubectl delete namespaces test                      | 删除命名空间               | 命名空间   |                         |
| kubectl config set-context --current --namespace=NS | 设置首选命名空间           | 命名空间   |                         |
| kubectl get nodes                                   | 查看所有节点               | 节点       |                         |
| kubectl describe nodes NAME                         | 获取节点详细信息           | 节点       |                         |
| kubectl label nodes NAME key=value --overwrite     | 新增节点标签               | 节点       | --overwrite 覆盖设置    |
| kubectl label nodes NAME key-                       | 删除节点标签               | 节点       |                         |
| kubectl taint nodes NAME key:NoSchedule             | 新增节点污点               | 节点       | 类似打标签              |
| kubectl taint nodes NAME key=value:NoSchedule       | 新增节点污点               | 节点       | --overwrite 覆盖设置    |
| kubectl taint nodes NAME key-                       | 删除节点污点               | 节点       |                         |
| kubectl top nodes                                   | 查看资源使用情况           | 节点       | 需安装metric-server组件 |
| kubectl uncordon NODE_NAME                          | 封锁节点解除               | 节点       |                         |
| kubectl cordon NODE_NAME                            | 封锁节点不可调度           | 节点       | 同时新增一个污点        |
| kubectl get pods                                    | 查看所有pod                | pod        |                         |
| kubectl describe pods NAME                          | 获取pod详细信息            | pod        |                         |
| kubectl get pods NAME -o yaml                       | 查看pod的yaml信息          | pod        |                         |
| kubectl delete pods NAME                            | 删除pod                    | pod        |                         |
| kubectl exec POD_NAME -- env                        | 查看运行的pod的环境变量    | pod        |                         |
| kubectl get pods --show-labels                      | 显示pod标签                | pod        |                         |
| kubectl logs POD_NAME --tail 20                     | 显示pod日志（docker logs） | pod        | -f 实时监控             |
| kubectl top pods                                    | 查看资源使用情况           | pod        | 需安装metric-server组件 |
|                                                     | 新增pod标签                |            |                         |
| kubectl get deployment                              | 查看所有deployment         | deployment |                         |

## 格式化展示yaml配置

-o=custom-columns

```
kubectl get pods -o=custom-columns=\
name:.metadata.name,\
ns:.metadata.namespace,\
request-cpu:.spec.containers[0].resources.requests.cpu,\
limit-cpu:.spec.containers[0].resources.limits.cpu,\
request-memory:.spec.containers[0].resources.requests.memory,\
limit-memory:.spec.containers[0].resources.limits.memory,\
nodeName:.spec.nodeName,\
node:.spec.nodeName,\
affinity:.spec.affinity
```
