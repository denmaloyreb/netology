https://www.sqlstyle.guide/ru/

https://letsdocode.ru/sql-main/simulator_erd

select * from customer c

Комментарии
--fklgnhsklfnghlsf
/* 
 * dfgdfg
 * dfgsdfg
 */

select ... /*dfkjghsdfjg*/ ...

Отличие ' ' от " "  --` `
' ' - значений

where first_name = 'Николай'

" " - названия сущностей

dvd-rental 

set search_path to "dvd-rental"

@> <@ &&

Зарезервированные слова

select name
from language

select "select"
from "from"

bar

select power(2, 5)

синтаксический порядок инструкции select;

select - указываем все, чтьол хотим вывести в результат, названия столбцов, вычисления, резльтаты функций
from - ключевая таблица из которой получаете данные
join - указываете другие таблицы, укоторе нужно присоединить
on - условие по котрому присоединяете другие таблицы
where - условие к данным
group by - группировка данных
having - условие к результату агрегации
order by - сортировка результата
offset/limit

логический порядок инструкции select;

from
on
join
where
group by
having
select --алиасы
order by
offset/limit

pg_typeof(), приведение типов

integer
smallint
bigint

'1' + '1' = '11'

select pg_typeof(100) --integer

select pg_typeof(100.) --numeric

select pg_typeof('100.') --unknown

numeric | text 
100.	| '100.'

select pg_typeof('100.'::numeric::text) --numeric

select '01.01.2024'::int - синтаксический сахар для приведения типов данных

select pg_typeof(cast('100.' as numeric)) --numeric

1. Получите атрибуты id фильма, название, описание, год релиза из таблицы фильмы.
Переименуйте поля так, чтобы все они начинались со слова Film (FilmTitle вместо title и тп)
- используйте ER - диаграмму, чтобы найти подходящую таблицу
- as - для задания синонимов 

select *
from film 

select film_id, title, description, release_year, 2 + 2, power(2, 5)
from film 

select film_id as FilmFilm_id, title as FilmTitle, description as FilmDescription, release_year as FilmRelease_Year, 2 + 2 as some_alias, power(2, 5) 
from film 

select film_id FilmFilm_id, title FilmTitle, description FilmDescription, release_year FilmRelease_Year, 2 + 2 some_alias, power(2, 5) 
from film 

select film_id "FilmFilm_id", title "FilmTitle", description "FilmDescription", release_year "Год выпуска фильма", 2 + 2 some_alias, power(2, 5) 
from film 

select *
from (
	select 2 + 2 as x, 2 * 2 as y)
where x = 4

select cust_name, staff_name
from (
	select c.first_name as cust_name, s.first_name as staff_name
	from customer c, staff s)
	
select 1 as "хотим задать ну очень лдолинный псевдоним потому что творим зло в базе данных"

< 64 байт

2. В одной из таблиц есть два атрибута:
rental_duration - длина периода аренды в днях  
rental_rate - стоимость аренды фильма на этот промежуток времени. 
Для каждого фильма из данной таблицы получите стоимость его аренды в день,
задайте вычисленному столбцу псевдоним cost_per_day
- используйте ER - диаграмму, чтобы найти подходящую таблицу
- стоимость аренды в день - отношение rental_rate к rental_duration
- as - для задания синонимов 

integer 
numeric - строго про финансы / decimal
float - / real double precision

select title, rental_rate / rental_duration
from film 

select title, rental_rate / rental_duration,
	rental_rate * rental_duration,
	rental_rate + rental_duration,
	rental_rate - rental_duration,
	power(rental_rate, rental_duration),
	mod(rental_rate, rental_duration),
	rental_rate % rental_duration,
	cos(rental_rate),
	cosd(rental_rate),
	sqrt(rental_rate)
from film 

- арифметические действия
- оператор round

select title, rental_rate / rental_duration as cost_per_day
from film 

round(numeric, integer)
round(float) - флоат можно округлить только до целого числа

select title, round(rental_rate / rental_duration, 2) as cost_per_day
from film

SQL Error [42883]: ОШИБКА: функция round(double precision, integer) не существует

select round(15 / 7, 2) - при делении целых чисел дробная часть отбрасывается

select ceil(15. / 7) - округляем в большую сторону

select floor(20. / 7) - округляем в меньшую сторону

select x,
	round(x::numeric) as x_num,
	round(x::float) as x_fl
