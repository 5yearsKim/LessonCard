select target_date, stamp.id, track_id, created_at, note 
from (track inner join stamp on track.id = stamp.track_id)
where target_date = '2021-08-31'