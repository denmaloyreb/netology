from 
on 
join
where 
group by 
having 
over
select
order by 

функция(аргумент) over (partition by арг1, арг2... order by арг1, арг2...)

over () - со всеми данными глобально и данные передаются все целиком в хаотичном порядке
over (partition by) - делите данные на группы и данные передаются всей группой целиком в хаотичном порядке
over (order by) - со всеми данными глобально и данные передаются в определенной последовательности поэтапно
over (partition by order by)- делите данные на группы и данные передаются в определенной последовательности поэтапно

cust_id | amount 
1			5
1			10
1			5
2			2
2			8
2			10

cust_id | sum(amount)
1			20
2			20
group by cust_id

cust_id | amount | sum(amount) over (partition by cust_id)
1			5		20
1			10		20
1			5		20
2			2		20
2			8		20
2			10		20


1			5
1			10
1			5
2			2
2			8
2			10


============= оконные функции =============

1. Вывести ФИО пользователя и название пятого фильма, который он брал в аренду.
* В подзапросе получите порядковые номера для каждого пользователя по дате аренды
* Задайте окно с использованием предложений over, partition by и order by
* Соедините с customer
* Соедините с inventory
* Соедините с film
* В условии укажите 3 фильм по порядку

explain analyze --1799.19 / 11
select concat(c.last_name, ' ', c.first_name), f.title
from (
	select customer_id, array_agg(inventory_id order by rental_date)
	from rental 
	group by customer_id) r 
join inventory i on i.inventory_id = r.array_agg[5]
join film f on f.film_id = i.film_id
join customer c on c.customer_id = r.customer_id

explain analyze --2148.35 / 11
select concat(c.last_name, ' ', c.first_name), f.title
from (
	select *, row_number() over (partition by customer_id order by rental_date)
	from rental) r 
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
join customer c on c.customer_id = r.customer_id
where row_number = 5

select concat(c.last_name, ' ', c.first_name), f.title
from (
	select *, nth_value(rental_id, 5) over (partition by customer_id order by rental_date)
	from rental) r 
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
join customer c on c.customer_id = r.customer_id
where nth_value = rental_id

1.1. Выведите таблицу, содержащую имена покупателей, арендованные ими фильмы и средний платеж 
каждого покупателя
* используйте таблицу customer
* соедините с paymen
* соедините с rental
* соедините с inventory
* соедините с film
* avg - функция, вычисляющая среднее значение
* Задайте окно с использованием предложений over и partition by

select concat(c.last_name, ' ', c.first_name), f.title, p.amount, 
	avg(p.amount) over (partition by c.customer_id),
	sum(p.amount) over (partition by c.customer_id),
	count(p.amount) over (partition by c.customer_id),
	avg(p.amount) over (),
	sum(p.amount) over (),
	count(p.amount) over (),
	avg(p.amount) over (partition by c.customer_id, p.staff_id, date_trunc('month', p.payment_date)),
	sum(p.amount) over (partition by c.customer_id, p.staff_id, date_trunc('month', p.payment_date)),
	count(p.amount) over (partition by c.customer_id, p.staff_id, date_trunc('month', p.payment_date))
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
join customer c on c.customer_id = r.customer_id

explain analyze --689.84 / 7.5
select customer_id, sum(amount) * 100. / (select sum(amount) from payment)
from payment 
group by customer_id

explain analyze --377.71 / 7.5 / 4.8
select customer_id, sum(amount) * 100. / sum(sum(amount)) over ()
from payment 
group by customer_id

select customer_id, count(sum(amount)) 
from payment 
group by customer_id

-- формирование накопительного итога
НАКОПИТЕЛЬНЫЙ ИТОГ ФОРМИРУЕТСЯ ТОЛЬКО ЧЕРЕЗ ORDER by

2		2
4		2 + 4
10  	2 + 4 + 10
6		2 + 4 + 10 + 6
8   	2 + 4 + 10 + 6 + 8

select customer_id, payment_date, amount,
	sum(amount) over (partition by customer_id order by payment_date)
from payment 

1	2005-05-25 11:30:37	2.99	sum(2.99) 				2.99
1	2005-05-28 10:35:23	0.99	sum(2.99 + 0.99) 		3.98
1	2005-06-15 00:54:12	5.99	sum(2.99 + 0.99 + 5.99)	9.97
1	2005-06-15 18:02:53	0.99

