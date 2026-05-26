# {{PROJECT_NAME}} — AGENTS.md

## 專案入口

- 專案名稱：{{PROJECT_NAME}}
- 專案用途：{{PROJECT_DESCRIPTION}}
- 主要工作目錄：{{WORK_DIR}}
- GitHub repo：{{GITHUB_USER}}/{{REPO_NAME}}
- 預設 branch：main

## Obsidian 對應筆記

- Obsidian vault：{{OBSIDIAN_VAULT}}
- 專案駕駛艙：{{PROJECT_FOLDER}}/專案工作流程.md

## 工作桌 + 三個家

- 工作桌：{{WORK_DIR}}
- GitHub：{{GITHUB_USER}}/{{REPO_NAME}}
- Obsidian：{{OBSIDIAN_VAULT}} + {{PROJECT_FOLDER}}/專案工作流程.md

## 同步規則

開工時：
- 使用 startup 流程
- 讀本檔
- 讀 Obsidian 駕駛艙
- 檢查 Git 狀態
- 不自動 pull / commit / push

收工時：
- 使用 shutdown 流程
- 更新 Obsidian 駕駛艙
- 如規則、路徑、邊界改變才更新本檔
- 需要時 commit + push GitHub

## 檔案結構

```
{{WORK_DIR}}/
├── AGENTS.md    # AI 助理專案規則
├── README.md    # 專案說明
├── .gitignore   # Git 忽略規則
└── src/         # 原始碼目錄
```

## 不要做

- 不要把 API key、token、密碼寫進 repo
- 不要把每日進度寫進 AGENTS.md
