--=============== МОДУЛЬ 4. УГЛУБЛЕНИЕ В SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаёте новую схему с префиксом в --виде фамилии, название должно быть на латинице в нижнем регистре и таблицы создаете --в этой новой схеме, если подключение к локальному серверу, то создаёте новую схему и --в ней создаёте таблицы.

--Спроектируйте базу данных, содержащую три справочника:
--· язык (английский, французский и т. п.);
--· народность (славяне, англосаксы и т. п.);
--· страны (Россия, Германия и т. п.).
--Две таблицы со связями: язык-народность и народность-страна, отношения многие ко многим. Пример таблицы со связями — film_actor.
--Требования к таблицам-справочникам:
--· наличие ограничений первичных ключей.
--· идентификатору сущности должен присваиваться автоинкрементом;
--· наименования сущностей не должны содержать null-значения, не должны допускаться --дубликаты в названиях сущностей.
--Требования к таблицам со связями:
--· наличие ограничений первичных и внешних ключей.

--В качестве ответа на задание пришлите запросы создания таблиц и запросы по --добавлению в каждую таблицу по 5 строк с данными.
 
--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ

create table language (
	language_id serial primary key,
	language_name varchar(50) not null unique,
	created_at timestamp not null default current_timestamp,
	created_user varchar(64) not null default current_user,
	is_used int2 not null default 1 check (is_used in (0, 1))
	)
	
--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ

INSERT INTO language (language_name)
    VALUES
     ('Russian language'),
     ('German language'),
     ('Polish language'),
     ('Apachi dialect')

--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ

create table nationality (
	nationality_id serial primary key,
	nationality_name varchar(50) not null unique,
	created_at timestamp not null default current_timestamp,
	created_user varchar(64) not null default current_user,
	is_used int2 not null default 1 check (is_used in (0, 1))
	)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ

INSERT INTO nationality (nationality_name)
    VALUES
     ('Udmurts'),
     ('German'),
     ('Apachi'),
     ('Pole')
     

--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ

create table country (
	country_id serial primary key,
	country_name varchar(50) not null unique,
	created_at timestamp not null default current_timestamp,
	created_user varchar(64) not null default current_user,
	is_used int2 not null default 1 check (is_used in (0, 1))
	)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ

INSERT INTO country (country_name)
    VALUES
     ('Russian Federation'),
     ('Germany'),
     ('USA'),
     ('Poland')

--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

create table language_nationality (
	language_id int2 not null references language(language_id),
	nationality_id int2 not null references nationality(nationality_id),
	created_at timestamp not null default current_timestamp,
	primary key (language_id, nationality_id))

	

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

INSERT INTO language_nationality (language_id, nationality_id)
    VALUES
     (1, 1),
     (2, 2),
     (3, 4),
     (4, 3)
     

--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

create table nationality_country (
	nationality_id int2 not null references nationality(nationality_id),
	country_id int2 not null references country(country_id),
	created_at timestamp not null default current_timestamp,
	primary key (nationality_id, country_id))

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

INSERT INTO nationality_country (nationality_id, country_id)
    VALUES
     (1, 1),
     (2, 2),
     (3, 3),
     (4, 4)


--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============


--ЗАДАНИЕ №1 
--Создайте новую таблицу film_new со следующими полями:
--·   	film_name - название фильма - тип данных varchar(255) и ограничение not null
--·   	film_year - год выпуска фильма - тип данных integer, условие, что значение должно быть больше 0
--·   	film_rental_rate - стоимость аренды фильма - тип данных numeric(4,2), значение по умолчанию 0.99
--·   	film_duration - длительность фильма в минутах - тип данных integer, ограничение not null и условие, что значение должно быть больше 0
--Если работаете в облачной базе, то перед названием таблицы задайте наименование вашей схемы.

create table film_new (
	film_new_id serial primary key,
	film_name varchar(255) not null,
	film_year INTEGER CHECK (film_year > 0),
    film_rental_rate NUMERIC(4,2) DEFAULT 0.99,
    film_duration INTEGER NOT NULL CHECK (film_duration > 0)
	)

--ЗАДАНИЕ №2 
--Заполните таблицу film_new данными с помощью SQL-запроса, где колонкам соответствуют массивы данных:
--·       film_name - array       ['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--·       film_year - array       [1994,                        1999,             1985,                 1994,           1993]
--·       film_rental_rate - array[2.99,                        0.99,             1.99,                 2.99,           3.99]
--·   	  film_duration - array   [142,                         189,              116,                  142,            195]

INSERT INTO film_new (film_name, film_year, film_rental_rate, film_duration)
    VALUES
     ('The Shawshank Redemption', 1994, 2.99, 142),
     ('The Green Mile', 1999, 0.99, 189),
     ('Back to the Future', 1985, 1.99, 116),
     ('Forrest Gump', 1994, 2.99, 142),
     ('Schindlers List', 1993, 3.99, 195)

--ЗАДАНИЕ №3
--Обновите стоимость аренды фильмов в таблице film_new с учетом информации, 
--что стоимость аренды всех фильмов поднялась на 1.41

update film_new
set film_rental_rate = film_rental_rate + 1.41


--ЗАДАНИЕ №4
--Фильм с названием "Back to the Future" был снят с аренды, 
--удалите строку с этим фильмом из таблицы film_new

delete from film_new
where film_name = 'Back to the Future'

select *
from film_new fn 

--ЗАДАНИЕ №5
--Добавьте в таблицу film_new запись о любом другом новом фильме

insert into film_new (film_name, film_year, film_rental_rate, film_duration)
	VALUES
     ('Чебурашка', 2023, 3.99, 155)

--ЗАДАНИЕ №6
--Напишите SQL-запрос, который выведет все колонки из таблицы film_new, 
--а также новую вычисляемую колонку "длительность фильма в часах", округлённую до десятых

select *, ROUND(film_duration/ 60.0, 1) AS "длительность_фильма_в_часах"
from film_new fn 

--ЗАДАНИЕ №7 
--Удалите таблицу film_new

drop table film_new
