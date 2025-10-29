## DuoFinance — монорепозиторий (Go backend + React/Vite frontend)

Этот репозиторий содержит бэкенд на Go (Golang + Gin + GORM) и фронтенд на React (Vite + TypeScript + Tailwind).

### Требования
- Go 1.22+
- Node.js 18+ и npm
- Docker и docker-compose (опционально, для быстрого запуска)
- PostgreSQL 14+ (локально или в Docker)

### Быстрый старт  (Docker)
0) Клонировать репозиторий 

1) Скопируйте переменные окружения:
```
cp backend/.env.example backend/.env
```
2) Поднимите весь стек:
```
docker compose up --build
```
3) Бэкенд будет на `http://localhost:8080`, API префикс `http://localhost:8080/v1`
4) Фронтенд на `http://localhost:3000`

Контент для теста (уровень + вопрос):
- В мастере присутствует bootstrap-миграция `0004_bootstrap_content.up.sql` — она добавляет один уровень и вопрос без демо-пользователя.
- Полные демо-данные из `0002_seed.up.sql` использовать только локально (не применять в проде).



### Переменные окружения
Backend (`backend/.env`):
```
PORT=8080
DB_DSN=postgres://user:password@localhost:5432/duofinance?sslmode=disable
JWT_SECRET=change_me
```

Frontend (`frontend/.env`):
```
VITE_API_BASE_URL=http://localhost:8080/v1
```
(Примечание: на текущий момент код использует константу в `client.ts`. В будущем перенесём на `import.meta.env.VITE_API_BASE_URL`.)

### Структура
- `backend/` — Go сервис (Gin, GORM, JWT)
- `frontend/` — React/Vite приложение
- `docker-compose.yml` — локальный запуск сервисов

### Команды
- Backend: `go run ./cmd/server`
- Frontend: `npm run dev` | `npm run build` | `npm run preview`

### Лицензия
См. `LICENSE`.
