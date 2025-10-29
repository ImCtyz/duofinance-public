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

-- Additional finance-themed levels (5 total), each with an intro step and one
-- question step. All inserts are idempotent (guarded by WHERE NOT EXISTS).

-- Level 2: Бюджет и учёт расходов
WITH ins_level AS (
  INSERT INTO levels (title, topic, difficulty, reward_points, is_active, created_at, updated_at)
  SELECT 'Бюджет и учёт расходов', 'Бюджетирование', 'easy', 50, TRUE, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM levels WHERE title = 'Бюджет и учёт расходов'
  )
  RETURNING id
),
get_level AS (
  SELECT id FROM ins_level
  UNION ALL
  SELECT id FROM levels WHERE title = 'Бюджет и учёт расходов'
),
ins_q AS (
  INSERT INTO questions (prompt, explanation, multi_select, created_at, updated_at)
  SELECT 'Какой простой метод распределения бюджета часто используют новички?', 'Правило 50/30/20 помогает начать и дисциплинирует траты.', FALSE, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM questions WHERE prompt = 'Какой простой метод распределения бюджета часто используют новички?'
  )
  RETURNING id
),
get_q AS (
  SELECT id FROM ins_q
  UNION ALL
  SELECT id FROM questions WHERE prompt = 'Какой простой метод распределения бюджета часто используют новички?'
),
_c1 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), 'Правило 50/30/20', TRUE, 1, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = 'Правило 50/30/20'
  )
  RETURNING id
),
_c2 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), '100% тратить, при нехватке брать кредит', FALSE, 2, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = '100% тратить, при нехватке брать кредит'
  )
  RETURNING id
),
_c3 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), 'Все копить, ничего не тратить', FALSE, 3, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = 'Все копить, ничего не тратить'
  )
  RETURNING id
),
_s1 AS (
  INSERT INTO level_steps (level_id, "order", type, title, payload, created_at, updated_at)
  SELECT (SELECT id FROM get_level), 1, 'text', 'Зачем вести бюджет', '{"body":"Бюджет помогает видеть картину расходов и приоритизировать цели."}'::jsonb, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM level_steps WHERE level_id = (SELECT id FROM get_level) AND "order" = 1
  )
  RETURNING id
)
INSERT INTO level_steps (level_id, "order", type, title, payload, question_id, created_at, updated_at)
SELECT (SELECT id FROM get_level), 2, 'question', 'Проверка знаний', '{}'::jsonb, (SELECT id FROM get_q), NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM level_steps WHERE level_id = (SELECT id FROM get_level) AND "order" = 2
);

-- Level 3: Резервный фонд
WITH ins_level AS (
  INSERT INTO levels (title, topic, difficulty, reward_points, is_active, created_at, updated_at)
  SELECT 'Резервный фонд', 'Резерв', 'easy', 50, TRUE, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM levels WHERE title = 'Резервный фонд'
  )
  RETURNING id
),
get_level AS (
  SELECT id FROM ins_level
  UNION ALL
  SELECT id FROM levels WHERE title = 'Резервный фонд'
),
ins_q AS (
  INSERT INTO questions (prompt, explanation, multi_select, created_at, updated_at)
  SELECT 'Какой рекомендуемый размер финансовой подушки?', 'Чаще всего рекомендуют 3–6 месяцев обязательных расходов.', FALSE, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM questions WHERE prompt = 'Какой рекомендуемый размер финансовой подушки?'
  )
  RETURNING id
),
get_q AS (
  SELECT id FROM ins_q
  UNION ALL
  SELECT id FROM questions WHERE prompt = 'Какой рекомендуемый размер финансовой подушки?'
),
_c1 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), '3–6 месяцев расходов', TRUE, 1, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = '3–6 месяцев расходов'
  )
  RETURNING id
),
_c2 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), '1 неделя расходов', FALSE, 2, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = '1 неделя расходов'
  )
  RETURNING id
),
_c3 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), '12–24 месяца дохода', FALSE, 3, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = '12–24 месяца дохода'
  )
  RETURNING id
),
_s1 AS (
  INSERT INTO level_steps (level_id, "order", type, title, payload, created_at, updated_at)
  SELECT (SELECT id FROM get_level), 1, 'text', 'Что такое подушка', '{"body":"Это ликвидный резерв на непредвиденные ситуации."}'::jsonb, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM level_steps WHERE level_id = (SELECT id FROM get_level) AND "order" = 1
  )
  RETURNING id
)
INSERT INTO level_steps (level_id, "order", type, title, payload, question_id, created_at, updated_at)
SELECT (SELECT id FROM get_level), 2, 'question', 'Проверка знаний', '{}'::jsonb, (SELECT id FROM get_q), NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM level_steps WHERE level_id = (SELECT id FROM get_level) AND "order" = 2
);

