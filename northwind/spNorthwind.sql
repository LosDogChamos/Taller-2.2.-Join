-- ======================================================================
-- CONSULTAS CON INNER JOIN (8 procedimientos)
-- ======================================================================

-- 1. Listar pedidos con cliente y empleado (filtro opcional por CustomerID)
if object_id('spConsulta1') is not null
    drop proc spConsulta1
go

create proc spConsulta1
    @CustomerID nchar(5) = null
as
begin
    select 
        o.OrderID,
        o.OrderDate,
        c.CompanyName as Cliente,
        e.LastName + ', ' + e.FirstName as Empleado
    from Orders o
    inner join Customers c on o.CustomerID = c.CustomerID
    inner join Employees e on o.EmployeeID = e.EmployeeID
    where @CustomerID is null or o.CustomerID = @CustomerID
end
go

exec spConsulta1          -- Todos los pedidos
exec spConsulta1 'ALFKI'  -- Solo pedidos del cliente ALFKI
go

-- 2. Mostrar el detalle de un pedido específico (filtro por OrderID)
if object_id('spConsulta2') is not null
    drop proc spConsulta2
go

create proc spConsulta2
    @OrderID int = null
as
begin
    select 
        od.OrderID,
        p.ProductName,
        od.UnitPrice,
        od.Quantity,
        od.Discount
    from [Order Details] od
    inner join Products p on od.ProductID = p.ProductID
    where @OrderID is null or od.OrderID = @OrderID
end
go

exec spConsulta2       -- Todos los detalles
exec spConsulta2 10248 -- Solo detalles del pedido 10248
go

-- 3. Productos con nombre de categoría y proveedor (filtro opcional por CategoryID)
if object_id('spConsulta3') is not null
    drop proc spConsulta3
go

create proc spConsulta3
    @CategoryID int = null
as
begin
    select 
        p.ProductName,
        c.CategoryName,
        s.CompanyName as Proveedor
    from Products p
    inner join Categories c on p.CategoryID = c.CategoryID
    inner join Suppliers s on p.SupplierID = s.SupplierID
    where @CategoryID is null or p.CategoryID = @CategoryID
end
go

exec spConsulta3      -- Todos los productos
exec spConsulta3 1    -- Solo productos de la categoría 1 (Beverages)
go

-- 4. Empleados con el nombre de su jefe (auto-join, sin filtro)
if object_id('spConsulta4') is not null
    drop proc spConsulta4
go

create proc spConsulta4
as
begin
    select 
        e.FirstName + ' ' + e.LastName as Empleado,
        m.FirstName + ' ' + m.LastName as Jefe
    from Employees e
    inner join Employees m on e.ReportsTo = m.EmployeeID
end
go

exec spConsulta4
go

-- 5. Pedidos con el nombre del transportista (filtro opcional por ShipperID)
if object_id('spConsulta5') is not null
    drop proc spConsulta5
go

create proc spConsulta5
    @ShipperID int = null
as
begin
    select 
        o.OrderID,
        o.OrderDate,
        s.CompanyName as Transportista
    from Orders o
    inner join Shippers s on o.ShipVia = s.ShipperID
    where @ShipperID is null or o.ShipVia = @ShipperID
end
go

exec spConsulta5      -- Todos los pedidos
exec spConsulta5 1    -- Solo pedidos enviados por Speedy Express (ShipperID=1)
go

-- 6. Productos que han sido pedidos (evita productos sin ventas)
if object_id('spConsulta6') is not null
    drop proc spConsulta6
go

create proc spConsulta6
as
begin
    select distinct 
        p.ProductID,
        p.ProductName
    from Products p
    inner join [Order Details] od on p.ProductID = od.ProductID
    order by p.ProductName
end
go

exec spConsulta6
go

-- 7. Clientes que han realizado pedidos en un año específico (parámetro @Year)
if object_id('spConsulta7') is not null
    drop proc spConsulta7
go

create proc spConsulta7
    @Year int = 1997
as
begin
    select distinct 
        c.CustomerID,
        c.CompanyName
    from Customers c
    inner join Orders o on c.CustomerID = o.CustomerID
    where year(o.OrderDate) = @Year
end
go

exec spConsulta7      -- Año 1997 por defecto
exec spConsulta7 1996 -- Clientes con pedidos en 1996
go

-- 8. Territorios asignados a cada empleado (filtro opcional por EmployeeID)
if object_id('spConsulta8') is not null
    drop proc spConsulta8
go

create proc spConsulta8
    @EmployeeID int = null
as
begin
    select 
        e.LastName + ', ' + e.FirstName as Empleado,
        t.TerritoryDescription,
        r.RegionDescription
    from EmployeeTerritories et
    inner join Employees e on et.EmployeeID = e.EmployeeID
    inner join Territories t on et.TerritoryID = t.TerritoryID
    inner join Region r on t.RegionID = r.RegionID
    where @EmployeeID is null or et.EmployeeID = @EmployeeID
end
go

exec spConsulta8       -- Todos los empleados
exec spConsulta8 1     -- Solo territorios de la empleada Nancy Davolio
go

-- ======================================================================
-- CONSULTA CON LEFT JOIN (Clientes sin pedidos)
-- ======================================================================
if object_id('spConsulta9') is not null
    drop proc spConsulta9
go

create proc spConsulta9
as
begin
    select 
        c.CustomerID,
        c.CompanyName,
        o.OrderID,
        o.OrderDate
    from Customers c
    left join Orders o on c.CustomerID = o.CustomerID
    where o.OrderID is null   -- Solo clientes sin pedidos
end
go

exec spConsulta9
go

-- ======================================================================
-- CONSULTA CON RIGHT JOIN (Productos nunca pedidos)
-- ======================================================================
if object_id('spConsulta10') is not null
    drop proc spConsulta10
go

create proc spConsulta10
as
begin
    select 
        p.ProductID,
        p.ProductName,
        od.OrderID
    from [Order Details] od
    right join Products p on od.ProductID = p.ProductID
    where od.OrderID is null   -- Solo productos sin ninguna venta
end
go

exec spConsulta10
go