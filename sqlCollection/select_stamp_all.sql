select subject_name, stamp.track_id, target_date, created_at 
from (track inner join stamp on track.id = stamp.track_id)