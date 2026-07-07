-- 1) Listar todos os empregados
select * from Employees e 

-- 2) Listar todos os empregados por Id, Nome, Email, Cargo e EhAtivo
select e.Id, e.Name, e.Email, e.[Role], e.IsActive from Employees e

-- 3) Listar todos os empregados ativos
declare @statusAtivo BIT = 1;

select * from Employees e
where IsActive = @statusAtivo

-- 4) Listar todos os empregados inativos.
declare @statusInativo BIT = 0;

select * from Employees e
where e.IsActive = @statusInativo;

-- 5) Listar os empregados com o cargo SalesPerson.
declare @salesPersonRole VARCHAR(Max) = 'SalesPerson';

select * from Employees e
where e.[Role] = @salesPersonRole;

-- 6) Listar os empregados com o cargo Manager.
declare @managerRole VARCHAR(MAX) = 'Manager';

select * from Employees e
where e.[Role] = @managerRole;

-- 7) Listar os empregados ordenados por email.
select * from Employees e 
order by e.Email;

-- 8) Listar os empregados que começam com 'Employee 3'
select * from Employees e
where e.Name like 'Employee 3%'

-- 9) Listar os empregados que nunca venderam.
select * from Employees e 
where not exists(
	select * from Orders o 
	where o.EmployeeId = e.Id
		and o.Status = 'Paid'
)

-- 10) Listar os empregados, e em coluna extra, o total de pedidos por cada um
select
*,
(
	select COUNT(*) from Orders o 
	where o.EmployeeId = e.Id
) as TotalPedidos
from Employees e

-- 11) Listar os empregados, e em coluna extra, o total faturado por cada um
select
*,
(
	select COALESCE(SUM(o.TotalAmount), 0) from Orders o
	where o.EmployeeId = e.Id
		and o.Status = 'Paid'
) as TotalFaturado
from Employees e 

-- 12) Listar os empregados que possuem pedidos cancelados.
select * from Employees e
where exists(
	select * from Orders o 
	where o.EmployeeId = e.Id
		and o.Status = 'Cancelled'
)

-- 13) Listar os empregados que possuem pedidos sem pagamento
select * from Employees e
where exists(
	select * from Orders o
	where o.EmployeeId = e.Id
		and o.Status <> 'Paid'
)