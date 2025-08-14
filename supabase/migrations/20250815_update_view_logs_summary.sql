-- Update view_logs_summary to include lesson plan status
CREATE OR REPLACE VIEW "public"."view_logs_summary" WITH ("security_invoker"='on') AS
 SELECT "logs"."date",
    "logs"."trainingId",
    "count"("logs"."memberId") AS "count",
    "count"(
        CASE
            WHEN ("logs"."isMainTrainer" = true) THEN 1
            ELSE NULL::integer
        END) AS "trainerCount",
    CASE 
        WHEN "lesson_plans"."id" IS NOT NULL THEN true
        ELSE false
    END AS "hasLessonPlan"
   FROM "public"."logs"
   LEFT JOIN "public"."lesson_plans" ON (
       "lesson_plans"."training_id" = "logs"."trainingId" AND 
       "lesson_plans"."date" = "logs"."date"
   )
  GROUP BY "logs"."date", "logs"."trainingId", "lesson_plans"."id";