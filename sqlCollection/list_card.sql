select card.target_date, card.note, count(track.id) as track_cnt
from card left join track
  on card.target_date = track.target_date
group by card.target_date