from generate_series(0.5, 7.5, 1) x

3.1 Отсортировать список фильмов по убыванию стоимости за день аренды (п.2)
- используйте order by (по умолчанию сортирует по возрастанию)
- desc - сортировка по убыванию

select film_id, title, rental_rate / rental_duration as cost_per_day
from film 
order by rental_rate / rental_duration

select film_id, title, rental_rate / rental_duration as cost_per_day
from film 
order by cost_per_day --asc
 
select film_id, title, rental_rate / rental_duration as cost_per_day
from film 
order by 3

select film_id, title, rental_rate / rental_duration as cost_per_day
from film 
order by cost_per_day desc

select film_id, title, round(rental_rate / rental_duration, 2) as cost_per_day
from film 
order by cost_per_day desc, title 

3.1* Отсортируйте таблицу платежей по возрастанию суммы платежа (amount)
- используйте ER - диаграмму, чтобы найти подходящую таблицу
- используйте order by 
- asc - сортировка по возрастанию 

select * 
from payment 
order by amount

3.2 Вывести топ-10 самых дорогих фильмов по стоимости за день аренды
-- используйте limit

1 - 1000
2,3,4 - 990
5-20 - 980

кто попадет в топ - 3?

квартиры 1 и двух случайных из 2,3,4
конфеты 1-20

select film_id, title, round(rental_rate / rental_duration, 2) as cost_per_day
from film 
order by cost_per_day desc
limit 10

select film_id, title, round(rental_rate / rental_duration, 2) as cost_per_day
from film 
order by cost_per_day desc
fetch first 10 rows only - 

случайные 10 фильмов из 62

select film_id, title, round(rental_rate / rental_duration, 2) as cost_per_day
from film 
order by cost_per_day desc
fetch first 10 rows with ties

3.2.1 Вывести топ-1 самых дорогих фильмов по стоимости за день аренды, то есть вывести все 62 фильма
--начиная с 13 версии

select film_id, title, round(rental_rate / rental_duration, 2) as cost_per_day
from film 
order by cost_per_day desc
fetch first 1 rows with ties

3.3 Вывести топ-10 самых дорогих фильмов по стоимости аренды за день, начиная с 58-ой позиции
- воспользуйтесь Limit и offset

select film_id, title, round(rental_rate / rental_duration, 2) as cost_per_day
from film 
order by cost_per_day desc
offset 57
limit 10

select * 
from million_rows
offset 1000
limit 1000

3.3* Вывести топ-15 самых низких платежей, начиная с позиции 14000
- воспользуйтесь Limit и offset

select *
from payment
order by amount
offset 13999
limit 15

select *
from payment
order by amount desc
offset 13999
limit 15

select *
from payment
order by random()
offset 13999
limit 15

4. Вывести все уникальные годы выпуска фильмов
- воспользуйтесь distinct

select distinct release_year
from film 

/*
select release_year
from film 
group by release_year
*/

4* Вывести уникальные имена покупателей
- используйте ER - диаграмму, чтобы найти подходящую таблицу
- воспользуйтесь distinct

select first_name --599
from customer 

select distinct first_name --591
from customer 

select distinct first_name, last_name --599
from customer 

explain analyze --25.47 / 0.26
select distinct customer_id, first_name, last_name --599
from customer 

explain analyze --14.99 / 0.07
select customer_id, first_name, last_name --599
from customer 

4.1 нужно получить последний платеж каждого пользователя

select distinct on (customer_id) *
from payment 
order by customer_id, payment_date desc

5.1. Вывести весь список фильмов, имеющих рейтинг 'PG-13', в виде: "название - год выпуска"
- используйте ER - диаграмму, чтобы найти подходящую таблицу
- "||" - оператор конкатенации, отличие от concat
- where - конструкция фильтрации
- "=" - оператор сравнения

distinct on (столбец) — уникальные значения только по указанному в скобках столбцу

text 
varchar(N) varchar(50) 0 - 50
char(N) char(10) 10 'xxxxx'::char(10) -> 'xxxxx     '

select concat(title, ' - ', release_year), rating
from film 
where rating = 'PG-13'

select last_name || ' ' || first_name || ' ' ||  middle_name
from person 

select concat(last_name, ' ', first_name, ' ',  middle_name)
from person 

select concat_ws(' ', last_name, first_name, middle_name)
from person 

select pg_typeof(release_year)
from film 

