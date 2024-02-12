======================== Создание таблиц ========================

https://dbdiagram.io/, https://sqldbm.com, https://pgmodeler.io

create database название_базы_данных

create schema lecture_4

set search_path to lecture_4

1. Создайте таблицу "автор" с полями:
- id 
- имя
- псевдоним (может не быть)
- дата рождения
- город рождения
- родной язык
* Используйте 
    CREATE TABLE table_name (
        column_name TYPE column_constraint,
    );
* для id подойдет serial, ограничение primary key
* Имя и дата рождения - not null
* город и язык - внешние ключи

create table author (
	author_id serial primary key,
	author_name varchar(100) not null,
	nick_name varchar(30),
	born_date date not null check (date_part('year', born_date) >= 1700 and born_date < current_date),
	born_city_id int2 not null references city(city_id),
	--language_id int2 not null references language(language_id),
	created_at timestamp not null default current_timestamp,
	created_user varchar(64) not null default current_user,
	deleted boolean not null default false)
	
deleted int2 not null default 0 check (deleted in (0, 1, 9))

create comment 

gender boolean
0 - М
1 - Ж

select 
from author
where boolean is true
	
p_id | c_id | fio | city_прописки | Адрес магазина
1		1	 ИИИ	Питер				ыва
2		1	 ИИИ	Питер				ыва
3		1	 ИИИ	Питер				ыва
4		1	 ИИИ	Питер				ыва
		null null	null	 			йцу


select 
from (
	select a_id, b_id, c_id, a_name, b_name, c_name
	from a 
	join b 
	join c)

serial = integer + sequence + default nextval(sequence)

varchar(8000)

varchar(100)
50

90-100
4000 * 1000000
100гб
1гб

1 страница = 8кб
1 строка 1 кб

1 строка 80 кб

15
20
20

55 + 30% = 71,5 = 75 = 100

varchar(24)

uuid 

select gen_random_uuid()

'5b0bb33e-3926-4e0d-af1c-0a3460260b86'

create extension "uuid-ossp"

select uuid_generate_v1()

a334cf34-c6a4-11ee-adda-67c88e351332
a34cfe20-c6a4-11ee-addb-330954b7bf4c
a78da146-c6a4-11ee-addc-cb0998b40469

select uuid_generate_v4()

635cdf78-db5a-4ae6-a45c-56792dbfda3f
893dc8e4-9a75-4da4-a53f-91c4087f3767

numeric(10, 0)

1
2
3
4
5
5646546464968748946416356987
5646546464968748946416356987
5646546464968748946416356987

id uuid default uuid_generate_v4()

1*  Создайте таблицы "Язык", "Город", "Страна".
* для id подойдет serial, ограничение primary key
* названия - not null и проверка на уникальность

create table city (
	city_id serial2 primary key,
	city_name varchar(40) not null,
	country_id int2 not null references country(country_id))	
	
create table language (
	language_id serial2 primary key,
	language_name varchar(40) not null unique)

create table country (
	country_id serial2 primary key,
	country_name varchar(40) not null unique)

int2 
int4 
int8 

== Отношения / связи ==
А		Б
один к одному  		Б является атрибутом А
один ко многим		А и Б два отдельных справочника
многие ко многим	в реляционной модели не существует, реализуется через два отношения один 
					ко многим А-В и В-Б
			
--ТАК ДЕЛАТЬ НЕЛЬЗЯ, ПЛОХО, ПИШЕМ ТОЛЬКО ДЛЯ ПРАКТИКИ И ПОНИМАНИЯ
create table author_language (
	language_id int unique,
	author_id int unique)
	
1 1
2 3
3 2

--ТАК ДЕЛАТЬ НЕЛЬЗЯ, ПЛОХО, ПИШЕМ ТОЛЬКО ДЛЯ ПРАКТИКИ И ПОНИМАНИЯ
create table author_language (
	language_id int,
	author_id int unique)
	