-- Level 4: Кредиты и долги
WITH ins_level AS (
  INSERT INTO levels (title, topic, difficulty, reward_points, is_active, created_at, updated_at)
  SELECT 'Кредиты и долги', 'Долги', 'medium', 75, TRUE, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM levels WHERE title = 'Кредиты и долги'
  )
  RETURNING id
),
get_level AS (
  SELECT id FROM ins_level
  UNION ALL
  SELECT id FROM levels WHERE title = 'Кредиты и долги'
),
ins_q AS (
  INSERT INTO questions (prompt, explanation, multi_select, created_at, updated_at)
  SELECT 'Что помогает быстрее погасить несколько долгов?', 'Стратегии снежного кома и лавины — популярные подходы.', FALSE, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM questions WHERE prompt = 'Что помогает быстрее погасить несколько долгов?'
  )
  RETURNING id
),
get_q AS (
  SELECT id FROM ins_q
  UNION ALL
  SELECT id FROM questions WHERE prompt = 'Что помогает быстрее погасить несколько долгов?'
),
_c1 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), 'Метод лавины/снежного кома', TRUE, 1, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = 'Метод лавины/снежного кома'
  )
  RETURNING id
),
_c2 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), 'Игнорировать проценты', FALSE, 2, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = 'Игнорировать проценты'
  )
  RETURNING id
),
_c3 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), 'Брать новые кредиты для всех платежей', FALSE, 3, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = 'Брать новые кредиты для всех платежей'
  )
  RETURNING id
),
_s1 AS (
  INSERT INTO level_steps (level_id, "order", type, title, payload, created_at, updated_at)
  SELECT (SELECT id FROM get_level), 1, 'text', 'Как управлять долгами', '{"body":"Сосредоточьтесь на процентах и последовательности платежей."}'::jsonb, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM level_steps WHERE level_id = (SELECT id FROM get_level) AND "order" = 1
  )
  RETURNING id
)
INSERT INTO level_steps (level_id, "order", type, title, payload, question_id, created_at, updated_at)
SELECT (SELECT id FROM get_level), 2, 'question', 'Проверка знаний', '{}'::jsonb, (SELECT id FROM get_q), NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM level_steps WHERE level_id = (SELECT id FROM get_level) AND "order" = 2
);

-- Level 5: Основы инвестиций
WITH ins_level AS (
  INSERT INTO levels (title, topic, difficulty, reward_points, is_active, created_at, updated_at)
  SELECT 'Основы инвестиций', 'Инвестиции', 'medium', 75, TRUE, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM levels WHERE title = 'Основы инвестиций'
  )
  RETURNING id
),
get_level AS (
  SELECT id FROM ins_level
  UNION ALL
  SELECT id FROM levels WHERE title = 'Основы инвестиций'
),
ins_q AS (
  INSERT INTO questions (prompt, explanation, multi_select, created_at, updated_at)
  SELECT 'Какой инструмент обычно подходит для долгосрочных целей с умеренным риском?', 'Индексные фонды — диверсифицированный и простой вариант.', FALSE, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM questions WHERE prompt = 'Какой инструмент обычно подходит для долгосрочных целей с умеренным риском?'
  )
  RETURNING id
),
get_q AS (
  SELECT id FROM ins_q
  UNION ALL
  SELECT id FROM questions WHERE prompt = 'Какой инструмент обычно подходит для долгосрочных целей с умеренным риском?'
),
_c1 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), 'Индексные фонды (ETF)', TRUE, 1, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = 'Индексные фонды (ETF)'
  )
  RETURNING id
),
_c2 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), 'Лотерейные билеты', FALSE, 2, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = 'Лотерейные билеты'
  )
  RETURNING id
),
_c3 AS (
  INSERT INTO choices (question_id, text, is_correct, "order", created_at, updated_at)
  SELECT (SELECT id FROM get_q), 'Все средства на один пенни-сток', FALSE, 3, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM choices WHERE question_id = (SELECT id FROM get_q) AND text = 'Все средства на один пенни-сток'
  )
  RETURNING id
),
_s1 AS (
  INSERT INTO level_steps (level_id, "order", type, title, payload, created_at, updated_at)
  SELECT (SELECT id FROM get_level), 1, 'text', 'Принципы инвестирования', '{"body":"Диверсификация, долгий горизонт, низкие комиссии."}'::jsonb, NOW(), NOW()
  WHERE NOT EXISTS (
    SELECT 1 FROM level_steps WHERE level_id = (SELECT id FROM get_level) AND "order" = 1
  )
  RETURNING id
)
INSERT INTO level_steps (level_id, "order", type, title, payload, question_id, created_at, updated_at)
SELECT (SELECT id FROM get_level), 2, 'question', 'Проверка знаний', '{}'::jsonb, (SELECT id FROM get_q), NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM level_steps WHERE level_id = (SELECT id FROM get_level) AND "order" = 2
);

COMMIT;
