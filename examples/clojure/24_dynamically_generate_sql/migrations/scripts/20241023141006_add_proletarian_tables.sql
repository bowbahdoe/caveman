-- // add_proletarian_tables
CREATE SCHEMA IF NOT EXISTS proletarian;

CREATE TABLE IF NOT EXISTS proletarian.job (
    job_id      UUID PRIMARY KEY DEFAULT uuidv7(),   -- job id, generated and returned by proletarian.job/enqueue!
    queue       TEXT      NOT NULL DEFAULT ':proletarian/default', -- queue name
    job_type    TEXT      NOT NULL, -- job type
    payload     TEXT      NOT NULL, -- Transit-encoded job data
    attempts    INTEGER   NOT NULL DEFAULT 0, -- Number of attempts. Starts at 0. Increments when the job is processed.
    enqueued_at TIMESTAMP NOT NULL DEFAULT now(), -- When the job was enqueued (never changes)
    process_at  TIMESTAMP NOT NULL DEFAULT now()  -- When the job should be run (updates every retry)
);

CREATE TABLE IF NOT EXISTS proletarian.archived_job (
    job_id      UUID PRIMARY KEY,   -- Copied from job record.
    queue       TEXT      NOT NULL, -- Copied from job record.
    job_type    TEXT      NOT NULL, -- Copied from job record.
    payload     TEXT      NOT NULL, -- Copied from job record.
    attempts    INTEGER   NOT NULL, -- Copied from job record.
    enqueued_at TIMESTAMP NOT NULL, -- Copied from job record.
    process_at  TIMESTAMP NOT NULL, -- Copied from job record (data for the last run only)
    status      TEXT      NOT NULL, -- success / failure
    finished_at TIMESTAMP NOT NULL  -- When the job was finished (success or failure)
);

CREATE INDEX job_queue_process_at ON proletarian.job (queue, process_at);

-- //@UNDO
DROP TABLE proletarian.archived_job;

DROP TABLE proletarian.job;

DROP SCHEMA proletarian;


