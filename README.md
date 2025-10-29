## DuoFinance — монорепозиторий (Go backend + React/Vite frontend)

Этот репозиторий содержит бэкенд на Go (Golang + Gin + GORM) и фронтенд на React (Vite + TypeScript + Tailwind).

### Требования
- Go 1.22+
- Node.js 18+ и npm
- Docker и docker-compose (опционально, для быстрого запуска)
- PostgreSQL 14+ (локально или в Docker)

### Быстрый старт  (Docker)
1) Скачать Докер

2) В корне проекта выполнить: docker compose up --build

3) Зайти на localhost:3000

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
