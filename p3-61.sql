	 a 					     b
a_id | a_val		b_id | b_val | a_id

	 			     ab
a.a_id | a.a_val | b.b_id | b.b_val | b.a_id
1
2
3

============= теория =============

create table table_one (
	name_one varchar(255) not null
);

create table table_two (
	name_two varchar(255) not null
);

insert into table_one (name_one)
values ('one'), ('two'), ('three'), ('four'), ('five');

insert into table_two (name_two)
values ('four'), ('five'), ('six'), ('seven'), ('eight');

select * from table_one;

select * from table_two;

--left outer, right, inner, full, cross

select table_one.name_one, table_two.name_two
from table_one
inner join table_two on table_one.name_one = table_two.name_two

select table_one.name_one, table_two.name_two
from table_one
join table_two on table_one.name_one = table_two.name_two

select t1.name_one, t2.name_two
from table_one t1
join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1 
left join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1 
right join table_two t2 on t1.name_one = t2.name_two

--нужно получить пользователей с адресами --594
select c.customer_id, a.address
from customer c
join address a on a.address_id = c.address_id

--нужно получить всех пользователей и их адреса --599
select c.customer_id, a.address
from customer c
left join address a on a.address_id = c.address_id

--нужно найти пользователей без адресов
select c.customer_id, a.address
from customer c
left join address a on a.address_id = c.address_id
where a.address_id is null

--нужно получить все адреса и добавить данные по пользователям --603
select c.customer_id, a.address
from customer c
right join address a on a.address_id = c.address_id

select c.customer_id, a.address
from customer c
right join address a on a.address_id = c.address_id
where c.customer_id is null

select t1.name_one, t2.name_two
from table_one t1 
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select t1.name_one, t2.name_two
from table_one t1 
cross join table_two t2

select t1.name_one, t2.name_two
from table_one t1, table_two t2

select t1.name_one, t2.name_two
from table_one t1, table_two t2
where t1.name_one = t2.name_two

select c1.first_name, c2.first_name --358 801
from customer c1, customer c2

select distinct c1.first_name, c2.first_name --349 281
from customer c1, customer c2

select distinct c1.first_name, c2.first_name --348 690
from customer c1, customer c2
where c1.first_name != c2.first_name

select distinct c1.first_name, c2.first_name --174 345
from customer c1, customer c2
where c1.first_name > c2.first_name

--AARON	ADAM
ADAM	AARON

select 'Ян' < 'Яна'

SQL Error [42712]: ОШИБКА: имя таблицы "customer" указано больше одного раза

40 точек

delete from table_one;
delete from table_two;

insert into table_one (name_one)
select unnest(array[1,1,2]);

insert into table_two (name_two)
select unnest(array[1,1,3]);

select * from table_one

select * from table_two

select t1.name_one, t2.name_two
from table_one t1
join table_two t2 on t1.name_one = t2.name_two

1A	1B
1a	1b
2c	3d

1A1B
1A1b
1a1B
1a1b

select t1.name_one, t2.name_two
from table_one t1 
left join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1 
right join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1 
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select t1.name_one, t2.name_two
from table_one t1, table_two t2

select count(*) --599
from customer c

select count(*) --16049
from payment p

select count(*) --16044
from rental r

--ЛОЖНЫЙ ЗАПРОС
select count(*) --445483
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.customer_id = c.customer_id

	payment_customer
p.customer_id | c.customer_id
1				1
1				1
1				1

--ВЕРНЫЙ ЗАПРОС
select count(*) --16049
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.rental_id = p.rental_id

--ЛОЖНЫЙ ЗАПРОС
select tc.table_schema, tc.table_name, tc.constraint_type, tc.constraint_name, kcu.column_name
from information_schema.table_constraints tc
join information_schema.key_column_usage kcu on tc.constraint_name = kcu.constraint_name
where tc.table_schema = 'public' and tc.constraint_type = 'PRIMARY KEY'

public address address_pkey			public address address_pkey
hr address address_pkey				hr address address_pkey

