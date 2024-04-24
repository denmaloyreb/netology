============= представления =============

4. Создайте view с колонками клиент (ФИО; email) и title фильма, который он брал в прокат последним
+ Создайте представление:
* Создайте CTE, 
- возвращает строки из таблицы rental, 
- дополнено результатом row_number() в окне по customer_id
- упорядочено в этом окне по rental_date по убыванию (desc)
* Соеднините customer и полученную cte 
* соедините с inventory
* соедините с film
* отфильтруйте по row_number = 1

create view task_1 as
	select concat(c.last_name, ' ', c.first_name), c.email, f.title
	from customer c
	join (
		select *, row_number() over (partition by customer_id order by rental_date desc)
		from rental) r on r.customer_id = c.customer_id
	join inventory i on r.inventory_id = i.inventory_id
	join film f on f.film_id = i.film_id
	where row_number = 1

create view task_2 as

	explain analyze --2148.35 / 10
	select concat(c.last_name, ' ', c.first_name), c.email, f.title, c.customer_id, f.film_id
	from customer c
	join (
		select *, row_number() over (partition by customer_id order by rental_date desc)
		from rental) r on r.customer_id = c.customer_id
	join inventory i on r.inventory_id = i.inventory_id
	join film f on f.film_id = i.film_id
	where row_number = 1

explain analyze --2148.35 / 10
select *
from task_2 t 

join payment p on t.customer_id = p.customer_id

4.1. Создайте представление с 3-мя полями: название фильма, имя актера и количество фильмов, в которых он снимался
+ Создайте представление:
* Используйте таблицу film
* Соедините с film_actor
* Соедините с actor
* count - агрегатная функция подсчета значений
* Задайте окно с использованием предложений over и partition by

create view task_3 as 
	select concat(a.last_name, ' ', a.first_name), f.title, 
		count(*) over (partition by a.actor_id)
	from film f
	join film_actor fa on f.film_id = fa.film_id
	join actor a on a.actor_id = fa.actor_id
	
select *
from task_3

create view task_4 as 
	select *
	from payment p
	
	
select * --16 049
from task_4

insert into payment
values (20000,	1,	1,	76,	2.99,	'2005-05-25 11:30:37')

select * --16 050
from task_4
	
============= материализованные представления =============

5. Создайте материализованное представление с колонками клиент (ФИО; email) и title фильма, 
который он брал в прокат последним
Иницилизируйте наполнение и напишите запрос к представлению.
+ Создайте материализованное представление без наполнения (with NO DATA):
* Создайте CTE, 
- возвращает строки из таблицы rental, 
- дополнено результатом row_number() в окне по customer_id
- упорядочено в этом окне по rental_date по убыванию (desc)
* Соеднините customer и полученную cte 
* соедините с inventory
* соедините с film
* отфильтруйте по row_number = 1
+ Обновите представление
+ Выберите данные 

create materialized view task_5 as
	--explain analyze --2148.35 / 10
	select concat(c.last_name, ' ', c.first_name), c.email, f.title, c.customer_id, f.film_id
	from customer c
	join (
		select *, row_number() over (partition by customer_id order by rental_date desc)
		from rental) r on r.customer_id = c.customer_id
	join inventory i on r.inventory_id = i.inventory_id
	join film f on f.film_id = i.film_id
	where row_number = 1
with no data
	
select *
from task_5

refresh materialized view task_5

explain analyze --13.99 / 0.05
select *
from task_5

select 10 / 0.05

create materialized view task_6 as
	select * --16 050
	from payment
--with data

insert into payment
values (20001,	1,	1,	76,	2.99,	'2005-05-25 11:30:37')

select * --16 051
from task_4

select * --16 050
from task_6

refresh materialized view task_6

