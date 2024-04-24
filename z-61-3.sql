Задание 1. С помощью оконной функции выведите для каждого сотрудника сумму продаж за август 2005 года с нарастающим итогом 
по каждому сотруднику и по каждой дате продажи (без учёта времени) с сортировкой по дате.
Ожидаемый результат запроса: letsdocode.ru...in/5-5.png

select staff_id, payment_date::date, sum(amount),
	sum(sum(amount)) over (partition by staff_id order by payment_date::date)
from payment 
where date_trunc('month', payment_date) = '01.08.2005'
group by staff_id, payment_date::date

Задание 2. 20 августа 2005 года в магазинах проходила акция: покупатель каждого сотого платежа получал дополнительную 
скидку на следующую аренду. С помощью оконной функции выведите всех покупателей, которые в день проведения акции получили скидку.
Ожидаемый результат запроса: letsdocode.ru...in/5-6.png

select customer_id, row_number
from (
	select *, row_number() over (order by payment_date)
	from payment 
	where payment_date::date = '20.08.2005') 
--where row_number % 100 = 0
where mod(row_number, 100) = 0

Задание 3. Для каждой страны определите и выведите одним SQL-запросом покупателей, которые попадают под условия:
· покупатель, арендовавший наибольшее количество фильмов;
· покупатель, арендовавший фильмов на самую большую сумму;
· покупатель, который последним арендовал фильм.
Ожидаемый результат запроса: letsdocode.ru...in/5-7.png

explain analyze --6686.03 / 33
select distinct c.country, --concat(c3.last_name, ' ', c3.first_name), count(i.film_id), sum(p.amount), max(r.rental_date),
	first_value(concat(c3.last_name, ' ', c3.first_name)) over (partition by c.country_id order by count(i.film_id) desc),
	first_value(concat(c3.last_name, ' ', c3.first_name)) over (partition by c.country_id order by sum(p.amount) desc),
	first_value(concat(c3.last_name, ' ', c3.first_name)) over (partition by c.country_id order by max(r.rental_date) desc)
from country c
left join city c2 on c.country_id = c2.country_id
left join address a on a.city_id = c2.city_id
left join customer c3 on c3.address_id = a.address_id
left join rental r on r.customer_id = c3.customer_id
left join payment p on r.rental_id = p.rental_id
left join inventory i on r.inventory_id = i.inventory_id
group by c.country_id, c3.customer_id
order by 1

explain analyze --1262.85 / 13
with cte1 as (
	select p.customer_id, count, sum, max
	from (
		select customer_id, sum(amount)
		from payment
		group by customer_id) p
	join (
		select customer_id, count(*), max(r.rental_date)
		from rental r
		join inventory i on r.inventory_id = i.inventory_id
		group by customer_id) r on r.customer_id = p.customer_id),
cte2 as (
	select c2.country_id, concat(c.last_name, ' ', c.first_name), count, sum, max,
		case when count = max(count) over (partition by c2.country_id) then concat(c.last_name, ' ', c.first_name) end cc,
		case when sum = max(sum) over (partition by c2.country_id) then concat(c.last_name, ' ', c.first_name) end cs,
		case when max = max(max) over (partition by c2.country_id) then concat(c.last_name, ' ', c.first_name) end cm
	from customer c
	join address a on c.address_id = a.address_id
	join city c2 on c2.city_id = a.city_id
	join cte1 on c.customer_id = cte1.customer_id)
select c.country, string_agg(cc, ', '), string_agg(cs, ', '), string_agg(cm, ', ')
from country c
left join cte2 on c.country_id = cte2.country_id
group by c.country_id
order by 1

Задание 1. Откройте по ссылке SQL-запрос.

explain analyze
select distinct cu.first_name  || ' ' || cu.last_name as name, 
	count(ren.iid) over (partition by cu.customer_id)
from customer cu
full outer join 
	(select *, r.inventory_id as iid, inv.sf_string as sfs, r.customer_id as cid
	from rental r 
	full outer join 
		(select *, unnest(f.special_features) as sf_string
		from inventory i
		full outer join film f on f.film_id = i.film_id) as inv 
		on r.inventory_id = inv.inventory_id) as ren 
	on ren.cid = cu.customer_id 
where ren.sfs like '%Behind the Scenes%'
order by count desc

explain analyze
select cu.first_name  || ' ' || cu.last_name as name, 
	count(ren.iid) 
from customer cu
full outer join 
	(select *, r.inventory_id as iid, inv.sf_string as sfs, r.customer_id as cid
	from rental r 
	full outer join 
		(select *, unnest(f.special_features) as sf_string
		from inventory i
		full outer join film f on f.film_id = i.film_id) as inv 
		on r.inventory_id = inv.inventory_id) as ren 
	on ren.cid = cu.customer_id 
