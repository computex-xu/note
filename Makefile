.PHONY: build up down restart logs clean

# 构建镜像
build:
	docker-compose build

# 启动服务
up:
	docker-compose up -d

# 启动服务（带日志）
up-logs:
	docker-compose up

# 停止服务
down:
	docker-compose down

# 重启服务
restart:
	docker-compose restart

# 查看日志
logs:
	docker-compose logs -f backend

# 查看所有日志
logs-all:
	docker-compose logs -f

# 进入容器
shell:
	docker-compose exec backend bash

# 清理（包括数据卷）
clean:
	docker-compose down -v
	docker system prune -f

# 重新构建并启动
rebuild:
	docker-compose up -d --build

# 查看服务状态
ps:
	docker-compose ps

# 生产环境启动（带Nginx）
prod:
	docker-compose --profile production up -d

# 备份数据库
backup:
	@mkdir -p backups
	@cp backend/data/mistake_notebook.db backups/backup_$$(date +%Y%m%d_%H%M%S).db
	@echo "数据库已备份到 backups/backup_$$(date +%Y%m%d_%H%M%S).db"