2	2005-05-27 00:09:24	4.99	sum(4.99)
2	2005-06-17 20:54:58	2.99	sum(4.99 + 2.99)
2	2005-07-10 06:31:24	2.99
2	2005-07-10 12:38:56	6.99

3	2005-05-27 17:17:09	1.99
3	2005-05-29 22:43:55	2.99
3	2005-06-16 01:34:05	8.99
3	2005-06-16 15:19:10	6.99

select customer_id, payment_date::date, amount,
	sum(amount) over (partition by customer_id order by payment_date::date)
from payment 

2.99
2.99 + 0.99
2.99 + 0.99 + 5.99 + 0.99 + 9.99
2.99 + 0.99 + 5.99 + 0.99 + 9.99
2.99 + 0.99 + 5.99 + 0.99 + 9.99
2.99 + 0.99 + 5.99 + 0.99 + 9.99 + 4.99

select customer_id, payment_date::date, amount,
	sum(amount) over (partition by customer_id order by payment_date::date), 
	avg(amount) over (partition by customer_id order by payment_date::date), 
	count(amount) over (partition by customer_id order by payment_date::date)
from payment 

-- работа функций lag и lead

id | дата_убытия 		| 	дата_прибытия
1	01.01.24 18:00:00		02.01.24 12:00:00
1	03.01.24 16:00:00		04.01.24 09:00:00

дата_убытия - lag(дата_прибытия) = 28 часов

select customer_id, payment_date,
	lag(amount) over (partition by customer_id order by payment_date),
	amount,
	lead(amount) over (partition by customer_id order by payment_date)
from payment 

--ложный запрос
select date_trunc('month', payment_date), sum(amount),
	lag(sum(amount)) over (order by date_trunc('month', payment_date)),
	sum(amount) - lag(sum(amount)) over (order by date_trunc('month', payment_date))
from payment p
group by 1

--ложный запрос
select date_trunc('month', created_at), sum(amount),
	lag(sum(amount), 12) over (order by date_trunc('month', created_at))
from projects 
group by 1

select customer_id, payment_date,
	lag(amount, 3) over (partition by customer_id order by payment_date),
	amount,
	lead(amount, 5) over (partition by customer_id order by payment_date)
from payment 

--ТАК ПЛОХО
select customer_id, payment_date,
	lag(amount, -3) over (partition by customer_id order by payment_date),
	amount,
	lead(amount, -5) over (partition by customer_id order by payment_date)
from payment 

--ТАК ПЛОХО
select customer_id, payment_date,
	lag(amount, 0) over (partition by customer_id order by payment_date),
	amount,
	lead(amount, 0) over (partition by customer_id order by payment_date)
from payment 

select customer_id, payment_date,
	lag(amount, 3, 0.) over (partition by customer_id order by payment_date),
	amount,
	lead(amount, 5, 0.) over (partition by customer_id order by payment_date)
from payment 

-- работа с рангами и порядковыми номерами
row_number - сквозная нумерация
dense_rank - одинаковый ранг по общему знаменателю, увеличение предыдущий ранг + 1
rank - одинаковый ранг по общему знаменателю, увеличение предыдущий ранг + кол-во значений в предыдущем ранге

1	1:00
2,3	1:01
4	1:02

1 - 1
2 - 2,3
4 - 4

1 - 1
2 - 2,3
3 - 4

select customer_id, payment_date::date,
	row_number() over (order by payment_date::date),
	dense_rank() over (order by payment_date::date),
	rank() over (order by payment_date::date)
from payment p

select 15868 - 15269

-- first_value / last_value / nth_value

explain analyze --1511.31 / 7
select distinct on (customer_id) *
from rental r
order by customer_id, rental_date

explain analyze --800.31  / 6
select *
from rental r
where (customer_id, rental_date) in (
	select customer_id, min(rental_date)
	from rental r
	group by customer_id)
	
explain analyze --1952.52 / 9
select *
from (
	select *, row_number() over (partition by customer_id order by rental_date)
	from rental)
where row_number = 1

explain analyze --2393.73 / 27
select distinct customer_id, 
	first_value(rental_id) over (partition by customer_id order by rental_date),
	first_value(rental_date) over (partition by customer_id order by rental_date),
	first_value(inventory_id) over (partition by customer_id order by rental_date),
	first_value(return_date) over (partition by customer_id order by rental_date),
	first_value(staff_id) over (partition by customer_id order by rental_date),
	first_value(last_update) over (partition by customer_id order by rental_date)
