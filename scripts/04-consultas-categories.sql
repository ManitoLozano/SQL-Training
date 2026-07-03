-- 1) Listar todas as categorias
SELECT * FROM Categories c 

-- 2) Listar apenas Id, Name e IsActive.
SELECT c.Id, c.Name, c.IsActive FROM Categories c 

-- 3) Listar categorias ativas.
SELECT * FROM Categories c
WHERE c.IsActive = 1

-- 4) Listar categorias inativas.
SELECT * FROM Categories c 
WHERE c.IsActive = 0

-- 5) Listar categorias ordenadas pelo nome.
SELECT * FROM Categories c
ORDER BY c.Name

-- 6) Listar categorias sem descrição.
SELECT * FROM Categories c
WHERE c.Description IS NULL

-- 7) Listar categorias com coluna de descrição 'Não informada' quando for null.
SELECT
	c.Id,
	c.Name,
	ISNULL(c.Description, 'Não informado') AS Description,
	c.IsActive 
FROM Categories c

-- 8) Listar categorias que não existem em produtos.
SELECT * FROM Categories c
WHERE NOT EXISTS(
	SELECT * FROM Products p
	WHERE p.CategoryId = c.Id
)

-- 9) Listar categorias e a quantidade de produtos em cada uma, em coluna extra.
SELECT 
	*,
	(
		SELECT COUNT(*) FROM Products p
		WHERE p.CategoryId = c.Id
	) AS TotalProdutos
FROM Categories c


-- 10) Buscar categorias que possuem produtos com estoque zerado.
SELECT * FROM Categories c
WHERE EXISTS(
	SELECT * FROM Products p
	where p.CategoryId = c.Id 
	and p.StockQuantity = 0
)


-- 11) Buscar categorias que possuem produtos abaixo do estoque mínimo.
SELECT * FROM Categories c 
WHERE EXISTS(
	SELECT * FROM Products p 
	where p.CategoryId = c.Id
	and p.StockQuantity < p.MinimumStockQuantity 
)