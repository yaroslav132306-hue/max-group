# Публикация сайта Maxi Group на GitHub Pages
# Требуется: Git for Windows — https://git-scm.com/download/win
#
# Запуск (замените USERNAME и REPO):
#   powershell -ExecutionPolicy Bypass -File .\publish-to-github.ps1 -GitHubUser "USERNAME" -RepoName "maxigroup-site"

param(
  [Parameter(Mandatory = $true)]
  [string]$GitHubUser,
  [Parameter(Mandatory = $true)]
  [string]$RepoName,
  [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot

function Require-Git {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git не найден. Установите Git for Windows: https://git-scm.com/download/win"
  }
}

Require-Git
Set-Location -LiteralPath $root

if (-not (Test-Path -LiteralPath (Join-Path $root ".git"))) {
  git init -b $Branch
}

git add -A
$status = git status --porcelain
if ($status) {
  git commit -m "Publish Maxi Group site"
} else {
  Write-Host "Нет новых изменений для коммита."
}

$remoteUrl = "https://github.com/$GitHubUser/$RepoName.git"
$remotes = git remote
if ($remotes -notcontains "origin") {
  git remote add origin $remoteUrl
} else {
  git remote set-url origin $remoteUrl
}

Write-Host ""
Write-Host "Дальше на github.com:"
Write-Host "  1. Создайте пустой репозиторий: $RepoName (без README)"
Write-Host "  2. Выполните: git push -u origin $Branch"
Write-Host "  3. Settings -> Pages -> Source: GitHub Actions"
Write-Host ""
Write-Host "После деплоя сайт будет доступен по адресу:"
Write-Host "  https://$GitHubUser.github.io/$RepoName/"
Write-Host ""
Write-Host "Главная: https://$GitHubUser.github.io/$RepoName/"
Write-Host "Шоурум: https://$GitHubUser.github.io/$RepoName/showroom.html"
