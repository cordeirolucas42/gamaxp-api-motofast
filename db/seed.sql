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
    aluguel_data_retirada TIMESTAMP,
    aluguel_data_entrega TIMESTAMP,
    aluguel_local_retirada int,
    aluguel_local_entrega int,
    reservada BOOLEAN NOT NULL DEFAULT FALSE,
    reserva_data_retirada TIMESTAMP,
    reserva_data_entrega TIMESTAMP,
    reserva_local_retirada int,
    reserva_local_entrega int,
    local_id int,
    FOREIGN KEY (local_id) REFERENCES locais(local_id) ON DELETE CASCADE,
    FOREIGN KEY (aluguel_local_retirada) REFERENCES locais(local_id) ON DELETE CASCADE,
    FOREIGN KEY (aluguel_local_entrega) REFERENCES locais(local_id) ON DELETE CASCADE,
    FOREIGN KEY (reserva_local_retirada) REFERENCES locais(local_id) ON DELETE CASCADE,
    FOREIGN KEY (reserva_local_entrega) REFERENCES locais(local_id) ON DELETE CASCADE
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
    motos(placa, manutencao, alugada, aluguel_data_retirada, aluguel_data_entrega, aluguel_local_retirada, aluguel_local_entrega, reservada, reserva_data_retirada, reserva_data_entrega, reserva_local_retirada, reserva_local_entrega, local_id)
VALUES
    ('HZT-4589',false,true,'2021-09-10','2021-10-25',1,2,true,'2021-10-30','2021-11-20',2,4,NULL),
    ('IXA-2261',false,true,'2021-09-10','2021-10-30',2,3,false,NULL,NULL,NULL,NULL,NULL),
    ('HTA-1468',false,true,'2021-09-10','2021-11-10',2,2,false,NULL,NULL,NULL,NULL,NULL),
    ('NAS-4213',false,false,NULL,NULL,NULL,NULL,true,'2021-10-20','2021-11-20',1,2,1),
    ('NAL-4595',false,false,NULL,NULL,NULL,NULL,true,'2021-10-25','2021-10-30',2,2,2),
    ('LVK-9567',false,false,NULL,NULL,NULL,NULL,true,'2021-11-30','2021-12-10',3,1,3),
    ('JTL-1616',true,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,1),
    ('HRM-8945',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,2),
    ('NET-3865',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,2),
    ('LCZ-8224',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,2),
    ('JQE-0155',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,3),
    ('MRY-9564',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,3),
    ('HZW-9905',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,4)
RETURNING *;

-- Query para checar motos disponíveis na data '2021-11-01'
-- select * from motos where (manutencao is false) and (alugada is false or aluguel_entrega<'2021-11-01') and (reservada is false or reserva_entrega<'2021-11-01');
-- select count(*) as motos_disponiveis,endereco from locais natural join motos where (manutencao is false) and (alugada is false or aluguel_entrega<'2021-11-01') and (reservada is false or reserva_entrega<'2021-11-01') group by endereco order by motos_disponiveis DESC;