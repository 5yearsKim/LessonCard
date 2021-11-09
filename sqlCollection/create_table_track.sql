CREATE TABLE track (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	target_date TEXT,
	subject_name TEXT,
	stamp_name TEXT,
	max_stamp INTEGER,
	order_idx INTEGER,
  color TEXT,
	FOREIGN KEY(target_date) REFERENCES card(target_date)
	ON DELETE CASCADE
)