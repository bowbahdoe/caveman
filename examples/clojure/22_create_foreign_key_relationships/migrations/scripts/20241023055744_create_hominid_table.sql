-- // create_hominid_table
CREATE TABLE prehistoric.hominid (
    id uuid NOT NULL DEFAULT uuidv7() PRIMARY KEY,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    "name" text,
    cave_id uuid REFERENCES prehistoric.cave (id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
);

CREATE TRIGGER set_prehistoric_hominid_updated_at
BEFORE UPDATE ON prehistoric.hominid
FOR EACH ROW
EXECUTE PROCEDURE prehistoric.set_current_timestamp_updated_at();

CREATE INDEX prehistoric_hominid_cave_id_idx
ON prehistoric.hominid
USING btree (cave_id);


-- //@UNDO
DROP TABLE prehistoric.hominid;