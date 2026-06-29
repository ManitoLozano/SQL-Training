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