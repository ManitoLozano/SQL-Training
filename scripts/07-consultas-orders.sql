-- 1) Listar todos os pedidos
select * from Orders o 

-- 2) Listar todos os pedidos por Id, Name, CustomerId, EmployeeId, Status, TotalAmount e CreatedAt
select
	o.Id,
	o.Name,
	o.CustomerId,
	o.EmployeeId,
	o.Status,
	o.TotalAmount,
	o.CreatedAt
from Orders o 

-- 3) Listar pedidos ordernados pela data mais recente
select * from Orders o
order by o.CreatedAt desc

-- 4) Listar os 50 pedidos mais recentes
select TOP 50 * from Orders o 
order by o.CreatedAt desc

-- 5) Listar os pedidos por status
select o.Status, COUNT(*) from Orders o
group by o.Status

-- 6) Listar os pedidos com valor maior que 100
select * from Orders o 
where o.TotalAmount > 10000

-- 7) Listar os pedidos com valor entre 500 e 2000
select * from Orders o
where o.TotalAmount >= 500 and o.TotalAmount <= 2000

-- 8) Listar os pedidos criados entre 01/01/2026 e 01/03/2026
select * from Orders o 
where o.CreatedAt >= '2026-01-01' and o.CreatedAt <= '2026-03-01'

-- 9) Listar os pedidos com TotalAmount zerado ou null caso existam
select * from Orders o
where o.TotalAmount is null or o.TotalAmount = 0

-- 10) Listar status dos pedidos
select DISTINCT (o.Status) from Orders o 

-- 11) Mostrar contabilização dos pedidos que possuem pagamento
select COUNT(*) as TotalPagos from Orders o 
where o.Status = 'Paid'

-- 12) Mostrar contabilização dos pedidos que não foram pagos
select COUNT(*) as TotalPedidos from Orders o
where o.Status <> 'Paid'

-- 13) Mostrar contabilização dos pedidos que possuem itens
select COUNT(*) as TotalPedidos from Orders o
where exists(
	select 1 from OrderItems oi 
	where oi.OrderId = o.Id
)

-- 14) Mostrar contabilização dos pedidos que não possuem itens
select COUNT(*) as TotalPedidos from Orders o
where not exists(
	select 1 from OrderItems oi
	where oi.OrderId = o.Id
)

-- 15) Listar apenas pedidos com itens e em coluna extra o total calculado pelos itens
select o.Name, coalesce(SUM(oi.TotalPrice), 0) as TotalItens from Orders o
inner join OrderItems oi on oi.OrderId = o.Id
group by o.Name 


-- 16) Listar apenas pedidos com itens e que valor total do pedido é diferente da soma dos itens
select o.Name, o.TotalAmount as TotalPedido, sum(oi.TotalPrice) as TotalItens from Orders o
inner join OrderItems oi on oi.OrderId = o.Id
group by o.Id, o.Name, o.TotalAmount
having o.TotalAmount <> sum(oi.TotalPrice)

-- 17) Buscar pedidos do cliente que mais comprou e exibir em coluna extra o nome do cliente
select o.Name, o.TotalAmount, c.Name as Cliente from Orders o
inner join Customers c on c.Id = o.CustomerId
where o.Status = 'Paid' and c.Id = (
	select top 1 o2.CustomerId from Orders o2
	where o2.Status = 'Paid'
	group by o2.CustomerId
	order by SUM(o2.TotalAmount) desc
)

-- 18) Buscar pedidos do funcionário que mais vendeu, e exibir em coluna extra o nome do cliente
select o.Name, o.TotalAmount, e.Name as Vendedor from Orders o
inner join Employees e on e.Id = o.EmployeeId
where o.Status = 'Paid' and e.Id = (
	select top 1 o2.EmployeeId from Orders o2
	where o2.Status = 'Paid'
	group by o2.EmployeeId
	order by sum(o2.TotalAmount) desc
)