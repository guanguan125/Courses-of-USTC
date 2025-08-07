# Courses-of-USTC

This repository is for helping students who are learning EIE in USTC.

由于文件过大，如果你只想下载部分文件夹，请运行

```
1. 克隆仓库但不检出任何文件

git clone --filter=blob:none --no-checkout https://github.com/guanguan125/Courses-of-USTC.git

cd Courses-of-USTC

2. 启用 sparse-checkout

git sparse-checkout init --cone

3. 设置你想检出的目录或文件

git sparse-checkout set docs # 你需要将docs改成你需要的文件夹相对地址，如courses/大三课程

4. 拉取指定目录内容

git checkout main # 或 master，看你的默认分支
```

如果有希望补充或更正的地方，请联系

```
4rk1cvwj4@mozmail.com
```