--ВЕРНЫЙ ЗАПРОС
select tc.table_schema, tc.table_name, tc.constraint_type, tc.constraint_name, kcu.column_name
from information_schema.table_constraints tc
join information_schema.key_column_usage kcu 
	on tc.constraint_name = kcu.constraint_name
	and tc.table_name = kcu.table_name
	and tc.table_schema = kcu.table_schema
where tc.table_schema = 'public' and tc.constraint_type = 'PRIMARY KEY'

--union / except / intersect

select lower(first_name) --599
from customer 
union --distinct
select lower(first_name) --2
from staff 
--591

select lower(first_name) --599
from customer 
union all
select lower(first_name) --2
from staff 
--601

select *
from (
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 2 as y)
except --distinct
select 1 as x, 1 as y

select *
from (
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 2 as y)
except all
(select 1 as x, 1 as y
union all
select 1 as x, 1 as y)

select lower(first_name) --599
from customer 
intersect
select lower(first_name) --2
from staff 

select *
from (
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 2 as y)
intersect --distinct
(select 1 as x, 1 as y
union all
select 1 as x, 1 as y)

select *
from (
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 1 as y
	union all
	select 1 as x, 2 as y)
intersect all
(select 1 as x, 1 as y
union all
select 1 as x, 1 as y)

-- case
< 5 - малый платеж
5 - 10 средний платеж
> 10 большой платеж

if  then
elsif then
else
end if

case
	when then
	else
end

select some_case, count(*)
from (
	select amount,
		case 
			when amount < 5 then 'малый платеж' 
			when amount between 5 and 10 then 'средний платеж' 
			--when amount > 10 then 'большой платеж' 
			else 'большой платеж' 
		end some_case
	from payment)
group by some_case

/*
select "case"."case"
from (
	select amount,
		case 
			when amount < 5 then 'малый платеж' 
			when amount between 5 and 10 then 'средний платеж' 
			--when amount > 10 then 'большой платеж' 
			else 'большой платеж' 
		end 
	from payment) as "case"
*/

	
============= соединения =============

1. Выведите список названий всех фильмов и их языков
* Используйте таблицу film
* Соедините с language
* Выведите информацию о фильмах:
title, language."name"

select f.title, l."name"
from film f 
join "language" l on l.language_id = f.language_id

1. Выведите все фильмы и их категории:
* Используйте таблицу film
* Соедините с таблицей film_category
* Соедините с таблицей category
* Соедините используя оператор using

select f.film_id, fc.film_id
from film f
left join film_category fc on f.film_id = fc.film_id
join category c on c.category_id = fc.category_id

select film_id
from film f
left join film_category fc using(film_id)
join category c using(category_id)

select f.title, c."name"
from film f
left join film_category fc using(film_id) and fc.category_id = 1
join category c using(category_id)

select *
from customer c
join store s using(store_id)
join staff s2 using(store_id)
join address a on a.address_id = c.address_id

2. Выведите уникальный список фильмов, которые брали в аренду '24-05-2005'. 
* Используйте таблицу film
* Соедините с inventory
* Соедините с rental
* Отфильтруйте, используя where 

select distinct title, r.rental_date::date
from film f
join inventory i on f.film_id = i.film_id
join rental r on r.inventory_id = i.inventory_id and r.rental_date::date = '24-05-2005'

select distinct title, r.rental_date::date
from film f
join inventory i on f.film_id = i.film_id
join rental r on r.inventory_id = i.inventory_id 
where r.rental_date::date = '24-05-2005'

select distinct title, r.rental_date::date
from film f
join inventory i on f.film_id = i.film_id
left join rental r on r.inventory_id = i.inventory_id and r.rental_date::date = '24-05-2005'

select distinct title, r.rental_date::date
from film f
join inventory i on f.film_id = i.film_id
left join rental r on r.inventory_id = i.inventory_id 
where r.rental_date::date = '24-05-2005'

select distinct title, r.rental_date::date
from film f
join inventory i on f.film_id = i.film_id
left join rental r on r.inventory_id = i.inventory_id and r.rental_date::date = '24-05-2005'
where r.rental_id is null

2.1 Выведите все магазины из города Woodridge (city_id = 576)
* Используйте таблицу store
* Соедините таблицу с address 
* Соедините таблицу с city 
* Соедините таблицу с country 
* отфильтруйте по "city_id"
* Выведите полный адрес искомых магазинов и их id:
store_id, postal_code, country, city, district, address, address2, phone