1 1
1 2
2 3
2 4

--ТАК ДЕЛАТЬ НЕЛЬЗЯ, ПЛОХО, ПИШЕМ ТОЛЬКО ДЛЯ ПРАКТИКИ И ПОНИМАНИЯ
create table author_language (
	language_id int unique,
	author_id int)




--ТАК ДЕЛАТЬ НУЖНО
create table author_language (
	language_id int not null references language(language_id),
	author_id int not null references author(author_id),
	primary key (language_id, author_id))
	
1 1
2 1
1 2
2 2

l_id 	a_id
1 		1
2 		1
3 2
4 2

language_id = 1 = русский
language_id = 2 = французский
author_id = 1 = Лермонтов

select fa.*, f.title, a.last_name
from film_actor fa
join film f on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id


======================== Заполнение таблицы ========================

2. Вставьте данные в таблицу с языками:
'Русский', 'Французский', 'Японский'
* Можно вставлять несколько строк одновременно:
    INSERT INTO table (column1, column2, …)
    VALUES
     (value1, value2, …),
     (value1, value2, …) ,...;

insert into language (language_name)
values ('Русский'), ('Французский'), ('Японский')

select *
from "language" l

insert into language
values ('Китайский')

SQL Error [22P02]: ОШИБКА: неверный синтаксис для типа smallint: "Китайский"

insert into language
values (4, 'Китайский')

insert into language (language_name)
values ('Монгольский')

SQL Error [23505]: ОШИБКА: повторяющееся значение ключа нарушает ограничение уникальности "language_pkey"
  Подробности: Ключ "(language_id)=(4)" уже существует.
  
-- демонстрация работы счетчика и сброс счетчика
alter sequence language_language_id_seq restart with 1000

insert into language (language_name)
values ('fgnxfghn')

drop table "language"

create table language (
	language_id int2 primary key generated always as identity,
	language_name varchar(40) not null unique)
	
insert into language (language_name)
values ('Русский'), ('Французский'), ('Японский')

select *
from "language" l

insert into language
values (4, 'Китайский')

SQL Error [428C9]: ОШИБКА: в столбец "language_id" можно вставить только значение по умолчанию
  Подробности: Столбец "language_id" является столбцом идентификации со свойством GENERATED ALWAYS.
  Подсказка: Для переопределения укажите OVERRIDING SYSTEM VALUE.
  
insert into language
OVERRIDING SYSTEM VALUE
values (4, 'Китайский')

insert into language (language_name)
values ('Монгольский')

select 65535^2 --4294836225
	
--Работает начиная с 13 версии PostgreSQL - stored
create table some_pay (
	id int2 primary key generated always as identity,
	qty numeric,
	amount_per_one numeric,
	discount int,
	total_amount numeric generated always as (round(qty * amount_per_one * ((100 - discount) / 100.), 2)) stored)
	
drop table 	some_pay
	
insert into some_pay (qty, amount_per_one, discount)
values (5, 500, 5), (1, 1000, 3)

insert into some_pay (qty, amount_per_one, discount)
values (1, 728, 2)

select * from some_pay

2.1 Вставьте данные в таблицу со странами из таблиц country базы dvd-rental:

select * from country 

select country_id, country from public.country 

insert into country
select country_id, country from public.country 

insert into country (country_name)
values ('Россия')

alter sequence country_country_id_seq restart with 110

2.2 Вставьте данные в таблицу с городами соблюдая связи из таблиц city базы dvd-rental:

select * from city

insert into city(city_name, country_id)
select city, country_id
from public.city 

2.3 Вставьте данные в таблицу с авторами, идентификаторы языков и городов оставьте пустыми.
Жюль Верн, 08.02.1828
Михаил Лермонтов, 03.10.1814
Харуки Мураками, 12.01.1949

select * from author a

