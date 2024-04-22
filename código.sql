

create table marcas (
mrc_id 		int auto_increment	primary key,
mrc_nome 	varchar(50)	not null,
mrc_nacionalidade varchar(50)
);

create table produtos (
prd_id
int
auto_increment
primary key,
prd_nome
varchar(50)
not null,
prd_qtd_estoque
int
not null
default 0,
prd_estoque_mim
int
not null
default 0,
prd_data_fabricacao
timestamp
default now(),
prd_perecivel
boolean,
prd_valor
decimal(10,2),
prd_marca_id
int,
constraint fk_marcas
foreign key (prd_marca_id) references marcas (mrc_id)
);
create table fornecedores (
frn_id	int	auto_increment	primary key,
frn_nome varchar(50)	not null,
frn_email	varchar(50)
);
create table produto_fornecedor (
pf_prod_id
int
references produtos
(prd_id),
pf_forn_id
int
references fornecedores (frn_id),
primary key (pf_prod_id, pf_forn_id)
);

CREATE VIEW vw_produtos_com_marcas AS
SELECT 
    prd_id,
    prd_nome,
    prd_qtd_estoque,
    prd_estoque_mim,
    prd_data_fabricacao,
    prd_perecivel,
    prd_valor,
    m.mrc_id AS marca_id,
    m.mrc_nome AS marca_nome,
    m.mrc_nacionalidade AS marca_nacionalidade
FROM 
    produtos p
JOIN 
    marcas m ON p.prd_marca_id = m.mrc_id;

CREATE VIEW vw_produtos_com_fornecedores AS
SELECT 
    p.prd_id,
    p.prd_nome,
    p.prd_qtd_estoque,
    p.prd_estoque_mim,
    p.prd_data_fabricacao,
    p.prd_perecivel,
    p.prd_valor,
    f.frn_id AS fornecedor_id,
    f.frn_nome AS fornecedor_nome,
    f.frn_email AS fornecedor_email
FROM 
    produtos p
JOIN 
    produto_fornecedor pf ON p.prd_id = pf.pf_prod_id
JOIN 
    fornecedores f ON pf.pf_forn_id = f.frn_id;
    
    CREATE VIEW vw_produtos_com_fornecedores_e_marcas AS
SELECT 
    p.prd_id,
    p.prd_nome,
    p.prd_qtd_estoque,
    p.prd_estoque_mim,
    p.prd_data_fabricacao,
    p.prd_perecivel,
    p.prd_valor,
    m.mrc_id AS marca_id,
    m.mrc_nome AS marca_nome,
    m.mrc_nacionalidade AS marca_nacionalidade,
    f.frn_id AS fornecedor_id,
    f.frn_nome AS fornecedor_nome,
    f.frn_email AS fornecedor_email
FROM 
    produtos p
JOIN 
    produto_fornecedor pf ON p.prd_id = pf.pf_prod_id
JOIN 
    fornecedores f ON pf.pf_forn_id = f.frn_id
JOIN 
    marcas m ON p.prd_marca_id = m.mrc_id;

CREATE VIEW vw_produtos_estoque_baixo AS
SELECT 
    prd_id,
    prd_nome,
    prd_qtd_estoque,
    prd_estoque_mim,
    prd_data_fabricacao,
    prd_perecivel,
    prd_valor,
    prd_marca_id
FROM 
    produtos
WHERE 
    prd_qtd_estoque < prd_estoque_mim;
    
    ALTER TABLE produtos
ADD COLUMN prd_data_validade DATE;

INSERT INTO marcas (mrc_nome, mrc_nacionalidade) VALUES
('Marca A', 'Nacional'),
('Marca B', 'Internacional'),
('Marca C', 'Nacional');

INSERT INTO produtos (prd_nome, prd_qtd_estoque, prd_estoque_mim, prd_data_fabricacao, prd_perecivel, prd_valor, prd_marca_id, prd_data_validade)
VALUES
    ('Produto A', 50, 10, '2024-04-15', TRUE, 10.50, 1, '2024-12-31'),
    ('Produto B', 30, 5, '2024-04-15', TRUE, 8.75, 2, '2025-06-30'),
    ('Produto C', 20, 8, '2024-04-15', TRUE, 15.00, 1, '2024-10-31');

CREATE VIEW vw_produtos_com_validade_vencida AS
SELECT 
    p.prd_id,
    p.prd_nome,
    p.prd_qtd_estoque,
    p.prd_estoque_mim,
    p.prd_data_fabricacao,
    p.prd_perecivel,
    p.prd_valor,
    m.mrc_id AS marca_id,
    m.mrc_nome AS marca_nome,
    m.mrc_nacionalidade AS marca_nacionalidade,
    p.prd_data_validade
FROM 
    produtos p
JOIN 
    marcas m ON p.prd_marca_id = m.mrc_id
WHERE 
    p.prd_data_validade < CURDATE();
    
    SELECT 
    prd_id,
    prd_nome,
    prd_qtd_estoque,
    prd_estoque_mim,
    prd_data_fabricacao,
    prd_perecivel,
    prd_valor,
    prd_marca_id
FROM 
    produtos
WHERE 
    prd_valor > (
        SELECT AVG(prd_valor) FROM produtos
    );




