-- 1) Listar todos os clientes
SELECT * FROM Customers c 

-- 2) Listar todos os clientes com apenas Id, Name, Email e Document
SELECT c.Id, c.Name, c.Email, c.Document  FROM Customers c 

-- 3) Listar todos os clientes ordenados por Nome.
SELECT * FROM Customers c
ORDER BY c.Name 

-- 4) Listar os 20 clientes mais recentes usando TOP.
SELECT TOP 20* FROM Customers c
ORDER BY c.CreatedAt DESC 

-- 5) Listar clientes ativos.
SELECT * FROM Customers c
WHERE C.IsActive = 1

-- 6) Listar clientes inativos.
SELECT * FROM Customers c
WHERE C.IsActive = 0

-- 7) Buscar clientes cujo nome começa começa com a letra 'A'.
SELECT * FROM Customers c
WHERE c.Name LIKE 'A%'

-- 8) Buscar clientes cujo email contém gmail.
SELECT * FROM Customers c
WHERE C.Email LIKE '%email%'

-- 9) Buscar clientes sem telefone.
SELECT * FROM Customers c
WHERE C.Phone IS NULL

-- 10) Buscar clientes com telefone preenchido.
SELECT * FROM Customers c
WHERE C.Phone IS NOT NULL

-- 11) Buscar clientes sem telefone e imprimir na coluna 'Não encontrado'
SELECT
	c.Id,
	c.Name,
	c.Email,
	ISNULL(c.Phone, 'Não encontrado') AS Phone,
	c.Document
FROM Customers c

-- 12) Buscar clientes que possuem pelo menos um pedido
SELECT * FROM Customers c 
WHERE EXISTS(
	SELECT * FROM Orders o
	where o.CustomerId = c.Id 
)

-- 13) Mostrar clientes, e em uma coluna extra, o total de pedidos de cada cliente.
SELECT
	*,
	(
		SELECT COUNT(*) FROM Orders o
		WHERE o.CustomerId = c.Id 
	) AS TotalDePedidos
FROM Customers c 

-- 14) Buscar clientes que compraram acima da média geral de pedidos.


-- 15) Buscar clientes que possuem pedido com valor maior que 100.000.
SELECT c.Id, c.Name, c.Document, c.Phone FROM Customers c
WHERE EXISTS(
	SELECT * FROM Orders o
	where o.CustomerId = c.Id AND o.TotalAmount > 10000
)

-- 1) Listar todos os pedidos
select * from Orders o 

-- 2) Listar todos os pedidos por Id, Name, CustomerId, EmployeeId, Status, TotalAmount e CreatedAt
select o.Id, o.Name, o.CustomerId, o.EmployeeId, o.Status, o.TotalAmount, o.CreatedAt from Orders o 

-- 3) Listar os pedidos ordenados por data mais recente.
select * from Orders o 
order by o.CreatedAt 

-- 4) Listar os 50 pedidos mais recentes
select TOP(50)* from Orders o 
order by o.CreatedAt

-- 5) Listar pedidos por status
select
	o.Status,
	count(*) as TotalPedidos
from Orders o
group by o.Status

-- 6) Listar pedidos com valor maior que 1000.
select * from Orders o 
where o.TotalAmount > 1000

-- 7) Listar pedidos criados em determinado periodo.
select
	count(*) as TotalPedidos,
	o.CreatedAt 
from Orders o 
group by o.CreatedAt 

-- 8) Listar pedidos com TotalAmount zerado ou nulo caso existam.
select COUNT(*) as TotalPedidosNulos from Orders o 
where o.TotalAmount = 0 or o.TotalAmount is null

-- 10) Listar status distintos dos pedidos.
select distinct o.Status from Orders o

-- 11) Listar contabilização de pedidos que possuem pagamento.
select COUNT(*) as TotalPedidosPagos, o.Status from Orders o
where o.Status = 'Paid'
group by o.Status

-- 12) Listar contabilização de pedidos sem pagamento.
select count(*) as TotalPedidosSemPagamento, o.Status from Orders o 
where o.Status <> 'Paid'
group by o.Status 

-- 13) Listar contabilização de todos os pedidos que possuem itens.
select count(*) as PedidosQuePossuemItens from Orders o 
where exists(
	select * from OrderItems oi 
	where oi.OrderId = o.Id
)

-- 14) Listar contabilização de todos os pedidos sem itens, caso existam.
select count(*) as PedidosQueNaoPossuemItens from Orders o 
where not exists(
	select * from OrderItems oi 
	where oi.OrderId = o.Id
)

-- 15) Listar pedidos, e em uma coluna extra, o total calculdado pelos itens.
select
	*,
	(
		select coalesce(sum(oi.TotalPrice), 0) from OrderItems oi 
		where oi.OrderId = o.Id
	) as TotalCalculadoNosItens
from Orders o

-- 16) Listar contabilização dos pedidos cujo total é diferente da soma dos itens.
select count(*) as TotalPedidos from Orders o 
where o.TotalAmount <> (
	select coalesce(sum(oi.TotalPrice), 0) from OrderItems oi 
	where oi.OrderId = o.Id
)

-- 17) Listar contabilização de pedidos do cliente e o nome do cliente que mais comprou em coluna extra.
select TOP 1
	count(*) as TotalPedidos,
	c.Name as NomeCliente
from Orders o 
inner join Customers c
	on c.Id = o.CustomerId
where o.Status = 'Paid'	
group by c.Name, c.Id
order by count(*) desc