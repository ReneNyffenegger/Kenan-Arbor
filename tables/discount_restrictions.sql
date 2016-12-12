--
--  Discount and restriction id and their descriptions
--
select
  dd.discount_level,
  dr.discount_id,
  des.description_text      discount_desc,
  dr.restricted_id,
  dess.description_text     restricted_desc
from
  discount_restrictions dr                                                                          left join
  discount_definitions  dd   ON dr.discount_id        = dd.discount_id                              left join
  descriptions          des  ON des.description_code  = dd.discount_id   and des.language_code  = 1 left join
  descriptions          dess ON dess.description_code = dr.restricted_id and dess.language_code = 1
 where
  dd.discount_level = 2   -- account_level discount
order by
  dd.discount_level,
  dr.discount_id;