insert into author (author_name, nick_name, born_date, born_city_id)
values ('Жюль Верн', null, '08.02.1828', 63),
	('Михаил Лермонтов', 'Гр. Диарьекир', '03.10.1814', 12),
	('Харуки Мураками', null, '12.01.1949', 345)
	
SQL Error [23514]: ОШИБКА: новая строка в отношении "author" нарушает ограничение-проверку "author_born_date_check"
Подробности: Ошибочная строка содержит (2, Михаил Лермонтов, Гр. Диарьекир, 1614-10-03, 12, 2024-02-08 20:59:28.838455, postgres, f).

======================== Модификация таблицы ========================

3. Добавьте поле "идентификатор языка" в таблицу с авторами
* ALTER TABLE table_name 
  ADD COLUMN new_column_name TYPE;

-- добавление нового столбца
alter table author add column language_id int

alter table author add column author_name varchar(100)

-- удаление столбца
alter table author drop column author_name

-- добавление ограничения not null
alter table author alter column language_id set not null
 
-- удаление ограничения not null
alter table author alter column language_id drop not null

-- добавление ограничения unique
alter table author add constraint language_id_unique unique (language_id)

-- удаление ограничения unique
alter table author drop constraint language_id_unique

-- изменение типа данных столбца
alter table author alter column language_id type varchar(100)

alter table author alter column language_id type int using(language_id::int)

create table a (
	val varchar(30))
	
do $$
	begin
		for i in 1..1000000			
		loop
			insert into a (val)
			values ('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
		end loop;	
	end;
$$ language plpgsql
 
select * --1 000 000
from a

alter table a alter column val type varchar(150)

select *
from pg_catalog.pg_attribute pa
join pg_catalog.pg_class pc on pa.attrelid = pc."oid"
where attname = 'val' and relname = 'a'

update pg_attribute
set atttypmod = 104
where attrelid = 91981

-- добавление ограничения внешнего ключа
alter table author add constraint language_author_fkey foreign key (language_id) references language(language_id)

alter table author drop constraint language_author_pkey 

 ======================== Модификация данных ========================

4. Обновите данные, проставив корректное языки писателям:
Жюль Габриэль Верн - Французский
Михаил Юрьевич Лермонтов - Российский
Харуки Мураками - Японский

select * from author a

select * from "language" l 

1	Русский
2	Французский
3	Японский

insert - внесение новой строки
update - внесение в существующую строку

update author
set language_id = 1
where author_id = 4

update author
set language_id = 2

update author
set language_id = 1, author_name = 'Лермонтов', born_city_id = 555
where author_id = 4

update author
set language_id = 3
where author_id in (3, 5)

 ======================== Удаление данных ========================
 
5. Удалите Лермонтова

delete from author
where author_id = 4

truncate city, country cascade

5.1 Удалите все страны

drop table country

drop schema 

drop database 

lowformat c:\

========================================================================================================================

--РОДИТЕЛЬ
create table country (
	country_id serial2 primary key,
	country_name varchar(40) not null unique)
	
insert into country
select country_id, country from public.country 

--ДОЧЬ
create table city (
	city_id serial2 primary key,
	city_name varchar(40) not null,
	country_id int2 default foo() references country(country_id) on delete set null on update set default)	

insert into city(city_name, country_id)
select city, country_id
from public.city 

restrict 
no action 
cascade
set null 
set default

drop table city cascade

drop table country cascade

select * from lecture_4.country c

select * from lecture_4.city c

drop table country cascade

truncate country cascade

drop cascade - удалим ограничения, данные сохраним

truncate cascade - удалим данные, ограничения сохраним

delete cascade - удалим данные, ограничения сохраним

delete from country
where country_id = 1

update country
set country_id = 5000
where country_id = 2

create function foo() returns int as $$
	begin
		return (select max(country_id)::int from lecture_4.country);
	end;
$$ language plpgsql

select foo()

---------------------------------------------------------------------------------------
create temporary table

create table (like)

create table (like) partition by