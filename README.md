# 智能错题本微信小程序

一个基于Python后端和微信小程序前端的智能错题管理系统，支持拍照识别错题、AI自动分类、相似题目推荐等功能。

## 功能特性

- 📸 **拍照识别**：支持拍照或从相册选择图片，自动识别题目内容
- 🤖 **AI智能分析**：使用DeepSeek API自动识别题型、科目、知识点
- 📚 **错题管理**：按科目、题型分类管理错题
- 🔍 **相似题目推荐**：自动推荐同类题目辅助理解
- 📊 **数据统计**：错题数量、科目分布、题型分布等统计信息

## 项目结构

```
.
├── backend/                 # Python后端
│   ├── app.py              # Flask应用主文件
│   ├── config.py           # 配置文件
│   ├── requirements.txt    # Python依赖
│   ├── database/           # 数据库模型
│   │   └── models.py
│   └── services/           # 业务服务
│       ├── ocr_service.py  # OCR识别服务
│       ├── ai_service.py  # AI分析服务
│       └── question_service.py  # 题目管理服务
│
└── miniprogram/            # 微信小程序前端
    ├── app.js              # 小程序入口
    ├── app.json            # 小程序配置
    ├── utils/              # 工具函数
    │   └── api.js          # API请求封装
    └── pages/              # 页面
        ├── index/          # 首页
        ├── camera/         # 拍照页面
        ├── question-list/  # 错题列表
        ├── question-detail/ # 题目详情
        └── statistics/     # 统计页面
```

## 环境要求

- Python 3.8+
- 微信开发者工具
- DeepSeek API密钥（可选，用于AI功能）

## 安装步骤

### 方式一：Docker部署（推荐）

这是最简单的部署方式，适合生产环境：

```bash
# 1. 配置环境变量
cp .env.example .env
# 编辑 .env 文件，填入你的配置

# 2. 构建并启动
docker-compose up -d

# 3. 查看日志
docker-compose logs -f backend
```

详细说明请查看 [DOCKER_DEPLOY.md](DOCKER_DEPLOY.md)

### 方式二：本地开发部署

### 1. 后端设置

```bash
# 进入后端目录
cd backend

# 安装Python依赖
pip install -r requirements.txt

# 设置环境变量（可选）
export DEEPSEEK_API_KEY="your_deepseek_api_key"

# 运行后端服务
python app.py
```

后端服务将在 `http://localhost:5000` 启动。

### 2. 前端设置

1. 打开微信开发者工具
2. 导入 `miniprogram` 目录作为小程序项目
3. 修改 `app.js` 中的 `apiBaseUrl` 为你的后端地址
4. 在微信开发者工具中编译运行

### 3. 配置DeepSeek API（可选）

如果没有DeepSeek API密钥，系统会使用简单的关键词匹配进行题目分类。

获取API密钥：
1. 访问 [DeepSeek官网](https://www.deepseek.com)
2. 注册账号并获取API密钥
3. 设置环境变量：`export DEEPSEEK_API_KEY="your_key"`

## API接口说明

### 上传并识别错题
```
POST /api/upload
Body: {
  "image": "base64编码的图片",
  "user_id": "用户ID"
}
```

### 获取错题列表
```
GET /api/questions?user_id=xxx&type=选择题&subject=数学
```

### 获取错题详情
```
GET /api/questions/{question_id}
```

### 获取相似题目
```
GET /api/questions/{question_id}/similar
```

### 删除错题
```
DELETE /api/questions/{question_id}
```

### 获取统计信息
```
GET /api/statistics?user_id=xxx
```

## OCR引擎选择

项目支持两种OCR引擎：

1. **PaddleOCR**（推荐）：准确率高，支持中文识别
2. **EasyOCR**：备选方案

在 `requirements.txt` 中可以选择安装其中一个或两个都安装。

## 数据库

默认使用SQLite数据库，数据库文件为 `mistake_notebook.db`。

如需使用MySQL，修改 `config.py` 中的数据库配置：

```python
SQLALCHEMY_DATABASE_URI = 'mysql://user:password@localhost/dbname'
```

## 使用说明

1. **添加错题**：
   - 在首页点击"拍照识别错题"
   - 选择拍照或从相册选择
   - 系统自动识别并保存

2. **查看错题**：
   - 在"错题本"页面查看所有错题
   - 可以按题型、科目筛选
   - 点击错题查看详情

3. **查看统计**：
   - 在"统计"页面查看错题分布情况

## 注意事项

1. 首次运行需要下载OCR模型，可能需要一些时间
2. 确保后端服务正常运行，小程序才能正常使用
3. 图片大小建议控制在5MB以内
4. DeepSeek API调用需要网络连接

## 开发计划

- [ ] 支持题目编辑功能
- [ ] 支持导出错题为PDF
- [ ] 支持错题复习提醒
- [ ] 优化相似题目推荐算法
- [ ] 支持多用户登录

## 许可证

MIT License

## 联系方式

如有问题或建议，欢迎提交Issue。

