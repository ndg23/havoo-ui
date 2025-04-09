-- Add start_date, end_date, and duration_unit columns to deals table
ALTER TABLE deals 
ADD COLUMN IF NOT EXISTS duration_unit VARCHAR(10) DEFAULT 'days' CHECK (duration_unit IN ('days', 'weeks', 'months'));

-- Create an index on end_date for faster deadline queries

-- Update existing deals to set start_date and end_date based on duration
UPDATE deals
SET 
  duration_unit = 'days'
WHERE duration IS NOT NULL;