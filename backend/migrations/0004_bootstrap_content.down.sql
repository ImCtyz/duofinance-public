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

COMMIT;
