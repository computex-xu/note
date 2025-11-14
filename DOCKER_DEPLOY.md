# Docker 部署指南

本文档说明如何使用Docker部署智能错题本系统到云服务器。

## 前置要求

- Docker 20.10+
- Docker Compose 2.0+
- 云服务器（推荐2核4G以上配置）

## 快速开始

### 1. 克隆项目

```bash
git clone <your-repo-url>
cd note
```

### 2. 配置环境变量

创建 `.env` 文件：

```bash
# DeepSeek API密钥（可选）
DEEPSEEK_API_KEY=your_deepseek_api_key

# 数据库URL（可选，默认使用SQLite）
# DATABASE_URL=sqlite:///mistake_notebook.db
# 或使用MySQL
# DATABASE_URL=mysql://user:password@mysql:3306/mistake_notebook

# Flask环境
FLASK_ENV=production
```

### 3. 构建并启动

```bash
# 构建镜像
docker-compose build

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f backend
```

### 4. 验证部署

访问健康检查接口：
```bash
curl http://localhost:5000/api/health
```

应该返回：
```json
{"status": "ok", "message": "服务运行正常"}
```

## 使用Nginx反向代理（生产环境）

### 1. 启动带Nginx的完整服务

```bash
docker-compose --profile production up -d
```

### 2. 配置SSL证书（可选）

如果需要HTTPS：

1. 将SSL证书放到 `nginx/ssl/` 目录：
   - `cert.pem` - 证书文件
   - `key.pem` - 私钥文件

2. 修改 `nginx/nginx.conf`，取消HTTPS服务器配置的注释

3. 重启Nginx：
```bash
docker-compose restart nginx
```

## 常用命令

### 查看服务状态
```bash
docker-compose ps
```

### 查看日志
```bash
# 查看所有服务日志
docker-compose logs -f

# 查看后端日志
docker-compose logs -f backend

# 查看最近100行日志
docker-compose logs --tail=100 backend
```

### 重启服务
```bash
# 重启所有服务
docker-compose restart

# 重启特定服务
docker-compose restart backend
```

### 停止服务
```bash
docker-compose down
```

### 停止并删除数据卷
```bash
docker-compose down -v
```

### 更新服务
```bash
# 拉取最新代码
git pull

# 重新构建并启动
docker-compose up -d --build
```

## 数据持久化

数据存储在以下位置：

- **数据库文件**: `./backend/data/mistake_notebook.db`
- **上传文件**: `./backend/uploads/`

确保定期备份这些目录。

### 备份数据库

```bash
# 备份
docker-compose exec backend cp /app/data/mistake_notebook.db /app/data/backup_$(date +%Y%m%d).db

# 或从容器外备份
cp ./backend/data/mistake_notebook.db ./backup_$(date +%Y%m%d).db
```

### 恢复数据库

```bash
# 停止服务
docker-compose down

# 恢复数据库文件
cp ./backup_20240101.db ./backend/data/mistake_notebook.db

# 启动服务
docker-compose up -d
```

## 生产环境优化

### 1. 使用MySQL数据库

修改 `docker-compose.yml`，添加MySQL服务：

```yaml
services:
  mysql:
    image: mysql:8.0
    container_name: mistake-notebook-mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: mistake_notebook
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - mistake-notebook-network
    restart: unless-stopped

  backend:
    # ...
    depends_on:
      - mysql
    environment:
      - DATABASE_URL=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@mysql:3306/mistake_notebook

volumes:
  mysql-data:
```

### 2. 配置资源限制

在 `docker-compose.yml` 中添加资源限制：

```yaml
services:
  backend:
    # ...
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
```

### 3. 配置日志轮转

在 `docker-compose.yml` 中配置日志：

```yaml
services:
  backend:
    # ...
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## 监控和维护

### 查看容器资源使用

```bash
docker stats mistake-notebook-backend
```

### 进入容器调试

```bash
docker-compose exec backend bash
```

### 查看容器健康状态

```bash
docker inspect mistake-notebook-backend | grep Health -A 10
```

## 故障排查

### 1. 服务无法启动

```bash
# 查看详细日志
docker-compose logs backend

# 检查容器状态
docker-compose ps

# 检查端口占用
netstat -tulpn | grep 5000
```

### 2. OCR识别失败

确保容器有足够的内存和CPU资源。OCR模型首次运行需要下载，可能需要一些时间。

### 3. API调用失败

检查环境变量是否正确设置：
```bash
docker-compose exec backend env | grep DEEPSEEK
```

### 4. 数据库连接问题

检查数据库文件权限：
```bash
ls -la ./backend/data/
```

## 安全建议

1. **使用HTTPS**：在生产环境配置SSL证书
2. **防火墙配置**：只开放必要端口（80, 443）
3. **环境变量**：不要将敏感信息提交到代码仓库
4. **定期更新**：保持Docker镜像和依赖包更新
5. **备份策略**：定期备份数据库和上传文件

## 云服务器部署示例

### 阿里云/腾讯云

1. 购买云服务器（推荐Ubuntu 20.04+）
2. 安装Docker和Docker Compose
3. 克隆项目到服务器
4. 配置防火墙规则（开放5000端口或80/443）
5. 按照上述步骤部署

### 安装Docker（Ubuntu）

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 安装Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 验证安装
docker --version
docker-compose --version
```

## 小程序配置

部署完成后，修改小程序中的API地址：

```javascript
// miniprogram/app.js
globalData: {
  apiBaseUrl: 'https://your-domain.com/api',  // 修改为你的服务器地址
  userInfo: null
}
```

如果使用HTTP（非HTTPS），需要在微信小程序后台配置服务器域名白名单。

## 性能优化

1. **使用CDN**：将静态资源放到CDN
2. **数据库优化**：使用MySQL并配置索引
3. **缓存策略**：添加Redis缓存
4. **负载均衡**：使用多个后端实例

## 联系支持

如遇问题，请查看日志文件或提交Issue。