--ЛОЖНЫЙ ЗАПРОС
select store_id, postal_code, country, city, district, address, address2, phone
from store s
join address a on a.address_id = s.address_id and a.city_id = 576
join city c on c.city_id = a.address_id
join country c2 on c2.country_id = c.country_id

--ЛОЖНЫЙ ЗАПРОС
select store_id, postal_code, country, city, district, address, address2, phone
from store s
join address a on a.address_id = s.address_id and a.city_id = 576
join city c on c.city_id = a.city_id
join country c2 on c2.country_id = c2.country_id

--ВЕРНЫЙ ЗАПРОС
select store_id, postal_code, country, city, district, address, address2, phone
from store s
join address a on a.address_id = s.address_id and a.city_id = 576
join city c on c.city_id = a.city_id
join country c2 on c2.country_id = c.country_id

============= агрегатные функции =============

sum 
avg 
count 
min 
max 
array_agg()
string_agg()

3. Подсчитайте количество актеров в фильме Grosse Wonderful (id - 384)
* Используйте таблицу film
* Соедините с film_actor
* Отфильтруйте, используя where и "film_id" 
* Для подсчета используйте функцию count, используйте actor_id в качестве выражения внутри функции
* Примените функцильные зависимости

select count(*)
from film_actor fa
where film_id = 384

--ЛОЖНЫЕ ЗАПРОСЫ ДО ВЕРНЫХ
select f.title, count(*)
from film_actor fa
join film f on f.film_id = fa.film_id
group by f.title

SQL Error [42803]: ОШИБКА: столбец "f.title" должен фигурировать в предложении GROUP BY или использоваться в агрегатной функции

Grosse Wonderful	4
Grosse Wonderful
Grosse Wonderful
Grosse Wonderful

Grosse Wonderful	4

select f.title, count(*), f.release_year, f.language_id, f.rental_duration, f.rental_rate
from film_actor fa
join film f on f.film_id = fa.film_id
group by f.title, f.release_year, f.language_id, f.rental_duration, f.rental_rate


--ВЕРНЫЙ ЗАПРОС
select count(*)
from payment 

select f.title, count(*), f.release_year, f.language_id, f.rental_duration, f.rental_rate
from film_actor fa
join film f on f.film_id = fa.film_id
group by f.film_id

select f.rental_duration, f.rental_rate, count(*)
from film_actor fa
join film f on f.film_id = fa.film_id
group by f.rental_duration, f.rental_rate

3.1 Посчитайте среднюю стоимость аренды за день по всем фильмам
* Используйте таблицу film
* Стоимость аренды за день rental_rate/rental_duration
* avg - функция, вычисляющая среднее значение
--4 агрегации

select count(*), count(1), count('не столбец/значение, а просто что-то'), count(address_id)
from customer 

select count(*), count(distinct customer_id), sum(amount), avg(amount), min(amount), max(amount)
from payment 

select count(*), count(distinct customer_id), sum(amount), avg(amount), min(amount), max(amount)
from payment 

select f.rental_duration, f.rental_rate, count(*),
	string_agg(distinct concat(a.last_name, ' ', a.first_name), ', ' order by concat(a.last_name, ' ', a.first_name))
from film_actor fa
join film f on f.film_id = fa.film_id
join actor a on a.actor_id = fa.actor_id
group by f.rental_duration, f.rental_rate

3.2 нужно получить данные по 5 платежу каждому пользователя.

select p.*
from (
	select customer_id, array_agg(payment_id order by payment_date)
	from payment 
	group by customer_id) t
join payment p on p.payment_id = t.array_agg[5]
	
============= группировки =============

4. Выведите месяцы, в которые было сдано в аренду более чем на 10 000 у.е.
* Используйте таблицу payment
* Сгруппируйте данные по месяцу используя date_trunc
* Для каждой группы посчитайте сумму платежей
* Воспользуйтесь фильтрацией групп, для выбора месяцев с суммой продаж более чем на 10 000 у.е.

