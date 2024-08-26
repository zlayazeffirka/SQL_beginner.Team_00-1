create table routes(
	point1 char(1),
	point2 char(1),
	cost int
);
insert into routes(point1, point2, cost) values
	('A', 'B', 10),
	('B', 'A', 10),
	('A', 'C', 15),
	('C', 'A', 15),
	('A', 'D', 20),
	('D', 'A', 20),
	('B', 'C', 35),
	('C', 'B', 35),
	('B', 'D', 25),
	('D', 'B', 25),
	('C', 'D', 30),
	('D', 'C', 30);

with recursive tour(route, last_town, total_cost, town_count) as (
	select
		cast('A' as varchar) as route,
		cast('A' as varchar) as last_town,
		0 as total_cost,
		1 as town_count
	union all
	select
		concat(tour.route, ',', routes.point2),
		routes.point2,
		tour.total_cost+routes.cost,
		tour.town_count+1
	from
		tour
	join
		routes on routes.point1=tour.last_town
	where
		position(routes.point2 in tour.route)=0
)
select
	total_cost+(select cost from routes where point1=last_town and point2='A') as total_cost,
	concat('{', route, ',A}') as tour
from
	tour
where
	town_count=4
order by
	total_cost, tour;
