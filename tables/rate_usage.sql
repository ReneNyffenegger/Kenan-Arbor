select
    rpv.display_value,
    d.description_text usg_type_desc,
    d2.description_text jurisdiction_desc,
    pcv.display_value point_class_target_desc,
    add_fixed_amt/power(10,rusg.add_implied_decimal)/100 fixed_amount,
    add_unit_rate/power(10,rusg.add_implied_decimal)/100 add_unit_rate
from
    rate_usage          rusg                                                                        join
    rate_period_values  rpv  on rpv.rate_period=rusg.rate_period                                    join
    usage_types         ut   on ut.type_id_usg=rusg.type_id_usg                                left join
    descriptions        d    on ut.description_code=d.description_code                         left join
    jurisdictions       j    on rusg.jurisdiction=j.jurisdiction                               left join
    descriptions        d2   on j.description_code=d2.description_code  AND d2.language_code=1 left join
    point_class_values  pcv  on rusg.point_class_target=pcv.point_class AND pcv.language_code=1
where
    rusg.element_id=7000014 and -- Freephone Weekend Usage
    rpv.language_code=1     and
    trunc(sysdate) between active_dt and nvl(inactive_dt, date '9999-12-31') and
    d.language_code=1
order by
    ut.type_id_usg,
    rusg.jurisdiction,
    rusg.point_class_target;
