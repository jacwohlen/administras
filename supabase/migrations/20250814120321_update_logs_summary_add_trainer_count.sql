-- Drop the existing view
DROP VIEW IF EXISTS view_logs_summary;

-- Recreate the view with trainer count (using camelCase alias)
CREATE VIEW view_logs_summary
  WITH (security_invoker=on)
  AS
SELECT
  date, 
  "trainingId", 
  COUNT("memberId") as count,
  COUNT(CASE WHEN "isMainTrainer" = true THEN 1 END) as "trainerCount"
FROM
  logs 
GROUP BY 
  date, "trainingId";