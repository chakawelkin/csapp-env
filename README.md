# CSAPP 本地实验环境 (基于 Docker)

这个目录包含了一个专门为学习和完成 CMU 15-213 / CS:APP（深入理解计算机系统）实验而准备的 Docker 环境。

## 为什么需要这个环境？
由于 CSAPP 的多数实验提供的是 **Linux x86_64 ELF 格式** 的预编译二进制文件（例如 Bomb Lab, Attack Lab），或者依赖于特定的 Linux 内存布局和 GDB 工具链。如果你使用的是 macOS（尤其是基于 ARM 架构的 Apple Silicon 芯片 M1/M2/M3），则无法直接运行这些实验文件或使用 macOS 原生的调试工具进行正确的实验。

此环境配置了：
- **Ubuntu 22.04 (强制使用 amd64 平台架构)**
- 必要的编译工具 (`build-essential`, `gcc-multilib`, `make`)
- 必要的调试工具 (`gdb`, `valgrind`, `hexedit`, `bsdmainutils`)
- 特殊的 Docker 调试权限 (`cap_add: SYS_PTRACE`, 允许容器内执行 GDB 进行 ptrace 调试)

## 前提条件
1. 你的电脑上需要安装了 [Docker](https://www.docker.com/products/docker-desktop/)。
2. *如果你的 Mac 是 Apple Silicon 芯片：* 在 Docker Desktop 的设置里，确保启用了 **Rosetta** 以获得最佳的 x86_64 模拟性能（**Settings -> General -> Use Rosetta for x86/amd64 emulation on Apple Silicon**）。

## 使用步骤

### 1. 启动容器环境
在当前 `csapp-env` 目录中运行以下命令。首次启动需要下载镜像和安装工具包，时间可能稍长：

```bash
docker-compose up -d --build
```

### 2. 进入容器
环境启动后，你可以在终端中进入容器的 `bash` shell：

```bash
docker exec -it csapp-env bash
```
进入容器后，你默认处在 `/workspace` 目录下。你的用户是具有 sudo 权限的 `csapp`，你可以随时用 `sudo apt install xxx` 安装其他工具。

### 3. 如何完成实验？
我们在当前目录下创建了一个子目录 `workspace/`，并在 Docker 容器里双向同步挂载。
推荐的工作流是：
1. **获取实验材料**：把从 CSAPP 官网下载的实验内容（例如 `datalab-handout.tar`）解压，并将解压后的文件夹拖入本机的 `workspace/` 目录。
2. **本机写代码**：在你的 macOS 主机上使用 VSCode / CLion 等现代编辑器直接在 `workspace/` 目录下阅读并修改 `.c` 等代码文件。
3. **容器内编译测试**：进入刚才启动的容器 shell (`docker exec -it csapp-env bash`) 中，输入 `make` 编译，并使用 `gdb ./bomb` 或 `./btest` 等命令进行评测或调试。

### 4. 停止并清理环境
当你完成了当天的实验，你可以停止容器（数据保存在本地的 `workspace` 下，不会丢失）：

```bash
docker-compose down
```
