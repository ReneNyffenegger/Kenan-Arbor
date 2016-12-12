select
  *
from
  discount_definitions
where
  sysdate between date_active AND NVL(date_inactive, date '9999-12-31');
