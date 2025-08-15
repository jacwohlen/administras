-- Create lesson_plans table
CREATE TABLE IF NOT EXISTS public.lesson_plans (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "trainingId" smallint NOT NULL REFERENCES public.trainings(id) ON DELETE CASCADE,
  date        text NOT NULL,
  title       text,
  content     text NOT NULL,
  created_at  timestamptz DEFAULT now(),
  updated_at  timestamptz DEFAULT now(),
  created_by  uuid REFERENCES auth.users(id),
  UNIQUE ("trainingId", date)
);

-- Create RLS policies
ALTER TABLE public.lesson_plans ENABLE ROW LEVEL SECURITY;

-- Policy to allow authenticated users to read all lesson plans
CREATE POLICY "Allow authenticated users to read lesson plans" ON public.lesson_plans
    FOR SELECT
    TO authenticated
    USING (true);

-- Policy to allow authenticated users to insert lesson plans
CREATE POLICY "Allow authenticated users to create lesson plans" ON public.lesson_plans
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- Policy to allow authenticated users to update lesson plans
CREATE POLICY "Allow authenticated users to update lesson plans" ON public.lesson_plans
    FOR UPDATE
    TO authenticated
    USING (true);

-- Policy to allow authenticated users to delete lesson plans
CREATE POLICY "Allow authenticated users to delete lesson plans" ON public.lesson_plans
    FOR DELETE
    TO authenticated
    USING (true);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_lesson_plans_updated_at BEFORE UPDATE
    ON public.lesson_plans FOR EACH ROW EXECUTE PROCEDURE 
    update_updated_at_column();
