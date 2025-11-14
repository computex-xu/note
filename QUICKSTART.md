# 快速开始指南

## 一、后端设置（Python）

### Windows系统

1. 打开命令行，进入 `backend` 目录
2. 运行 `start.bat` 脚本
3. 等待依赖安装完成，服务会自动启动

### Linux/Mac系统

1. 打开终端，进入 `backend` 目录
2. 给脚本添加执行权限：`chmod +x start.sh`
3. 运行脚本：`./start.sh`

### 手动安装

```bash
cd backend

# 创建虚拟环境（推荐）
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 安装依赖
pip install -r requirements.txt

# 设置DeepSeek API密钥（可选）
export DEEPSEEK_API_KEY="your_api_key"  # Windows: set DEEPSEEK_API_KEY=your_api_key

# 启动服务
python app.py
```

服务将在 `http://localhost:5000` 启动

## 二、前端设置（微信小程序）

1. **下载并安装微信开发者工具**
   - 访问：https://developers.weixin.qq.com/miniprogram/dev/devtools/download.html

2. **导入项目**
   - 打开微信开发者工具
   - 选择"导入项目"
   - 项目目录选择 `miniprogram` 文件夹
   - AppID：可以使用测试号或申请正式AppID

3. **配置API地址**
   - 打开 `miniprogram/app.js`
   - 修改 `apiBaseUrl` 为你的后端地址
   - 如果后端在本地运行：`http://localhost:5000/api`
   - 如果后端部署在服务器：`https://your-server.com/api`

4. **编译运行**
   - 在微信开发者工具中点击"编译"
   - 在模拟器或真机上测试

## 三、配置DeepSeek API（可选）

1. 访问 [DeepSeek官网](https://www.deepseek.com) 注册账号
2. 获取API密钥
3. 设置环境变量：
   - Windows: `set DEEPSEEK_API_KEY=your_key`
   - Linux/Mac: `export DEEPSEEK_API_KEY=your_key`
   - 或创建 `.env` 文件：`DEEPSEEK_API_KEY=your_key`

**注意**：如果没有配置DeepSeek API，系统会使用简单的关键词匹配进行题目分类，功能仍然可用。

## 四、测试

1. **测试后端**
   - 访问 `http://localhost:5000/api/health`
   - 应该返回：`{"status": "ok", "message": "服务运行正常"}`

2. **测试小程序**
   - 在微信开发者工具中打开小程序
   - 点击"拍照识别错题"
   - 选择一张包含题目的图片
   - 查看识别结果

## 五、常见问题

### 1. OCR识别失败
- 确保已安装OCR引擎（PaddleOCR或EasyOCR）
- 首次运行需要下载模型，可能需要一些时间
- 检查图片是否清晰，光线是否充足

### 2. 小程序无法连接后端
- 检查后端服务是否正常运行
- 检查 `app.js` 中的 `apiBaseUrl` 是否正确
- 如果使用真机调试，确保手机和电脑在同一网络，或使用服务器地址

### 3. DeepSeek API调用失败
- 检查API密钥是否正确
- 检查网络连接
- 查看后端日志中的错误信息

### 4. 数据库错误
- 确保有写入权限
- 如果使用MySQL，检查数据库连接配置
- SQLite数据库文件会自动创建

## 六、下一步

- 阅读 `README.md` 了解详细功能
- 根据需要修改配置
- 部署到服务器（可选）

