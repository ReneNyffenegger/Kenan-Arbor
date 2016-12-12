select
  count(*)   
from
  customer_contracts   ccn                                                                                               join
  contract_types       cty ON ccn.contract_type = cty.contract_type                                                 and
                                      sysdate between ccn.start_dt    and NVL(ccn.end_dt       , date '9999-12-31') and
                                      sysdate between cty.active_date and NVL(cty.inactive_date, date '9999-12-31')      join
  discount_plans       dpl ON cty.plan_id_discount = dpl.plan_id_discount                                                join
  discount_definitions ddf ON dpl.discount_id      = ddf.discount_id                                                and
                                      sysdate between ddf.date_active and NVL(ddf.date_inactive, date '9999-12-31')      join
  descriptions         cds ON ccn.contract_type    = cds.description_code                                           and
                                      cds.language_code    = 1                                                           join
 (
       select
          discount_id,
          discount_percent,
          implied_decimals,
          discount_amount,
          currency_code,
          date_active,
          date_inactive,
          billing_frequency,
          row_number() over (partition by discount_id order by date_active desc) as ded_seq
       from
          rate_discount
  )                            rds  ON ddf.discount_id = rds.discount_id and
                                       rds.billing_frequency = 3         and -- monthly
                                       rds.ded_seq           = 1         and
                                           sysdate between rds.date_active and nvl(rds.date_inactive, date '9999-12-31') join
       rate_currency_values rcv on rds.currency_code  = rcv.currency_code             and
                                           rcv.language_code  = 1;
