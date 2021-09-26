DROP TABLE IF EXISTS motos;
DROP TABLE IF EXISTS locais;

CREATE TABLE locais (
	local_id serial PRIMARY KEY,
    lotacao int NOT NULL,
	endereco text NOT NULL
);

CREATE TABLE motos (
	id serial PRIMARY KEY,
	placa text NOT NULL DEFAULT 'AAA-1234',
    manutencao BOOLEAN NOT NULL DEFAULT FALSE,
    alugada BOOLEAN NOT NULL DEFAULT FALSE,
    reservada BOOLEAN NOT NULL DEFAULT FALSE,
    aluguel_retirada TIMESTAMP,
    aluguel_entrega TIMESTAMP,
    reserva_retirada TIMESTAMP,
    reserva_entrega TIMESTAMP,
    local_id int NOT NULL,
    FOREIGN KEY (local_id) REFERENCES locais(local_id) ON DELETE CASCADE
);

INSERT INTO
    locais(lotacao,endereco)
VALUES
    (5,'R. Flórida, 1.790 - Cidade Monções, São Paulo - SP, 04565-001'),
    (10,'R. Leopoldo Couto de Magalhães Júnior, 994 - Jardim Paulista, São Paulo - SP, 04552-000'),
    (4,'Rua Dr. Guilherme Bannitz, 90 - Vila Nova Conceição, São Paulo - SP, 04532-060'),
    (5,'Av. Engenheiro Luís Carlos Berrini, 1774 - Cidade Monções, São Paulo - SP, 04571-000')
RETURNING *;

INSERT INTO
    motos(placa,manutencao,alugada,reservada,aluguel_retirada,aluguel_entrega,reserva_retirada,reserva_entrega,local_id)
VALUES
    ('HZT-4589',false,true,false,'2021-09-10','2021-10-25',NULL,NULL,(SELECT local_id FROM locais WHERE endereco LIKE '%Flórida%')),
    ('IXA-2261',false,true,false,'2021-09-10','2021-10-30',NULL,NULL,(SELECT local_id FROM locais WHERE endereco LIKE '%Leopoldo%')),
    ('HTA-1468',false,true,false,'2021-09-10','2021-11-10',NULL,NULL,(SELECT local_id FROM locais WHERE endereco LIKE '%Guilherme%')),
    ('NAS-4213',false,false,true,NULL,NULL,'2021-10-20','2021-11-20',(SELECT local_id FROM locais WHERE endereco LIKE '%Flórida%')),
    ('NAL-4595',false,false,true,NULL,NULL,'2021-10-25','2021-10-30',(SELECT local_id FROM locais WHERE endereco LIKE '%Leopoldo%')),
    ('LVK-9567',false,false,true,NULL,NULL,'2021-11-30','2021-12-10',(SELECT local_id FROM locais WHERE endereco LIKE '%Guilherme%')),
    ('JTL-1616',true,false,false,NULL,NULL,NULL,NULL,(SELECT local_id FROM locais WHERE endereco LIKE '%Flórida%')),
    ('HRM-8945',false,false,false,NULL,NULL,NULL,NULL,(SELECT local_id FROM locais WHERE endereco LIKE '%Leopoldo%')),
    ('NET-3865',false,false,false,NULL,NULL,NULL,NULL,(SELECT local_id FROM locais WHERE endereco LIKE '%Leopoldo%')),
    ('LCZ-8224',false,false,false,NULL,NULL,NULL,NULL,(SELECT local_id FROM locais WHERE endereco LIKE '%Leopoldo%')),
    ('JQE-0155',false,false,false,NULL,NULL,NULL,NULL,(SELECT local_id FROM locais WHERE endereco LIKE '%Guilherme%')),
    ('MRY-9564',false,false,false,NULL,NULL,NULL,NULL,(SELECT local_id FROM locais WHERE endereco LIKE '%Guilherme%')),
    ('HZW-9905',false,false,false,NULL,NULL,NULL,NULL,(SELECT local_id FROM locais WHERE endereco LIKE '%Engenheiro%'))
RETURNING *;

-- Query para checar motos disponíveis na data '2021-11-01'
-- select * from motos where (manutencao is false) and (alugada is false or aluguel_entrega<'2021-11-01') and (reservada is false or reserva_entrega<'2021-11-01');
-- select count(*) as motos_disponiveis,endereco from locais natural join motos where (manutencao is false) and (alugada is false or aluguel_entrega<'2021-11-01') and (reservada is false or reserva_entrega<'2021-11-01') group by endereco order by motos_disponiveis DESC;