where ren.sfs like '%Behind the Scenes%'
group by cu.customer_id
order by count desc

Сделайте explain analyze этого запроса.
Основываясь на описании запроса, найдите узкие места и опишите их.
Сравните с вашим запросом из основной части (если ваш запрос изначально укладывается в 15мс — отлично!).
Сделайте построчное описание explain analyze на русском языке оптимизированного запроса. Описание строк в explain можно посмотреть по ссылке.

explain analyze --623.59 / 7.5
select concat(c.last_name, ' ', c.first_name), count(r.rental_id)
from rental r 
right join inventory i on r.inventory_id = i.inventory_id and 
	i.film_id in (
		select film_id
		from film
		where special_features @> array['Behind the Scenes'])
join customer c on c.customer_id = r.customer_id
group by c.customer_id

Задание 2. Используя оконную функцию, выведите для каждого сотрудника сведения о первой его продаже.
Ожидаемый результат запроса: letsdocode.ru...in/6-5.png

select *
from (
	select *, row_number() over (partition by staff_id order by payment_date)
	from payment) p
join ... 
join ...
where row_number = 1

Задание 3. Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
день, в который арендовали больше всего фильмов (в формате год-месяц-день);
количество фильмов, взятых в аренду в этот день;
день, в который продали фильмов на наименьшую сумму (в формате год-месяц-день);
сумму продажи в этот день.
Ожидаемый результат запроса: letsdocode.ru...in/6-6.png

explain analyze --5611.62 / 23
select *
from (
	select i.store_id, r.rental_date::date, count(r.rental_id), 
		row_number() over (partition by i.store_id order by count(r.rental_id) desc)
	from rental r
	join inventory i on r.inventory_id = i.inventory_id
	group by 1, 2) r
join (
	select i.store_id, p.payment_date::date, sum(p.amount), 
		row_number() over (partition by i.store_id order by sum(p.amount))
	from payment p
	full join rental r on r.rental_id = p.rental_id
	full join inventory i on i.inventory_id = r.inventory_id
	group by 1, 2) p on r.store_id = p.store_id
where r.row_number = 1 and p.row_number = 1

select *
from (
	select i.store_id, r.rental_date::date, count(r.rental_id), 
		row_number() over (partition by i.store_id order by count(r.rental_id) desc)
	from rental r
	join inventory i on r.inventory_id = i.inventory_id
	group by 1, 2) r
join (
	select s.store_id, p.payment_date::date, sum(p.amount), 
		row_number() over (partition by s.store_id order by sum(p.amount))
	from payment p
	join staff s on s.staff_id = p.staff_id
	group by 1, 2) p on r.store_id = p.store_id
where r.row_number = 1 and p.row_number = 1

аренда			платеж
диск			диск
сотрудник		сотрудник
пользователь	пользователь
диск			сотрудник
диск			пользователь
сотрудник		диск
сотрудник		пользователь
пользователь	диск
пользователь	сотрудник

select *
from (
	select i.store_id, r.rental_date::date, count(r.rental_id), 
		max(count(r.rental_id)) over (partition by i.store_id)
	from rental r
	join inventory i on r.inventory_id = i.inventory_id
	group by 1, 2) r
join (
	select s.store_id, p.payment_date::date, sum(p.amount), 
		min(sum(p.amount)) over (partition by s.store_id)
	from payment p
	join staff s on s.staff_id = p.staff_id
	group by 1, 2) p on r.store_id = p.store_id
where max = count and min = sum

explain analyze --2171.89 / 25
with cte as (
	select i.store_id, r.rental_id, r.rental_date::date, p.amount, p.payment_date::date
	from rental r
	full join payment p on r.rental_id = p.rental_id
	join inventory i on i.inventory_id = r.inventory_id),
cte1 as (
	select store_id, rental_date, count(*)
	from cte
	group by 1, 2),
cte2 as (
	select store_id, payment_date, sum(amount)
	from cte
	group by 1, 2)
select *
from (
	select store_id, rental_date, count
	from cte1
	where (store_id, count) in (select store_id, max(count) from cte1 group by 1)) r 
join (
	select store_id, payment_date, sum
	from cte2
	where (store_id, sum) in (select store_id, min(sum) from cte2 group by 1)) p on r.store_id = p.store_id
	
explain analyze 
select i.store_id, r.rental_date::date, p.payment_date::date,
	count(r.rental_id) over (partition by i.store_id, r.rental_date::date),
	sum(p.amount) over (partition by i.store_id, p.payment_date::date)
from rental r
full join payment p on r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id