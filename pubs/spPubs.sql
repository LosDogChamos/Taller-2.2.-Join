--- 1. Ingresos estimados por libro
-- Negocio: calcular cuánto dinero genera cada libro (ventas * precio)

select T.Title, sum(S.Qty * T.Price) as Ingreso_estimado
from Titles T inner join Sales S 
on T.Title_id = S.Title_id
group by T.Title;



--- 2. Libros más rentables
-- Negocio: ranking de libros que más dinero generan

select T.Title, sum(S.Qty * T.Price) as Ingreso_estimado
from Titles T inner join Sales S 
on T.Title_id = S.Title_id
group by T.Title
order by Ingreso_estimado desc;



--- 3. Clientes (tiendas) que más compran en dinero
-- Negocio: detectar mejores clientes

select ST.Stor_name, sum(S.Qty * T.Price) as Total_gastado
from Stores ST inner join Sales S 
on ST.Stor_id = S.Stor_id
inner join Titles T 
on S.Title_id = T.Title_id
group by ST.Stor_name
order by Total_gastado desc;



--- 4. Libros sin movimiento en ventas
-- Negocio: inventario muerto

select T.Title
from Titles T left join Sales S 
on T.Title_id = S.Title_id
where S.Title_id is null;



--- 5. Autores con mayor cantidad de libros
-- Negocio: productividad de autores

select A.Au_fname, A.Au_lname, count(TA.Title_id) as Total_libros
from Authors A inner join Titleauthor TA 
on A.Au_id = TA.Au_id
group by A.Au_fname, A.Au_lname
order by Total_libros desc;



--- 6. Libros por editorial con ingresos
-- Negocio: rendimiento de cada editorial

select P.Pub_name, sum(S.Qty * T.Price) as Ingresos
from Publishers P inner join Titles T 
on P.Pub_id = T.Pub_id
inner join Sales S 
on T.Title_id = S.Title_id
group by P.Pub_name
order by Ingresos desc;



--- 7. Top 3 libros más vendidos
-- Negocio: ranking comercial

select top 3 T.Title, sum(S.Qty) as Total_vendido
from Titles T inner join Sales S 
on T.Title_id = S.Title_id
group by T.Title
order by Total_vendido desc;



--- 8. Autores que generan más ingresos
-- Negocio: pagar más a autores más rentables

select A.Au_fname, A.Au_lname, sum(S.Qty * T.Price) as Ingresos_generados
from Authors A inner join Titleauthor TA 
on A.Au_id = TA.Au_id
inner join Titles T 
on TA.Title_id = T.Title_id
inner join Sales S 
on T.Title_id = S.Title_id
group by A.Au_fname, A.Au_lname
order by Ingresos_generados desc;


use pubs

--- LEFT JOIN (1 consulta)
-- Negocio: autores sin libros publicados

select A.Au_fname, A.Au_lname, T.Title
from Authors A left join Titleauthor TA 
on A.Au_id = TA.Au_id
left join Titles T 
on TA.Title_id = T.Title_id;



--- RIGHT JOIN (1 consulta)
-- Negocio: libros sin autor asignado

select T.Title, TA.Au_id
from Titleauthor TA right join Titles T 
on TA.Title_id = T.Title_id;