select 2 + null

select 'hello' || null

select concat('hello', null)

5.2 Вывести весь список фильмов, имеющих рейтинг, начинающийся на 'PG'
- cast(название столбца as тип) - преобразование
- like - поиск по шаблону
- ilike - регистронезависимый поиск
- lower
- upper
- length

like
ilike
% - от 0 до N символов
_ - строго один любой символ

select concat(title, ' - ', release_year), rating
from film 
where rating like 'PG%'

SQL Error [42883]: ОШИБКА: оператор не существует: mpaa_rating ~~ unknown

select concat(title, ' - ', release_year), pg_typeof(rating)
from film 

select concat(title, ' - ', release_year), rating
from film 
where rating::text like 'PG%'

select concat(title, ' - ', release_year), rating
from film 
where rating::text like '%7'

select concat(title, ' - ', release_year), rating
from film 
where rating::text like '%-%'

select concat(title, ' - ', release_year), rating
from film 
where rating::text not like '%-%'

select concat(title, ' - ', release_year), rating
from film 
where not rating::text like '%-%'

select concat_ws(' ', last_name, first_name, middle_name) - конкатеняция по разделителю
from person 
where last_name ilike 'а__к%в'

select concat_ws(' ', last_name, first_name, middle_name)
from person 
where last_name ilike 'а_________в'

select concat_ws(' ', last_name, first_name, middle_name)
from person 
where last_name ilike 'а%в' and char_length(last_name) = 11

select concat_ws(' ', last_name, first_name, middle_name)
from person 
where lower(last_name) like 'а%в' and char_length(last_name) = 11

select concat_ws(' ', last_name, first_name, middle_name)
from person 
where upper(last_name) like 'А%В' and char_length(last_name) = 11

select initcap(upper(lower(concat_ws(' ', last_name, first_name, middle_name))))
from person 

select initcap('aAA.bBb CCC67DDD')
				Aaa.Bbb Ccc67ddd
				
select *
from film 
where title like '%\%%'

select *
from film 
where title like '%E%%' escape 'E'

select *
from film 
where title like '%"%'

select *
from film 
where title like '%''%'

