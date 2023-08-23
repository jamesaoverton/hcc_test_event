INSERT INTO message
SELECT
  NULL AS message_id,
  'planned_event' AS 'table',
  row_number AS 'row',
  'min_start' AS 'column',
  min_start AS 'value',
  'error' AS 'level',
  'start_min_max' AS 'rule',
  'min_start must be less than max_start' AS 'message'
FROM planned_event
WHERE min_start > max_start;
