BEGIN;

-- Remove level steps for the known level
DELETE FROM level_steps
WHERE level_id IN (
  SELECT id FROM levels WHERE title = 'Финансовая безопасность'
)
AND (
  ("order" = 1 AND title = 'Введение')
  OR ("order" = 2 AND title = 'Проверка знаний')
);

-- Remove choices and question if no other references
DELETE FROM choices
WHERE question_id IN (
  SELECT id FROM questions WHERE prompt = 'Что относится к финансовой подушке?'
);

DELETE FROM questions
WHERE prompt = 'Что относится к финансовой подушке?';

-- Remove level if exists
DELETE FROM levels
WHERE title = 'Финансовая безопасность';

-- Remove additional seeded content introduced in 0004

-- Level: Бюджет и учёт расходов
DELETE FROM level_steps WHERE level_id IN (SELECT id FROM levels WHERE title = 'Бюджет и учёт расходов');
DELETE FROM choices WHERE question_id IN (
  SELECT id FROM questions WHERE prompt = 'Какой простой метод распределения бюджета часто используют новички?'
);
DELETE FROM questions WHERE prompt = 'Какой простой метод распределения бюджета часто используют новички?';
DELETE FROM levels WHERE title = 'Бюджет и учёт расходов';

-- Level: Резервный фонд
DELETE FROM level_steps WHERE level_id IN (SELECT id FROM levels WHERE title = 'Резервный фонд');
DELETE FROM choices WHERE question_id IN (
  SELECT id FROM questions WHERE prompt = 'Какой рекомендуемый размер финансовой подушки?'
);
DELETE FROM questions WHERE prompt = 'Какой рекомендуемый размер финансовой подушки?';
DELETE FROM levels WHERE title = 'Резервный фонд';

-- Level: Кредиты и долги
DELETE FROM level_steps WHERE level_id IN (SELECT id FROM levels WHERE title = 'Кредиты и долги');
DELETE FROM choices WHERE question_id IN (
  SELECT id FROM questions WHERE prompt = 'Что помогает быстрее погасить несколько долгов?'
);
DELETE FROM questions WHERE prompt = 'Что помогает быстрее погасить несколько долгов?';
DELETE FROM levels WHERE title = 'Кредиты и долги';

-- Level: Основы инвестиций
DELETE FROM level_steps WHERE level_id IN (SELECT id FROM levels WHERE title = 'Основы инвестиций');
DELETE FROM choices WHERE question_id IN (
  SELECT id FROM questions WHERE prompt = 'Какой инструмент обычно подходит для долгосрочных целей с умеренным риском?'
);
DELETE FROM questions WHERE prompt = 'Какой инструмент обычно подходит для долгосрочных целей с умеренным риском?';
DELETE FROM levels WHERE title = 'Основы инвестиций';

COMMIT;
