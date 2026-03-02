# 使用国内免鉴权的 Docker 代理镜像作为基础镜像，强制使用 amd64 平台
FROM --platform=linux/amd64 m.daocloud.io/docker.io/library/ubuntu:22.04

# 将 ubuntu 的 apt 源替换为国内的阿里云源，加快软件包下载速度
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

# 防止在安装包时出现交互提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装 CSAPP 实验所需的核心工具和依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-multilib \
    g++-multilib \
    gdb \
    valgrind \
    vim \
    nano \
    git \
    curl \
    wget \
    tar \
    make \
    sudo \
    file \
    bsdmainutils \
    hexedit \
    && rm -rf /var/lib/apt/lists/*

# 创建一个非 root 用户供开发使用
RUN useradd -m -s /bin/bash csapp && echo "csapp:csapp" | chpasswd && adduser csapp sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# 切换为 csapp 用户并设置工作目录
USER csapp
WORKDIR /workspace

# 配置一下 GDB 友好的环境（可选）
RUN echo "set auto-load safe-path /" >> ~/.gdbinit

# 默认启动 bash
CMD ["/bin/bash"]
