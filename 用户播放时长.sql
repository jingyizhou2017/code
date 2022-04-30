select
  user_id,
  during_total-diff as result
from
(
  select
    user_id,
    unix_timestamp(max(end_time))-unix_timestamp(min(start_time)) as during_total,
    sum(case when lead_start_time>max_end_time then unix_timestamp(lead_start_time)-unix_timestamp(max_end_time) else 0 end) as diff
  from
  (
      select *,
          coalesce(lead(start_time,1) over(partition by user_id order by start_time),end_time) as lead_start_time,
          max(end_time) over(partition by user_id order by start_time rows between unbounded preceding and current row) as max_end_time
      from temp.tmp_zjy_test_01
  ) as a
  group by 1
) as b


