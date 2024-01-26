# Таблицы учебной базы данных dvd-rental, которые имеют ограничения первичных ключей

|№ | Название таблицы|Поле таблицы, которое является PK |
|- |-----------------|--------------------------------- |
|1 |payment          |payment_id                        |
|2 |rental           |rental_id                         |
|3 |customer         |customer_id                       |
|4 |store            |store_id                          |
|5 |staff            |staff_id                          |
|6 |address          |address_id                        |
|7 |city             |city_id                           |
|8 |country          |country_id                        |
|9 |inventory        |inventory-id                      |
|10|film             |film_id                           |
|11|language         |language_id                       |
|12|category         |category_id                       |
|13|film_category    |Составной PK: film_id, category_id|
|14|film_actor       |Составной PK: actor_id, film_id   |
|15|actor            |actor_id                          |
