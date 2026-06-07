# Maxi Group — статический сайт

Сайт открывается в браузере по ссылке **GitHub Pages** после загрузки этой папки в репозиторий GitHub.

## Ссылка на сайт

После публикации адрес будет таким:

| Страница | URL |
|----------|-----|
| Главная | `https://ВАШ_ЛОГИН.github.io/ИМЯ_РЕПОЗИТОРИЯ/` |
| Шоурум | `https://ВАШ_ЛОГИН.github.io/ИМЯ_РЕПОЗИТОРИЯ/showroom.html` |

**Пример:** логин `yariky`, репозиторий `maxigroup-site`:

- https://yariky.github.io/maxigroup-site/
- https://yariky.github.io/maxigroup-site/showroom.html

Если репозиторий назвать **`ВАШ_ЛОГИН.github.io`**, главная будет без имени репозитория:

- https://yariky.github.io/

---

## Быстрая публикация (5 шагов)

### 1. Установите Git

https://git-scm.com/download/win

### 2. Создайте репозиторий на GitHub

1. Откройте https://github.com/new  
2. Имя, например: `maxigroup-site`  
3. **Public**  
4. Без галочки «Add a README»  
5. Create repository  

### 3. Загрузите файлы из папки `html`

В PowerShell в папке `html`:

```powershell
git init -b main
git add .
git commit -m "Maxi Group site"
git remote add origin https://github.com/ВАШ_ЛОГИН/maxigroup-site.git
git push -u origin main
```

Или через скрипт:

```powershell
powershell -ExecutionPolicy Bypass -File .\publish-to-github.ps1 -GitHubUser "ВАШ_ЛОГИН" -RepoName "maxigroup-site"
git push -u origin main
```

### 4. Включите GitHub Pages

1. Репозиторий → **Settings** → **Pages**  
2. **Build and deployment** → Source: **GitHub Actions**  
3. После push workflow «GitHub Pages» сам опубликует сайт (1–3 минуты)

### 5. Откройте ссылку

В **Settings → Pages** появится зелёная ссылка **Visit site**.

---

## Структура

```
html/
  index.html                  → редирект на главную
  maxigroup-volga-style.html  → главная страница
  showroom.html               → шоурум
  assets/                     → фото и иконки (обязательно заливать целиком)
  .github/workflows/pages.yml → автодеплой
```

## Обновление галереи работ

```powershell
powershell -ExecutionPolicy Bypass -File .\regenerate-works.ps1
git add assets/works-manifest.js assets/works-manifest.json
git commit -m "Update works gallery"
git push
```

## Важно

- Загружайте **всю** папку `assets` с фотографиями — без неё картинки не откроются.  
- Репозиторий с большим числом фото может быть тяжёлым; GitHub допускает файлы до ~100 МБ каждый.  
- Для локального просмотра достаточно открыть `index.html`; для интернета нужен GitHub Pages (или другой хостинг).