from rental

explain analyze --1952.52 / 15
select *
from (
	select *,
		first_value(rental_id) over (partition by customer_id order by rental_date)
	from rental)
where rental_id = first_value

--ложный запрос
select *
from (
	select *,
		last_value(rental_id) over (partition by customer_id order by rental_date desc)
	from rental)
where rental_id = last_value

15315
15298
14825

--верный запрос
explain analyze --1912.41 / 15
select *
from (
	select *, last_value(rental_id) over (partition by customer_id)
	from (
		select *
		from rental
		order by customer_id, rental_date desc))
where rental_id = last_value

select *
from (
	select *,
		last_value(rental_id) over (partition by customer_id order by rental_date desc
			rows between unbounded preceding and unbounded following)
	from rental)
where rental_id = last_value

rows
range 
groups

select customer_id, payment_date::date, amount,
	sum(amount) over (order by payment_date::date rows between 2 preceding and current row),
	avg(amount) over (order by payment_date::date rows between 2 preceding and 2 following)
from payment p

select customer_id, payment_date::date, amount,
	sum(amount) over (order by payment_date::date rows between 2 preceding and current row),
	sum(amount) over (order by payment_date::date range between '2 days 12 hours' preceding and '1 days' following),
	sum(amount) over (order by payment_date::date groups between 1 preceding and 1 following)
from payment p

--алиасы
select concat(c.last_name, ' ', c.first_name), f.title, p.amount, 
	avg(p.amount) over w_1,
	sum(p.amount) over w_1,
	count(p.amount) over w_1,
	avg(p.amount) over w_2,
	sum(p.amount) over w_2,
	count(p.amount) over w_2,
	avg(p.amount) over w_3,
	sum(p.amount) over w_3,
	count(p.amount) over w_3
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
join customer c on c.customer_id = r.customer_id
window w_1 as (partition by c.customer_id),
	w_2 as (),
	w_3 as (partition by c.customer_id, p.staff_id, date_trunc('month', p.payment_date))
order by 1

--фильтрация
select concat(c.last_name, ' ', c.first_name), f.title, p.amount, 
	avg(p.amount) filter (where p.amount < 5) over w_1,
	sum(p.amount) filter (where p.amount >= 5) over w_1,
	count(p.amount) over w_1,
	avg(p.amount) over w_2,
	sum(p.amount) over w_2,
	count(p.amount) over w_2,
	avg(p.amount) over w_3,
	sum(p.amount) over w_3,
	count(p.amount) over w_3
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
join customer c on c.customer_id = r.customer_id
window w_1 as (partition by c.customer_id),
	w_2 as (),
	w_3 as (partition by c.customer_id, p.staff_id, date_trunc('month', p.payment_date))
order by 1

============= общие табличные выражения =============

2.  При помощи CTE выведите таблицу со следующим содержанием:
Название фильма продолжительностью более 3 часов и к какой категории относится фильм
* Создайте CTE:
 - Используйте таблицу film
 - отфильтруйте данные по длительности
 * напишите запрос к полученной CTE:
 - соедините с film_category
 - соедините с category

select (подзапрос)
from (подзапрос)
join (подзапрос1)
join (подзапрос1)

with cte as (
	логику),
cte2 as (логика),
cte3 as (cte, cte2)
select 
from cte2
join cte3
join cte3

select version() --PostgreSQL 16.0, compiled by Visual C++ build 1935, 64-bit

select version() --PostgreSQL 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0, 64-bit

explain analyze --53.75 / 0.5 / 90.39 / 0.45

with cte1 as (
	select film_id, title
	from film 
	where length > 180),
cte2 as (
	select category_id, name
	from category 
	where left(name, 1) = 'C'),
cte3 as (
	select *
	from cte1
	join film_category fc on fc.film_id = cte1.film_id
	join cte2 on fc.category_id = cte2.category_id)
select *
from cte3 t1
join cte3 t2 on t1.film_id = t2.film_id

explain analyze --689.84 / 7.5
select customer_id, sum(amount) * 100. / (select sum(amount) from payment)
from payment 
group by customer_id

explain analyze --1045.33 / 9.5
with cte as (
	select *
	from payment p)
