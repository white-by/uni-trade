# 测试公告sse用，测试页在testPage

from flask import Flask, Response, stream_with_context
from flask_cors import CORS  # 导入 CORS 库
import time
import json
from datetime import datetime, timedelta

app = Flask(__name__)

# 启用 CORS，允许来自所有来源的请求
CORS(app, resources={r"/sse/*": {"origins": "http://localhost:5173"}})

# 模拟公告数据
announcements = [
    {"id": 1, "date": "2024-05-15", "title": "公告标题 1", "content": "内容 1"},
    {"id": 2, "date": "2024-05-16", "title": "公告标题 2", "content": "内容 2"},
    {"id": 3, "date": "2024-05-17", "title": "公告标题 3", "content": "内容 3"},
]

# 记录最后一次发送公告的时间
last_announcement_time = datetime.now()

@app.route('/sse/announcements')
def sse_announcements():
    def generate():
        global last_announcement_time
        while True:
            current_time = datetime.now()
            
            # 只有超过 10 秒才生成并发送新公告
            if (current_time - last_announcement_time) >= timedelta(seconds=10):
                new_announcement = {
                    "id": len(announcements) + 1,
                    "date": time.strftime("%Y-%m-%d"),
                    "title": f"公告标题 {len(announcements) + 1}",
                    "content": f"内容 {len(announcements) + 1}",
                }
                announcements.insert(0, new_announcement)
                last_announcement_time = current_time  # 更新最后发送时间

                # 发送最近三条公告
                yield f"data: {json.dumps(announcements[:3])}\n\n"

            time.sleep(1)  # 轮询间隔小一些，提升及时性

    return Response(stream_with_context(generate()), content_type='text/event-stream')

if __name__ == '__main__':
    app.run(debug=True, port=5000)
