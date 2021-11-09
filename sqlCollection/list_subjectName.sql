SELECT subject_name, color, stamp_name, max_stamp 
FROM (select * from track order by target_date desc)
group by subject_name;