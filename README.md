# 盛京两日 · 沈阳周末漫游指南

单文件网页版沈阳两日游路线指南：周五晚抵达 → 周六故宫/帅府/总督府/中街 → 周日上午大东副食，附高德地图关键景点标注与步行路线。把 `index.html` 发给朋友即可直接打开。

## 功能

- **周五（DAY 0）**：抵达、入住中街商圈、第一顿盛京味
- **周六（DAY 1）**：沈阳故宫 → 张氏帅府博物馆 → 东三省总督府 → 中街步行街，按游览顺序时间轴呈现
- **周日上午（DAY 2）**：大东副食商场（东行）伴手礼采购
- **顺路加游**：小南教堂、太清宫、辽宁省博物馆、老四季、西塔、北陵公园、棋盘山
- **高铁周边**：本溪、辽阳、鞍山、兴城、丹东、大连/锦州
- **高德地图**：12 个关键景点带名称标注，周六/周日步行路线（距离与耗时已预计算），支持筛选与「在地图上查看」跳转
- 移动端自适应布局，滚动动画，配图自动加载

## 路线数据本地化

步行路线数据（各段折线坐标、距离、耗时）已由高德步行路径规划接口**预计算后内嵌**在 `index.html` 的 `ROUTES_DATA` 中：

- 页面打开**不会**调用任何路线规划接口，不消耗配额、离线也能显示路线
- 想更新路线时，重新调用高德步行规划接口，替换 `ROUTES_DATA` 即可

## 高德地图 Key（不写入源码）

源码中的 `index.html` **不包含**真实 Key，仅保留 `__AMAP_KEY__` / `__AMAP_JCODE__` 占位符，由构建/部署时从环境注入：

- **GitHub Pages 部署**：`.github/workflows/deploy.yml` 从仓库 Secret（`AMAP_KEY`、`AMAP_JCODE`）读取并注入后发布
- **本地预览**：设置环境变量 `AMAP_KEY` / `AMAP_JCODE` 后运行 `build.ps1`，打开生成的 `dist/index.html`

未注入时打开页面，地图区域会显示"Key 未注入"提示，其余内容不受影响。

## GitHub Pages 部署

1. **仓库转公开**：Settings → General → Danger Zone → Change repository visibility → Public（Pages 免费版要求公开仓库；本仓库历史已重写，不含任何 Key）
2. **添加 Secrets**：Settings → Secrets and variables → Actions → New repository secret，新增两个：
   - `AMAP_KEY`：高德 Web 端(JS API) Key
   - `AMAP_JCODE`：该 Key 对应的安全密钥
3. **启用 Pages**：Settings → Pages → Build and deployment → Source 选择 **GitHub Actions**
4. **高德控制台配置白名单**（重要）：在[高德开放平台](https://console.amap.com/)应用管理 → 安全密钥设置中，为 `AMAP_JCODE` 配置域名白名单：
   - `https://theemou.github.io/*`（部署域名）
   - `http://localhost:*`、`http://127.0.0.1:*`（本地调试）
   配置后 Key 仅能在这类来源下使用，即使被扒取也无法用于其他站点
5. **触发部署**：推送到 `main` 自动部署；或 Actions 页面手动 **Run workflow**
6. **访问**：`https://theemou.github.io/shenyang-guide/`

> 提示：高德控制台还可对该 Key 设置每日配额，进一步控制风险。

## 目录结构

```
.
├── index.html              # 单文件应用（占位 Key，样式/脚本/路线数据内嵌）
├── .github/workflows/      # GitHub Actions：Pages 构建部署（Secret 注入 Key）
├── build.ps1               # 本地构建：注入 Key 生成 dist/index.html
├── bak/                    # 历史版本备份（已在 .gitignore 中忽略）
└── README.md
```

## 技术栈

- 高德地图 JS API v2.0（WebGL），`AMap.Marker` / `AMap.Polyline` / `AMap.InfoWindow`
- 原生 HTML/CSS/JavaScript，无任何构建步骤与第三方依赖
