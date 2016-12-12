select
  description_code,
  max(case when language_code = 1 then description_text end)  t1,
  max(case when language_code = 4 then description_text end)  t4
from
  descriptions
group by
  description_code;
