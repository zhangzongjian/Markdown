## man

man可以查询命令的Linux内置文档

> man ls

[TOC]

## ls

列出当前目录下所有文件

[ls.man](assets%2Fls.man)

| 参数  | 描述        | 样例  | 样例说明 |
|-----|-----------|-----|------|
| -l  | 详细文件信息    |     |      |
| -t  | 修改时间排序    |     |      |
| -r  | 倒序排列      |     |      |
| -h  | 可读的文件大小单位 |     |      |
| -a  | 显示隐藏文件    |     |      |

常用用法

> ls -ltr

## zip

压缩.zip .jar .war文件  
（保留文件权限，不保留文件属组）

| 参数  | 描述      | 样例                                  | 样例说明                         |
|-----|---------|-------------------------------------|------------------------------|
| -r  | 压缩文件夹   | zip -r tmp.zip test_dir             | 往压缩包追加目录/文件                  |
|     | 压缩文件    | zip tmp.zip test_file               | 往压缩包追加文件                     |
| -d  | 删除包内文件  | zip tmp.zip -d test_dir/* test_dir/ | 删除目录内文件及目录本身，星号表示模糊匹配包中的多个条目 |
| -m  | 移动到压缩包中 | zip -r tmp.zip test_dir -m          | 即压缩后删除源文件                    |
| -y  | 保留软链接   | zip -y tmp.zip link_file            | 软链接原样压缩，默认压缩软链接指向的源文件        |

## unzip

解压.zip .jar .war文件

| 参数  | 描述         | 样例                                 | 样例说明                   |
|-----|------------|------------------------------------|------------------------|
| -l  | 查看压缩包文件列表  | unzip -l tmp.zip                   | 每行一个条目，压缩或者解压单个都是针对条目的 |
| -d  | 解压到指定目录    | unzip tmp.zip -d test_dir          | 目录不存在则自动创建             |
| -o  | 默认覆盖解压     | unzip -o tmp.zip                   | 直接覆盖已存在文件，不询问          |
| -p  | 查看压缩包的文件内容 | unzip -p tmp.zip                   | 包内所有文件打印到控制台           |
|     |            | unzip -p tmp.zip test_dir/test.txt | 打印单个文件到控制台             |
|     |            | unzip tmp.zip test_dir/test.txt    | 解压单个文件，保留目录结构          |
|     |            | unzip tmp.zip test_dir/*           | 解压单个目录                 |

## tar

压缩解压.tar .tar.gz文件。后者其实是tar+gzip两重压缩的产物  
（保留文件权限和属组）

[tar.man](assets%2Ftar.man)

| 参数             | 描述                | 样例                                     | 样例说明                  |
|----------------|-------------------|----------------------------------------|-----------------------|
| -c             | 压缩                | tar -czvf tmp.tar.gz test_dir          | 压缩为.tar.gz文件          |
| -x             | 解压                | tar -xzvf tmp.tar.gz test_dir/test.txt | 解压单个文件，保留目录结构         |
| -z             | 执行gzip压缩/解压       |                                        |                       |
| -v             | 显示执行过程详细          |                                        |                       |
| -f             | 指定压缩文件            |                                        | 该参数后面得接文件，所以参数顺序放最后   |
| -C             | 解压到指定目录，目录不存在则报错  | tar -xzvf tmp.tar.gz -C test_dir       | 解压.tar.gz文件到指定目录      |
| -t             | 查看压缩包文件列表         | tar -tvf tmp.tar.gz                    | 查看压缩包中的文件列表           |
| -O             | 查看压缩包的文件内容        | tar -xOf tmp.tar.gz                    | 打印单个文件到控制台            |
| -r             | 往压缩包追加文件(仅.tar有效) | tar -f tmp.tar -r test_dir             | 多次执行包内会出现重复记录，可先删后加   |
| --delete       | 删除包内文件(仅.tar有效)   | tar -f tmp.tar --delete test_dir       | 结合gzip可实现删除.tar.gz内文件 |
| --remove-files | 移动到压缩包中           | 加在压缩命令后面即可                             | 即压缩后删除源文件             |
| --wildcards    | 开启模糊匹配模式          | tar --wildcards -xzvf tmp.tar.gz\*.txt | zip命令默认是开启模糊的         |

常用用法

## gzip

压缩解压.gz文件
（只能压缩单个文件，效果就是改文件名后面加.gz后缀，实际上是有压缩效果的）

[gzip.man](assets%2Fgzip.man)

| 参数  | 描述  | 样例                 | 样例说明           |
|-----|-----|--------------------|----------------|
|     | 压缩  | gzip tmp.log       | 效果就是文件名加上.gz后缀 |
| -d  | 解压  | gzip -d tmp.log.gz | 效果就是文件名去掉.gz后缀 |

## 模板

| 参数  | 描述  | 样例  | 样例说明 |
|-----|-----|-----|------|
|     |     |     |      |
|     |     |     |      |
|     |     |     |      |
|     |     |     |      |

常用用法