select * --16 051`
from task_6

5.1. Содайте наполенное материализованное представление, содержащее:
список категорий фильмов, средняя продолжительность аренды которых более 5 дней
+ Создайте материализованное представление с наполнением (with DATA)
* Используйте таблицу film
* Соедините с таблицей film_category
* Соедините с таблицей category
* Сгруппируйте полученную таблицу по category.name
* Для каждой группы посчитайте средню продолжительность аренды фильмов
* Воспользуйтесь фильтрацией групп, для выбора категории со средней продолжительностью > 5 дней
 + Выберите данные

create materialized view task_7 as
	select c."name"
	from film f
	join film_category fc on f.film_id = fc.film_id
	join category c on c.category_id = fc.category_id
	group by c.category_id 
	having  avg(f.rental_duration) > 5
	
explain analyze --18.50 / 0.01
select *
from task_7
 
--запрос на проверку времени обновления мат представлений

WITH pgdata AS (
    SELECT setting AS path
    FROM pg_settings
    WHERE name = 'data_directory'
),
path AS (
    SELECT
    	CASE
            WHEN pgdata.separator = '/' THEN '/'    -- UNIX
            ELSE '\'                                -- WINDOWS
        END AS separator
    FROM 
        (SELECT SUBSTR(path, 1, 1) AS separator FROM pgdata) AS pgdata
)
SELECT
        ns.nspname||'.'||c.relname AS mview,
        (pg_stat_file(pgdata.path||path.separator||pg_relation_filepath(ns.nspname||'.'||c.relname))).modification AS refresh
FROM pgdata, path, pg_class c
JOIN pg_namespace ns ON c.relnamespace=ns.oid
WHERE c.relkind='m';

названием_схемы | название_мат_вью | кто_обновлял | дата+время_начала_обновления | дата+время_окончания_обновления | статус | err_msg


============ Индексы ===========

btree = > < between null
hash =
gist
gin

таблица 
столбец
строка
страница = 8кб

select * 
from film f

1 строка = 100 байт
1 страница = 80 строк

1 строка = 100мб
1 строка = 12800 страниц

select 100*1024/8

explain analyze --1979.76 / 9
select *
from task_2 
where lower(left(concat, 1)) = 'a'

explain analyze --18.48 / 0.23 Seq Scan on task_5 
select *
from task_5 
where lower(left(concat, 1)) = 'a'

create index first_letter_idx on task_5 (lower(left(concat, 1)))

explain analyze --10.71 / 0.05 Bitmap Heap Scan 
select *
from task_5 
where lower(left(concat, 1)) = 'a'

select * 
from film f

alter table film drop constraint film_pkey cascade

0 индексов - 472кб

explain (analyze, buffers) --Seq Scan on film f  (cost=0.00..67.50 rows=1 width=386) (actual time=0.032..0.187 rows=1 loops=1)
select * 
from film f
where film_id = 37

55 страниц

alter table film add constraint film_pkey primary key (film_id)

explain (analyze, buffers) --Index Scan using film_pkey on film f  (cost=0.28..8.29 rows=1 width=386) (actual time=0.021..0.016 rows=1 loops=1)
select * 
from film f
where film_id = 37

2 страницы

explain (analyze, buffers) --Index Scan using film_pkey on film f  (cost=0.28..8.47 rows=8 width=386) (actual time=0.015..0.024 rows=8 loops=1)
select * 
from film f
where film_id between 30 and 37

create index film_id_hash_idx on film using hash (film_id)

explain (analyze, buffers) --Index Scan using film_id_hash_idx on film f  (cost=0.00..8.02 rows=1 width=386) (actual time=0.032..0.015 rows=1 loops=1)
select * 
from film f
where film_id = 37

explain (analyze, buffers) --Index Scan using film_id_hash_idx on film f  (cost=0.00..8.02 rows=1 width=386) (actual time=0.032..0.015 rows=1 loops=1)
select * 
from film f
where film_id < 650

2 индекса - 560 кб

create index strange_1_idx on film (title, rental_rate, rental_duration, length) --title || rental_rate || rental_duration || length

create index strange_2_idx on film (rental_rate, rental_duration, length, title) --rental_duration || rental_rate || length || title

explain (analyze, buffers) --Index Scan using strange_1_idx on film f  (cost=0.28..56.86 rows=7 width=386) (actual time=0.068..0.111 rows=5 loops=1)
select * 
from film f
where rental_duration = 5 and length > 180

explain (analyze, buffers) --Index Scan using strange_1_idx on film f  (cost=0.28..56.86 rows=7 width=386) (actual time=0.068..0.111 rows=5 loops=1)
select * 
from film f
where rental_duration = 5 and length > 180

select title || rental_rate || rental_duration || length
from film f

select rental_duration::text || rental_rate || length || title
from film f

4 индекса - 688 кб

explain --Seq Scan on payment  (cost=0.00..359.74 rows=80 width=26)
select *
from payment 
where payment_date::date = '01.08.2005'

create index payment_date_idx on payment (payment_date)

create index payment_date_2_idx on payment (cast(payment_date as date))

explain --Index Scan using payment_date_2_idx on payment  (cost=0.29..821.18 rows=16051 width=30)
select *
from payment 
order by payment_date::date

explain --  ->  Bitmap Index Scan on payment_date_2_idx  (cost=0.00..4.88 rows=80 width=0) Bitmap Heap Scan on payment  (cost=4.90..118.29 rows=80 width=26)
select *
from payment 
where payment_date::date = '01.08.2005'

create index strange_3_idx on film (rental_rate, rental_duration, length, title, description) 

create index strange_4_idx on film (rental_rate, rental_duration, length, title, description) 

create index strange_5_idx on film (rental_rate, rental_duration, length, title, description) 

create index strange_6_idx on film (rental_rate, rental_duration, length, title, description) 

0 индексов - 472кб
8 индекса - 1.3 мб

insert 1+8 = 9
update title = 1 + 6
update special_features = 1 + 8
update or delete 

explain (analyze, buffers) --Index only Scan using film_id_hash_idx on film f  (cost=0.00..8.02 rows=1 width=386) (actual time=0.032..0.015 rows=1 loops=1)
select film_id 
from film f
where film_id = 1

============ explain ===========

Ссылка на сервис по анализу плана запроса 
https://explain.depesz.com/ -- открывать через ВПН
https://tatiyants.com/pev/
https://habr.com/ru/post/203320/

explain analyze
select concat(c.last_name, ' ', c.first_name), c.email, f.title
from customer c
join (
	select *, row_number() over (partition by customer_id order by rental_date desc)
	from rental) r on r.customer_id = c.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
where row_number = 1

explain (analyze, buffers, format json)
select concat(c.last_name, ' ', c.first_name), c.email, f.title
from customer c
join (
	select *, row_number() over (partition by customer_id order by rental_date desc)
	from rental) r on r.customer_id = c.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
where row_number = 1

======================== json ========================

СЛОЖНЫЕ ТИПЫ ДАННЫХ НЕЛЬЗЯ ПРИВОДИТЬ К СТРОКЕ, НЕДОПУСТИМО, ПЛОХО И УЖАСНО.

contacts::text ilike '%+7%'

json - долго и нудно
jsonb - быстро и здорово



Создайте таблицу orders

CREATE TABLE orders_2 (
     ID serial PRIMARY KEY,
     info json NOT NULL
);

INSERT INTO orders_2 (info)
VALUES
 (
'{"items": {"product": "Beer","qty": 6,"a":345}, "customer": "John Doe"}'
 ),
 (
'{ "customer": "Lily Bush", "items": {"product": "Diaper","qty": 24.5}}'
 ),
 (
'{ "customer": "Josh William", "items": {"product": "Toy Car","qty": 1}}'
 ),
 (
'{ "customer": "Mary Clark", "items": {"product": "Toy Train","qty": 2}}'
 );

 
INSERT INTO orders_2 (info)
VALUES
 (
'{"items": {"product": "01.01.2023","qty": "fgdfgh"}, "customer": "John Doe"}'
 )

INSERT INTO orders_2 (info)
VALUES
 (
'{ "a": { "a": { "a": { "a": { "a": { "c": "b"}}}}}}'
 )

select * from orders

|{название_товара: quantity, product_id: quantity, product_id: quantity}|общая сумма заказа|

6. Выведите общее количество заказов:
* CAST ( data AS type) преобразование типов
* SUM - агрегатная функция суммы
* -> возвращает JSON
*->> возвращает текст

select info, pg_typeof(info)
from orders_2

select info->'items', pg_typeof(info->'items')
from orders_2

select info->'items'->'qty', pg_typeof(info->'items'->'qty')
from orders_2

select info->'items'->>'qty', pg_typeof(info->'items'->>'qty')
from orders_2

select sum((info->'items'->>'qty')::numeric)
from orders_2
where info->'items'->>'qty' ~ '[0-9]'

6*  Выведите среднее количество заказов, продуктов начинающихся на "Toy"

select avg((info->'items'->>'qty')::numeric)
from orders_2
where info->'items'->>'qty' ~ '[0-9]' and info->'items'->>'product' ilike 'toy%'

select json_object_keys(info->'items')
from orders_2

select *
from orders

======================== array ========================
7. Выведите сколько раз встречается специальный атрибут (special_features) у
фильма -- сколько элементов содержит атрибут special_features
* array_length(anyarray, int) - возвращает длину указанной размерности массива

time[] ['10:00', '16:00']
int[] [123145,5374567,6796709]
text[] ['100', '01.01.2024', 'dfknafdgkhlb']

create table some_arr (
	id serial, 
	val int[])
	
insert into some_arr(val)
values (array[5,8,12]), ('{4,7,11}'::int[])

select val[1]
from some_arr

update some_arr
set val[-10] = 100
where id = 1

select *
from some_arr

[-10:3]={100,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,8,12}

-3:5
-2:8
-1:-8
0:5
1:7
2:2
	
	8
				7

5			5


					2

-3	-2	-1	0	1	2

select title, array_length(special_features, 1)
from film 

select array_length('{{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3}}'::text[], 1) --9

select array_length('{{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3}}'::text[], 2) --3

select cardinality('{{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3},{1,2,3}}'::text[]) --27

select title, special_features || array['sdgsdfg', 'fgjdfhjg']
from film 

select title, array_upper(special_features || array['sdgsdfg', 'fgjdfhjg'], 1)
from film 

select title, array_lower(special_features || array['sdgsdfg', 'fgjdfhjg'], 1)
from film 

select title, array_append(special_features, 'djkhfbgljkhdfbifd')
from film 

7* Выведите все фильмы содержащие специальные атрибуты: 'Trailers'
* Используйте операторы:
@> - содержит
<@ - содержится в
*  ARRAY[элементы] - для описания массива

https://postgrespro.ru/docs/postgresql/14/functions-subquery
https://postgrespro.ru/docs/postgrespro/14/functions-array

-- ТАК НЕЛЬЗЯ (0 БАЛЛОВ В ИТОГОВОЙ)--
select title, special_features --535
from film 
where special_features::text ilike '%Trailers%'

Trailers
Trailers1
Trailers2

-- ПЛОХАЯ ПРАКТИКА --
select title, special_features --535
from film 
where special_features[1] = 'Trailers' or special_features[2] = 'Trailers' or 
	special_features[3] = 'Trailers' or special_features[4] = 'Trailers' 
	
-- ЧТО-ТО СРЕДНЕЕ ПРАКТИКА --
select f.* --535
from (
	select film_id, title, unnest(special_features)
	from film) t
join film f on f.film_id = t.film_id
where unnest = 'Trailers'

select title, special_features --535
from film
where 'Trailers' in (select unnest(special_features))

-- ХОРОШАЯ ПРАКТИКА --

select title, special_features --535
from film
where special_features && array['Trailers', 'shjkdfgbil']

select title, special_features --535
from film
where special_features @> array['Trailers']

select title, special_features --72
from film
where special_features <@  array['Trailers']

2 + 3 = 3 + 2

select title, special_features --535
from film
where 'Trailers' = any(special_features) --some

select title, special_features --72
from film
where 'Trailers' = all(special_features) 

select title, special_features --535
from film
where 'Trailers' != any(special_features) --some

select title, special_features --72
from film
where 'Trailers' != all(special_features) 

select title, array_position(special_features, 'Deleted Scenes')
from film

select title, array_positions(array_append(special_features, 'Deleted Scenes'), 'Deleted Scenes')
from film