explain
select date_trunc('month', payment_date), sum(amount)
from payment 
group by date_trunc('month', payment_date)
having sum(amount) > 10000 and date_trunc('month', payment_date) < '01.08.2005'

select date_trunc('month', payment_date), sum(amount)
from payment 
where date_trunc('month', payment_date) < '01.08.2005'
group by date_trunc('month', payment_date)
having sum(amount) > 10000 

select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
where customer_id < 3
group by customer_id, staff_id, date_trunc('month', payment_date)


select customer_id c, staff_id s, date_trunc('month', payment_date) d, sum(amount)
from payment 
where customer_id < 3
group by c, s, d

select customer_id c, staff_id s, date_trunc('month', payment_date) d, sum(amount)
from payment 
where customer_id < 3
group by 1, 2, 3
order by 1, 2, 3

select date_trunc('month', payment_date), customer_id, sum(amount)
from payment 
where customer_id < 3
group by 1, 2

select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
where customer_id < 3
group by 1, 2, 3
order by 1, 2, 3

select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
where customer_id < 3
group by grouping sets(1, 2, 3)
order by 1, 2, 3

select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
where customer_id < 3
group by grouping sets(1, 2, 3), grouping sets(2)
order by 1, 2, 3

select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
where customer_id < 3
group by grouping sets(customer_id, staff_id, date_trunc('month', payment_date)), grouping sets(customer_id), grouping sets(staff_id)
order by 1, 2, 3

select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
where customer_id < 3
group by cube(1, 2, 3)
order by 1, 2, 3

explain analyze --30
select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
group by cube(1, 2, 3)
order by 1, 2, 3

50 * 2 = 100

create temporary table some_pay as (
	select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
	from payment 
	group by cube(1, 2, 3)
	order by 1, 2, 3)
	
10

explain analyze --0.5

select *
from some_pay
where customer_id is not null and staff_id is null and date_trunc is not null

select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
where customer_id < 3
group by rollup(1, 2, 3)
order by 1, 2, 3

Россия - ФО - области - города - улицы
ФО - области - города - улицы
области - города - улицы
города - улицы
улицы

4.0.1 найти сумму платежей пользователей, где размер платежа меньше 5 у.е и сумму платежей пользователей, 
	где размер платежа больше или равен 5 у.е

select customer_id, 
	sum(case when amount < 5 then amount end), 
	sum(case when amount >= 5 then amount end)
from payment
group by customer_id

select customer_id, 
	sum(amount) filter (where amount < 5), 
	sum(amount) filter (where amount >= 5)
from payment
group by customer_id

4.1 Выведите список категорий фильмов, средняя продолжительность аренды которых более 5 дней
* Используйте таблицу film
* Соедините с таблицей film_category
* Соедините с таблицей category
* Сгруппируйте полученную таблицу по category.name
* Для каждой группы посчитайте средню продолжительность аренды фильмов
* Воспользуйтесь фильтрацией групп, для выбора категории со средней продолжительностью > 5 дней

select c."name"
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by c.category_id
having avg(rental_duration) > 5

============= подзапросы =============

select (select (select (select 1) 2) 3) 4

-- ошибка 
select 
from (select from )
join (select from )
join (select from )
join (select from )

select 
from table 
join table
join table
join table

--хорошо
select 
from (select avg from )
join (select sum from )
join (select min from )
join (select max from )

5. Выведите количество фильмов, со стоимостью аренды за день больше, 
чем среднее значение по всем фильмам
* Напишите подзапрос, который будет вычислять среднее значение стоимости 
аренды за день (задание 3.1)
* Используйте таблицу film
* Отфильтруйте строки в результирующей таблице, используя опретаор > (подзапрос)
* count - агрегатная функция подсчета значений

скаляр - не имеет алиаса и используется в select, условии и в cross join
одномерный массив - не имеет алиаса используется в условиях
таблицу - обязательно алиас используется во from и join 

select avg(rental_rate / rental_duration) from film 

select count(*)
from film 
where rental_rate / rental_duration > (select avg(rental_rate / rental_duration) from film)

select customer_id, sum(amount) * 100. / (select sum(amount) from payment)
from payment 
group by customer_id

