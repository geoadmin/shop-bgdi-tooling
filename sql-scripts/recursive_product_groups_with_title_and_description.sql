with recursive rek_product_groups as (
        select  ARRAY[pk_product_group] as hierarchy, pk_product_group, fk_parent_group, s_identifier, s_title_de, s_subtitle_de, s_description_de, 1 as lvl
        from            tbl_product_group
        where   fk_parent_group is null
        union all
        select  q.hierarchy || pg.pk_product_group, pg.pk_product_group, pg.fk_parent_group, pg.s_identifier, pg.s_title_de, pg.s_subtitle_de, pg.s_description_de, q.lvl + 1
        from            rek_product_groups as q
        join            tbl_product_group pg on pg.fk_parent_group = q.pk_product_group
)
select  pg.lvl, pg.pk_product_group, pg.fk_parent_group, '.' || lpad(' ', 8*(pg.lvl-1)) || pg.s_identifier as id_tree, pg.s_identifier, pg.s_title_de, pg.s_subtitle_de, pg.s_description_de
,               (select count(*) from tbl_product p where p.fk_product_group = pg.pk_product_group and p.b_active = true) as product_count
from            rek_product_groups as pg
order by  pg.hierarchy
;
