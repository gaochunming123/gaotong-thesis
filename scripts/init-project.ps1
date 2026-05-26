<#
.SYNOPSIS
  從 project-template 初始化新專案
.DESCRIPTION
  複製模板 → 取代變數 → Git init → Obsidian 同步
.PARAMETER ProjectName
  專案名稱（如 "my-awesome-project"）
.PARAMETER Description
  專案描述
.PARAMETER WorkDir
  工作目錄（預設：G:\我的云端硬盘\opencloud_0525）
.PARAMETER ObsidianVault
  Obsidian vault 路徑（預設：G:\我的云端硬盘\2ndbrain）
.PARAMETER GitHubUser
  GitHub 使用者名稱（預設：gaochunming123）
#>

param(
    [Parameter(Mandatory=$true)][string]$ProjectName,
    [string]$Description = "新專案",
    [string]$WorkDir = "G:\我的云端硬盘\opencloud_0525",
    [string]$ObsidianVault = "G:\我的云端硬盘\2ndbrain",
    [string]$GitHubUser = "gaochunming123",
    [string]$TemplateRepo = "codex-lazy-packs"  # 模板在 Obsidian vault 中
)

$TemplateDir = "$ObsidianVault\$TemplateRepo\..\project-template"
if (-not (Test-Path $TemplateDir)) {
    # 改從 GitHub 下載
    $TemplateUrl = "https://github.com/$GitHubUser/project-template/archive/refs/heads/main.zip"
    $TempZip = "$env:TEMP\project-template.zip"
    Invoke-WebRequest -Uri $TemplateUrl -OutFile $TempZip -ErrorAction Stop
    Expand-Archive -Path $TempZip -DestinationPath "$env:TEMP\project-template-extracted" -Force
    $TemplateDir = "$env:TEMP\project-template-extracted\project-template-main"
}

$ProjectDir = "$WorkDir\$ProjectName"
$ObsidianProjectDir = "$ObsidianVault\$ProjectName"

Write-Host "=== 初始化新專案：$ProjectName ===" -ForegroundColor Cyan
Write-Host "工作目錄：$ProjectDir"
Write-Host "Obsidian：$ObsidianProjectDir"

# 1. 建立目錄
New-Item -ItemType Directory -Path $ProjectDir -Force | Out-Null
New-Item -ItemType Directory -Path "$ProjectDir\src" -Force | Out-Null
New-Item -ItemType Directory -Path "$ObsidianProjectDir" -Force | Out-Null

# 2. 複製模板並取代變數
$replacements = @{
    "{{PROJECT_NAME}}" = $ProjectName
    "{{PROJECT_DESCRIPTION}}" = $Description
    "{{WORK_DIR}}" = $ProjectDir
    "{{OBSIDIAN_VAULT}}" = $ObsidianVault
    "{{PROJECT_FOLDER}}" = $ProjectName
    "{{GITHUB_USER}}" = $GitHubUser
    "{{REPO_NAME}}" = $ProjectName
    "{{OBSIDIAN_NOTE}}" = "$ObsidianProjectDir\專案工作流程.md"
}

# AGENTS.md
$agents = Get-Content "$TemplateDir\AGENTS.md" -Raw
foreach ($k in $replacements.Keys) { $agents = $agents -replace [regex]::Escape($k), $replacements[$k] }
Set-Content -Path "$ProjectDir\AGENTS.md" -Value $agents -Encoding UTF8

# README.md
$readme = Get-Content "$TemplateDir\README.md" -Raw
foreach ($k in $replacements.Keys) { $readme = $readme -replace [regex]::Escape($k), $replacements[$k] }
Set-Content -Path "$ProjectDir\README.md" -Value $readme -Encoding UTF8

# .gitignore
Copy-Item "$TemplateDir\.gitignore" "$ProjectDir\.gitignore" -Force

# Obsidian cockpit
$cockpit = Get-Content "$TemplateDir\_templates\Obsidian駕駛艙.md" -Raw
foreach ($k in $replacements.Keys) { $cockpit = $cockpit -replace [regex]::Escape($k), $replacements[$k] }
Set-Content -Path "$ObsidianProjectDir\專案工作流程.md" -Value $cockpit -Encoding UTF8

# 3. Git init
Set-Location $ProjectDir
git init
git add -A
git commit -m "🎉 初始化 $ProjectName"

# 4. GitHub repo + push
try {
    gh repo create $GitHubUser/$ProjectName --public --source=$ProjectDir --push --remote=origin
    Write-Host "GitHub repo 建立成功" -ForegroundColor Green
} catch {
    Write-Host "GitHub repo 建立失敗（可手動設定）：$_" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== 完成 ===" -ForegroundColor Cyan
Write-Host "專案資料夾：$ProjectDir"
Write-Host "Obsidian 筆記：$ObsidianProjectDir\專案工作流程.md"
Write-Host "AGENTS.md 已同步到 Obsidian"
