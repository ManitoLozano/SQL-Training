use SqlTraining_Dev_Restored

-- 1) Listar todos os produtos
select * from Products p 

-- 2) Listar todos os produtos por Id, Nome, Preço, Estoque e Estoque mínimo
select p.Id, p.Name, p.Price, p.StockQuantity, p.MinimumStockQuantity from Products p 

-- 3) Listar apenas produtos ativos
select * from Products p
where p.IsActive = 1

-- 4) Listar apenas produtos inativos
select * from Products p 
where p.IsActive = 0

-- 5) Listar produtos ordenados por preço do maior ao menor
select * from Products p 
order by p.Price DESC 

-- 6) Listar os 20 produtos mais caros
select TOP 20* from Products p
order by p.Price desc

-- 7) Listar os 20 produtos mais baratos
select TOP 20* from Products p 
order by p.Price asc

-- 8) Buscar os produtos com preço entre 100 e 500.
select * from Products p 
where p.Price BETWEEN 100 and 500

-- 9) Buscar os produtos que tem estoque zerado
select * from Products p 
where p.StockQuantity = 0

-- 10) Buscar os produtos que tem o estoque abaixo do mínimo
select * from Products p 
where p.StockQuantity < p.MinimumStockQuantity

-- 11) Buscar os produtos que possuem numeração 33 no nome
select * from Products p 
where p.Name like '%33%'

-- 12) Listar os produtos e uma coluna extra mostrando a quantidade total vendida
select 
*,
(
	select COALESCE(SUM(oi.Quantity), 0) from OrderItems oi
	where oi.ProductId = p.Id
		and exists(
			select * from Orders o
			where o.Id = oi.OrderId
				and o.Status = 'Paid'
		)
	
) as TotalVendido
from Products p 
where p.StockQuantity = 0


-- 13) Listar apenas os produtos que já foram vendidos
select * from Products p 
where exists (
	select * from OrderItems oi
	where oi.ProductId = p.Id
		and exists(
			select * from Orders o
			where o.Id = oi.OrderId
				and o.Status = 'Paid'
		)
);

-- 14) Listar apenas os produtos que nunca foram vendidos
select * from Products p
where not exists(
	select * from OrderItems oi
	where oi.ProductId = p.Id
		and exists (
			select * from Orders o 
			where o.Id = oi.OrderId
				and o.Status = 'Paid'
		)
);

-- 15) Listar os produtos e uma coluna extra indicando o faturamento total gerado
select
*,
(
	select COALESCE(SUM(oi.TotalPrice), 0) from OrderItems oi
	where oi.ProductId = p.Id
		and exists(
			select 1 from Orders o
			where o.Id = oi.OrderId
				and o.Status = 'Paid'
		)
) as FaturamentoTotalGerado
from Products p

-- 16) Buscar produtos que aparecem em pedidos pagos
select * from Products p
where exists(
	select 1 from OrderItems oi
	where oi.ProductId = p.Id
		and exists(
			select 1 from Orders o
			where o.Id = oi.OrderId
				and o.Status = 'Paid'
		)
)

-- 17) Buscar produtos que aparecem em pedidos cancelados
select * from Products p
where exists(
	select 1 from OrderItems oi
	where oi.ProductId = p.Id
		and exists(
			select 1 from Orders o 
			where o.Id = oi.OrderId
				and o.Status = 'Cancelled'
		)
)

-- 18) Buscar preços dos produtos usando DISTINCT para não haver repetições
select DISTINCT(p.Price) from Products p