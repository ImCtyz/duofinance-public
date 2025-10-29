-- Bootstrap minimal content suitable for master (no demo users or rewards)
-- Adds 1 level with 1 intro step and 1 question to allow basic e2e testing.

BEGIN;

-- Ensure a basic level exists
WITH ins_level AS (
  INSERT INTO levels (title, topic, difficulty, reward_points, is_active, created_at, updated_at)
  SELECT 'Финансовая безопасность', 'Безопасность', 'easy', 50, TRUE, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM levels WHERE title = 'Финансовая безопасность'
  )
  RETURNING id
),
get_level AS (
  SELECT id FROM ins_level
  UNION ALL
  SELECT id FROM levels WHERE title = 'Финансовая безопасность'
),
ins_question AS (
  INSERT INTO questions (prompt, explanation, multi_select, created_at, updated_at)
  SELECT 'Что относится к финансовой подушке?', 'Резерв на 3-6 месяцев расходов — стандарт.', FALSE, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM questions WHERE prompt = 'Что относится к финансовой подушке?'
  )
  RETURNING id
),
get_question AS (
  SELECT id FROM ins_question
  UNION ALL
  SELECT id FROM questions WHERE prompt = 'Что относится к финансовой подушке?'
),
ins_choice1 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_question), 'Деньги на отпуск в следующем году', FALSE, 1, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_question) AND text = 'Деньги на отпуск в следующем году'
  )
  RETURNING id
),
ins_choice2 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_question), 'Резерв на 3-6 месяцев расходов', TRUE, 2, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_question) AND text = 'Резерв на 3-6 месяцев расходов'
  )
  RETURNING id
),
ins_step_text AS (
  INSERT INTO level_steps (level_id, "order", type, title, payload, created_at, updated_at)
  SELECT (SELECT id FROM get_level), 1, 'text', 'Введение', '{"body":"Держите резерв на непредвиденные расходы"}'::jsonb, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM level_steps WHERE level_id = (SELECT id FROM get_level) AND "order" = 1
  )
  RETURNING id
),
ins_step_question AS (
  INSERT INTO level_steps (level_id, "order", type, title, payload, question_id, created_at, updated_at)
  SELECT (SELECT id FROM get_level), 2, 'question', 'Проверка знаний', '{}'::jsonb, (SELECT id FROM get_question), NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM level_steps WHERE level_id = (SELECT id FROM get_level) AND "order" = 2
  )
  RETURNING id
)
SELECT 1;

COMMIT;