select ''''

5.2* Получить информацию по покупателям с именем содержашим подстроку'jam' (независимо от регистра написания),
в виде: "имя фамилия" - одной строкой.
- "||" - оператор конкатенации
- where - конструкция фильтрации
- ilike - регистронезависимый поиск
- strpos
- character_length
- overlay
- substring
- split_part

select *
from customer 
where first_name ilike '%jam%'

&#8216

select substring('hello world' from 7 for 3)

select substring('hello world', 7, 3)

select substring('hello world', 7)

select left('hello world', 3)

select left('hello world', -3)

select right('hello world', 3)

select right('hello world', -3)

select strpos('hello world', 'world')

select concat_ws(' ', last_name, first_name, middle_name)
from person 

select split_part(concat_ws(' ', last_name, first_name, middle_name), ' ', 1), 
	split_part(concat_ws(' ', last_name, first_name, middle_name), ' ', 2), 
	split_part(concat_ws(' ', last_name, first_name, middle_name), ' ', 3)
from person 

Литвинова 1
Амелия 2
Егоровна 3

select concat_ws(' ', last_name, first_name, middle_name),
	replace(concat_ws(' ', last_name, first_name, middle_name), 'Николай', 'Nikolay')
from person 
where first_name = 'Николай'

select concat_ws(' ', last_name, first_name, middle_name),
	overlay(
		concat_ws(' ', last_name, first_name, middle_name)
		placing 'Nikolay'
		from strpos(concat_ws(' ', last_name, first_name, middle_name), 'Николай')
		for char_length('Николай'))
from person 
where first_name = 'Николай'

select alias, 
	overlay(
		alias
		placing 'Nikolay'
		from strpos(alias, 'Николай')
		for char_length('Николай'))
from (
	select concat_ws(' ', last_name, first_name, middle_name) alias
	from person 
	where first_name = 'Николай')

6. Получить id покупателей, арендовавших фильмы в срок с 27-05-2005 по 28-05-2005 включительно
- используйте ER - диаграмму, чтобы найти подходящую таблицу
- between - задает промежуток (аналог ... >= ... and ... <= ...)
- date_part()
- date_trunc()
- interval

timestamp 
time 
timestamptz 
timetz
date 
interval

show lc_time --Russian_Russia.1251

select '13.01.2024'::date

yyyy.mm.dd
dd.mm.yyyy

yyyy-mm-dd hh:mm:ss.ms+tz

select now()

select '2024-02-01 21:26:46.96419+09'::timestamptz 
		2024-02-01 15:26:46.96419+03
		2024-02-01 21:26:46.96419+09

set time zone 'utc-9'

set time zone 'utc-3'
		
--ложный запрос
select customer_id, rental_date
from rental 
where rental_date >= '27-05-2005' and rental_date <= '28-05-2005'
order by rental_date desc

--ложный запрос 
select customer_id, rental_date
from rental 
where rental_date between '27-05-2005' and '28-05-2005'
order by rental_date desc

--можно, но не нужно
select customer_id, rental_date
from rental 
where rental_date >= '27-05-2005' and rental_date <= '28-05-2005 24:00:00'
order by rental_date desc

select customer_id, rental_date
from rental 
where rental_date >= '27-05-2005' and rental_date < '29-05-2005'
order by rental_date desc

select customer_id, rental_date
from rental 
where rental_date >= '27-05-2005' and rental_date < '28-05-2005'::date + interval '1 day'
order by rental_date desc

--как нужно
select customer_id, rental_date
from rental 
where rental_date::date between '27-05-2005' and '28-05-2005'
order by rental_date desc

select customer_id, rental_date
from rental 
where rental_date::date between '15-05-2005' and date_trunc('month', '15-05-2005'::date) + interval '+ 1 month - 1 day'
order by rental_date desc

select date_trunc('month', '15-05-2005'::date) + interval '+ 1 month - 1 day'

select now()

extract = date_part()

date_trunc()

6* Вывести платежи поступившие после 2005-07-08
- используйте ER - диаграмму, чтобы найти подходящую таблицу
- > - строгое больше (< - строгое меньше)

select * 
from payment 
where payment_date::date > '2005-07-08'

select date_part('year', now()), 
	date_part('month', now()), 
	date_part('day', now()), 
	date_part('hour', now()), 
	date_part('minutes', now()), 
	date_part('seconds', now()), 
	date_part('quarter', now()), 
	date_part('week', now()), 
	date_part('isodow', now()), 
	date_part('epoch', now())
	
date_part('month', now()), date_part('year', now())

select date_trunc('year', now()), 
	date_trunc('month', now()), 
	date_trunc('day', now()), 
	date_trunc('hour', now()), 
	date_trunc('minutes', now()), 
	date_trunc('seconds', now()), 
	date_trunc('quarter', now()), 
	date_trunc('week', now())
	
date_trunc('month', now())
	
7. Получить количество дней с '17-04-2007' по сегодняшний день.
Получить количество месяцев с '17-04-2007' по сегодняшний день.
Получить количество лет с '17-04-2007' по сегодняшний день.

select now()

select current_timestamp

select current_time

select current_date

select current_user

select current_schema

timestamp - timestamp = interval 
date - date = integer

--дни:
select current_date - '17-04-2007'::date --6134


--Месяцы:
select date_part('year', age('17-04-2007'::date)) * 12 + date_part('month', age('17-04-2007'::date)) --201

--Года:
/*
select (current_date - '17-04-2007'::date) / 365.25 --ПЛОХО !!!!!!!!!!!!!!
*/

select age(current_timestamp, '17-04-2007'::date)  --16 years 9 mons 14 days 21:51:25.198343

select age(current_date, '17-04-2007'::date)

select date_part('year', age('17-04-2007'::date)) --16

8. Булев тип

boolean

true 1 'yes'::boolean 'on' 't'
false 0 'no' 'off' 'f'

select *
from customer 
where activebool = true

select *
from customer 
where activebool != true

select *
from customer 
where activebool = false

select *
from customer 
where activebool is null --С null писать = нельзя

select *
from customer 
where activebool is true

select *
from customer 
where activebool is false


9 Логические операторы and и or

ОПЕРАТОР and ИМЕЕТ ПРИОРИТЕТ ПЕРЕД ОПЕРАТОРОМ or 

and - умножение
or - сложение

select customer_id, amount
from payment 
where customer_id = 1 or customer_id = 2 and amount = 2.99 or amount = 4.99

a + b * c + d

select customer_id, amount
from payment 
where (customer_id = 1 or customer_id = 2) and (amount = 2.99 or amount = 4.99)

(a + b) * (c + d)

/*
select customer_id, amount
from payment 
where (customer_id = 1 or 2) and (amount = 2.99 or 4.99)
*/
SQL Error [42804]: ОШИБКА: аргумент конструкции OR должен иметь тип boolean, а не integer

select *
from customer c
where left(last_name, 1) = 'A' and left(first_name, 1) = 'A' or left(last_name, 1) = 'B' and left(first_name, 1) = 'B'


select *
from customer c
where left(last_name, 1) = 'A' and left(first_name, 1) = 'A' or left(last_name, 1) = 'B' and left(first_name, 1) = 'B'

https://t.me/sql_db_nkh/40

create temporary table xml_prod_calendar as 
 select xml
  $$ <calendar year="2024" lang="ru" date="2023.09.30">
   <holidays>
    <holiday id="1" title="Новогодние каникулы"/>
    <holiday id="2" title="Рождество Христово"/>
    <holiday id="3" title="День защитника Отечества"/>
    <holiday id="4" title="Международный женский день"/>
    <holiday id="5" title="Праздник Весны и Труда"/>
    <holiday id="6" title="День Победы"/>
    <holiday id="7" title="День России"/>
    <holiday id="8" title="День народного единства"/>
   </holidays>
   <days>
    <day d="01.01" t="1" h="1"/>
    <day d="01.02" t="1" h="1"/>
    <day d="01.03" t="1" h="1"/>
    <day d="01.04" t="1" h="1"/>
    <day d="01.05" t="1" h="1"/>
    <day d="01.06" t="1" h="1"/>
    <day d="01.07" t="1" h="2"/>
    <day d="01.08" t="1" h="1"/>
    <day d="02.22" t="2"/>
    <day d="02.23" t="1" h="3"/>
    <day d="03.07" t="2"/>
    <day d="03.08" t="1" h="4"/>
    <day d="04.27" t="3"/>
    <day d="04.29" t="1" f="04.27"/>
    <day d="04.30" t="1" f="11.02"/>
    <day d="05.01" t="1" h="5"/>
    <day d="05.08" t="2"/>
    <day d="05.09" t="1" h="6"/>
    <day d="05.10" t="1" f="01.06"/>
    <day d="06.11" t="2"/>
    <day d="06.12" t="1" h="7"/>
    <day d="11.02" t="2"/>
    <day d="11.04" t="1" h="8"/>
    <day d="12.28" t="3"/>
    <day d="12.30" t="1" f="12.28"/>
    <day d="12.31" t="1" f="01.07"/>
   </days>
  </calendar> $$ as xml_data;
 
 create table prod_calendar (
 id serial primary key,
 date date not null,
 description text,
 type text not null)

 with xml_year as (
 select hol_year
 from xml_prod_calendar, xmltable('//calendar' passing xml_data columns
  hol_year int path '@year')),
xml_holidays as (
 select holiday_id, holiday_desc
 from xml_prod_calendar, xmltable('//calendar/holidays/holiday' passing xml_data columns
  holiday_id int path '@id',
  holiday_desc text path '@title')),
xml_days as (
 select hol_date, hol_type, hol_desc, hol_from
 from xml_prod_calendar, xmltable('//calendar/days/day' passing xml_data columns
  hol_date text path '@d',
  hol_type int path '@t',
  hol_desc int path '@h',
  hol_from text path '@f'))
insert into prod_calendar (date, description, type)
select concat(xy.hol_year, '.', xd.hol_date)::date, 
 coalesce(xh.holiday_desc, 'Перенос с ' || split_part(xd.hol_from, '.', 2) || '.' || split_part(xd.hol_from, '.', 1) || '.' || xy.hol_year), 
 case
  when hol_type = 1 then 'выходной день'
  when hol_type = 2 then 'рабочий и сокращенный'
  when hol_type = 3 then 'рабочий день'
 end
from xml_days xd
cross join xml_year xy
left join xml_holidays xh on xd.hol_desc = xh.holiday_id 
order by 1;

(select x::date
from generate_series('01.01.2024'::date, '31.12.2024'::date, interval '1 day') x
where date_part('isodow', x::date) not in (6, 7))
except
(select date 
from prod_calendar
where type = 'выходной день')
union 
(select date 
from prod_calendar
where type = 'рабочий день' or type = 'рабочий и сокращенный')
order by 1