select sum(amount) from payment 

select *
from payment 
where (customer_id, payment_date) in (
	select customer_id, max(payment_date)
	from payment 
	group by customer_id)

6. Выведите фильмы, с категорией начинающейся с буквы "C"
* Напишите подзапрос:
 - Используйте таблицу category
 - Отфильтруйте строки с помощью оператора like 
* Соедините с таблицей film_category
* Соедините с таблицей film
* Выведите информацию о фильмах:
title, category."name"
* Используйте подзапрос во from, join, where

select category_id, "name"
from category 
where "name" like 'C%'

explain analyse
select f.title, t.some_alias
from (
	select category_id, name some_alias
	from category c
	where "name" like 'C%') t
join film_category fc on fc.category_id = t.category_id
join film f on f.film_id = fc.film_id --175 / 53.54 / 0.38   

explain analyse
select f.title, t.name
from (
	select category_id, "name"
	from category 
	where "name" like 'C%') t 
left join film_category fc on fc.category_id = t.category_id
left join film f on f.film_id = fc.film_id --175 / 53.54 / 0.38   

explain analyse
select f.title, t.name
from film f
join film_category fc on fc.film_id = f.film_id
join (
	select category_id, "name"
	from category 
	where "name" like 'C%') t on t.category_id = fc.category_id --175 / 53.54 / 0.38 	
	
explain analyze
select f.title, t.name
from film f
right join film_category fc on fc.film_id = f.film_id
right join (
	select category_id, "name"
	from category 
	where "name" like 'C%') t on t.category_id = fc.category_id --175 / 53.54 / 0.38	

explain analyse
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id and  
	fc.category_id in --(3, 4, 5)
		(select category_id
		from category 
		where "name" like 'C%')
join category c on c.category_id = fc.category_id --175 / 47.36 / 0.324	

explain analyse
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id 
join category c on c.category_id = fc.category_id
where c.category_id in (--3, 4, 5) --(
	select category_id
	from category 
	where "name" like 'C%') --175 / 47.21 / 0.323	

explain analyze
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id 
join category c on c.category_id = fc.category_id
where c."name" like 'C%'  --175 / 53.54	/ 0.38

медленное сканирование 1000 + 16
быстрое сканирование 1000

медленное сканирование 16 + 16
быстрое сканирование 1000 + 1000

--ТАК НЕ НАДО
explain analyze
select f.title, c.name
from (
	select film_id, title
	from film) f
join (
	select film_id, category_id 
	from film_category) fc on fc.film_id = f.film_id 
join (
	select category_id, name
	from category) c on c.category_id = fc.category_id
where c.category_id in (
	select category_id
	from category 
	where "name" like 'C%')	--45.71

select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id 
join category c on c.category_id = fc.category_id
where c.category_id in (--3, 4, 5) --(
	select category_id
	from category 
	where "name" like 'C%')

-- ГРУБАЯ ОШИБКА, СОЗДАЕТ ИЗБЫТОЧНОСТЬ И ВЕШАЕТ БАЗУ. МОГУТ УВОЛИТЬ!
explain analyze --710187.83 / 770
select distinct customer_id, 
	(select sum(amount) 
	from payment p1
	where p1.customer_id = p.customer_id),
	(select count(amount) 
	from payment p1
	where p1.customer_id = p.customer_id),
	(select min(amount) 
	from payment p1
	where p1.customer_id = p.customer_id),
	(select max(amount) 
	from payment p1
	where p1.customer_id = p.customer_id),
	(select avg(amount) 
	from payment p1
	where p1.customer_id = p.customer_id)
from payment p
order by 1

explain analyze --518.22 / 6.5
select customer_id,  sum(amount), count(amount), min(amount), max(amount), avg(amount)
from payment p
group by customer_id
order by 1

select 710187.83 / 518.22, 770 / 6.5

explain analyze --69250.07
select *
from payment p
where customer_id in (select customer_id from rental r where r.rental_id = p.rental_id)

explain analyze --832.62
select *
from payment p
where p.rental_id in (select rental_id from rental r)

explain analyze --832.62
select p.*
from payment p
join rental r on r.rental_id = p.rental_id