select customer_id, sum(amount) * 100. / (select sum(amount) from cte)
from cte
group by customer_id

2.1. Выведите фильмы, с категорией начинающейся с буквы "C"
* Создайте CTE:
 - Используйте таблицу category
 - Отфильтруйте строки с помощью оператора like 
* Соедините полученное табличное выражение с таблицей film_category
* Соедините с таблицей film
* Выведите информацию о фильмах:
title, category."name"

============= общие табличные выражения (рекурсивные) =============
 
 3.Вычислите факториал
 + Создайте CTE
 * стартовая часть рекурсии (т.н. "anchor") должна позволять вычислять начальное значение
 *  рекурсивная часть опираться на данные с предыдущей итерации и иметь условие остановки
 + Напишите запрос к CTE

with recursive r as (
	with cte as (..)
	select *
	from cte
)

with recursive r as (
	--стартовая часть
	select 1 as x, 1 as factorial
	union 
	--рекурсивная часть
	select x + 1 as x, factorial * (x + 1) as factorial
	from r
	where x < 12)
select *
from r

select *
from "structure" s

Департамент - Отдел - Группа

Департамент - Отдел - Отдел - Отдел - Группа - Группа

with recursive r as (
	--стартовая часть
	select *, 0 as level
	from "structure" s
	where unit_id = 59
	union 
	--рекурсивная часть
	select s.*, level + 1 as level
	from r 
	join "structure" s on r.unit_id = s.parent_id
	)
select count(*)
from r
join position p on p.unit_id = r.unit_id
join employee e on p.pos_id = e.pos_id

59	15	Отдел	Центр архектуры и разработки BSS	0

with recursive r as (
	--стартовая часть
	select *, 0 as level
	from "structure" s
	where unit_id = 59
	union 
	--рекурсивная часть
	select s.*, level + 1 as level
	from r 
	join "structure" s on r.parent_id = s.unit_id
	)
select *
from r

3.2 Работа с рядами.

explain analyze --3.26 / 0.03
with recursive r as (
	--стартовая часть
	select 1 as x
	union 
	--рекурсивная часть
	select x + 3
	from r 
	where x < 100)
select *
from r

explain analyze --0.34 / 0.007
select x
from generate_series(1, 100, 3) x

explain analyze --3.26 / 0.25
with recursive r as (
	--стартовая часть
	select '01.01.2024'::date as x
	union 
	--рекурсивная часть
	select x + 1
	from r 
	where x < '31.12.2024')
select *
from r

explain analyze --12.51 / 0.1
select x::date
from generate_series('01.01.2024'::date, '31.12.2024'::date, interval '1 day') x

--ложный запрос
select date_trunc('month', payment_date), sum(amount),
	lag(sum(amount)) over (order by date_trunc('month', payment_date)),
	sum(amount) - lag(sum(amount)) over (order by date_trunc('month', payment_date))
from payment p
group by 1

--верный запрос
explain analyze --5177.40 / 12
with recursive r as (
	--стартовая часть
	select min(date_trunc('month', payment_date)) x
	from payment
	union 
	--рекурсивная часть
	select x + interval '1 month'
	from r 
	where x < (select max(date_trunc('month', payment_date)) from payment))
select x::date, coalesce(sum, 0),
	lag(coalesce(sum, 0), 1, 0) over (order by x),
	coalesce(sum, 0) - lag(coalesce(sum, 0), 1, 0) over (order by x)
from r
left join (
	select date_trunc('month', payment_date), sum(amount)
	from payment 
	group by 1) p on p.date_trunc = x
order by 1

select coalesce(null, null, null, 123, null, null, 673)

explain analyze --16366.55 / 12
select x::date, coalesce(sum, 0),
	lag(coalesce(sum, 0), 1, 0) over (order by x),
	coalesce(sum, 0) - lag(coalesce(sum, 0), 1, 0) over (order by x)
from generate_series(
	(select min(date_trunc('month', payment_date)) from payment), 
	(select max(date_trunc('month', payment_date)) from payment),
	interval '1 month') x
left join (
	select date_trunc('month', payment_date), sum(amount)
	from payment 
	group by 1) p on p.date_trunc = x
order by 1

with recursive r as (
	--стартовая часть
	select 1 as x
	union 
	--рекурсивная часть
	select 2 * x as x
	from r 
	where x < 100)
select *
from r