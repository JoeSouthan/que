DROP TRIGGER que_job_notify ON que_jobs;
DROP FUNCTION que_job_notify();
DROP TABLE que_lockers;

DROP INDEX que_jobs_poll_idx;

ALTER TABLE que_jobs
  RENAME COLUMN id TO job_id;

ALTER TABLE que_jobs
  DROP CONSTRAINT queue_length,
  DROP CONSTRAINT que_jobs_pkey,
  ADD COLUMN args JSON;

DELETE FROM que_jobs WHERE is_processed;

UPDATE que_jobs
  SET args = data->'args';

ALTER TABLE que_jobs
  DROP COLUMN is_processed,
  DROP COLUMN data,
  ALTER COLUMN args SET NOT NULL,
  ALTER COLUMN args SET DEFAULT '[]',
  ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id);
