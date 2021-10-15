DROP TABLE IF EXISTS motos;
DROP TABLE IF EXISTS locais;
DROP TABLE IF EXISTS motofasters;
DROP TYPE IF EXISTS turno;

CREATE TYPE zona_enum AS ENUM ('Norte', 'Sul', 'Leste', 'Oeste', 'Centro');
CREATE TYPE turno_enum AS ENUM ('Manhã', 'Tarde', 'Noite', 'Madrugada');

CREATE TABLE motofasters (
    id serial PRIMARY KEY,
    nome text NOT NULL,
    zona zona_enum NOT NULL,
    turno turno_enum NOT NULL
);

CREATE TABLE locais (
	local_id serial PRIMARY KEY,
	endereco text NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    zona zona_enum NOT NULL
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
    motofasters(nome, zona, turno)
VALUES
    ('Cícero Fontes Ruiz', 'Norte', 'Manhã'),
    ('Leonardo Correia Lópes', 'Norte', 'Manhã'),
    ('Alfredo Ximenes Vila', 'Sul', 'Manhã'),
    ('Vítor Meireles Dutra', 'Sul', 'Manhã'),
    ('Arthur Falcão Fontana', 'Leste', 'Manhã'),
    ('Isaías Luz Salgado', 'Leste', 'Manhã'),
    ('Fernando Vieira Sato', 'Oeste', 'Manhã'),
    ('Ivanildo Braga Meireles', 'Oeste', 'Manhã'),
    ('Maria Medeiros Dutra', 'Centro', 'Manhã'),
    ('Vanessa Justino Lourenço', 'Centro', 'Manhã'),
    ('César Barreto Flores', 'Centro', 'Manhã'),
    ('Rodrigo Amaral Araújo', 'Norte', 'Tarde'),
    ('Frederico Mendes Dutra', 'Norte', 'Tarde'),
    ('Vicente Jardim Machado', 'Norte', 'Tarde'),
    ('Antônio Azevedo Nakamura', 'Sul', 'Tarde'),
    ('Francine Souza Vasconcelos', 'Sul', 'Tarde'),
    ('Paloma Sato Branco', 'Leste', 'Tarde'),
    ('Murilo Neves Bastos', 'Oeste', 'Tarde'),
    ('Teodoro Castilho dos Santos', 'Oeste', 'Tarde'),
    ('Natália Rezende Vidal', 'Centro', 'Tarde'),
    ('Marcos Gonçalves Luz', 'Centro', 'Tarde'),
    ('Gilson Serrano Guerra', 'Centro', 'Tarde'),
    ('Aurélio Peres Álves', 'Norte', 'Noite'),
    ('Giovane Salles Velho', 'Norte', 'Noite'),
    ('Joaquim Rios Maldonado', 'Sul', 'Noite'),
    ('Eric Tavares Esteves', 'Sul', 'Noite'),
    ('Vinícius Falcão Leitão', 'Sul', 'Noite'),
    ('Benedito Branco Prado', 'Leste', 'Noite'),
    ('Osvaldo Duarte Ferraz', 'Leste', 'Noite'),
    ('Teresa Furtado Medeiros', 'Oeste', 'Noite'),
    ('Aline Cavalcanti Prado', 'Oeste', 'Noite'),
    ('Manoel Lima Silveira', 'Centro', 'Noite'),
    ('Vinicius Gimenes Aguiar', 'Centro', 'Noite'),
    ('Raul Pires Padilha', 'Norte', 'Madrugada'),
    ('Kléber Siqueira Macedo', 'Norte', 'Madrugada'),
    ('Luiz Pessoa Zanetti', 'Sul', 'Madrugada'),
    ('Vânia Peres Salgado', 'Sul', 'Madrugada'),
    ('Suzana Ferraz Yamada', 'Leste', 'Madrugada'),
    ('Antonieta Fonseca Pacheco', 'Leste', 'Madrugada'),
    ('Sílvio Araújo Rosa', 'Oeste', 'Madrugada'),
    ('Arthur Serrano Castilho', 'Oeste', 'Madrugada'),
    ('Nina Prestes Barbosa', 'Centro', 'Madrugada'),
    ('Diana Branco Carvalho', 'Centro', 'Madrugada'),
    ('Lucielle Maia Fagundes', 'Centro', 'Madrugada')
RETURNING *;

INSERT INTO
    locais(endereco, latitude, longitude, zona)
VALUES
    ('R. Bela Vista, 857 - Santo Amaro, São Paulo - SP, 04709-001', -23.631148, -46.696078, 'Sul'),
    ('Rua Padre Estevão Pernet, 420 - Vila Gomes Cardim, São Paulo - SP, 03315-000', -23.542878, -46.570886, 'Leste'),
    ('Rua Correia de Melo, 98 - Bom Retiro, São Paulo - SP, 01123-020', -23.530502, -46.637557, 'Norte'),
    ('Praça Dr. João Mendes, 24 - Centro Histórico de São Paulo, São Paulo - SP, 01501-000', -23.551375, -46.635399, 'Centro'),
    ('R. Heitor Penteado, 1833 - Sumarezinho, São Paulo - SP, 05437-002', -23.543597, -46.695407, 'Oeste')
RETURNING *;

INSERT INTO
    motos(placa, manutencao, alugada, aluguel_data_retirada, aluguel_data_entrega, aluguel_local_retirada, aluguel_local_entrega, reservada, reserva_data_retirada, reserva_data_entrega, reserva_local_retirada, reserva_local_entrega, local_id)
VALUES
    ('HZT-4589',false,true,'2021-09-10','2021-10-25',1,2,true,'2021-10-30','2021-11-20',2,4,NULL),
    ('IXA-2261',false,true,'2021-09-10','2021-10-30',2,5,false,NULL,NULL,NULL,NULL,NULL),
    ('HTA-1468',false,true,'2021-09-10','2021-11-10',2,2,false,NULL,NULL,NULL,NULL,NULL),
    ('NAS-4213',false,false,NULL,NULL,NULL,NULL,true,'2021-10-20','2021-11-20',1,2,1),
    ('NAL-4595',false,false,NULL,NULL,NULL,NULL,true,'2021-10-25','2021-10-30',2,2,2),
    ('LVK-9567',false,false,NULL,NULL,NULL,NULL,true,'2021-11-30','2021-12-10',3,1,3),
    ('JTL-1616',true,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,1),
    ('HRM-8945',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,2),
    ('NET-3865',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,2),
    ('LCZ-8224',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,5),
    ('JQE-0155',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,3),
    ('MRY-9564',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,3),
    ('HZW-9905',false,false,NULL,NULL,NULL,NULL,false,NULL,NULL,NULL,NULL,4)
RETURNING *;

-- Para executar esse arquivo no DB
-- heroku pg:psql < ./db/seed.sql
-- Query para checar motos disponíveis na data '2021-11-01'
-- select * from motos where (manutencao is false) and (alugada is false or aluguel_entrega<'2021-11-01') and (reservada is false or reserva_entrega<'2021-11-01');
-- select count(*) as motos_disponiveis,endereco from locais natural join motos where (manutencao is false) and (alugada is false or aluguel_entrega<'2021-11-01') and (reservada is false or reserva_entrega<'2021-11-01') group by endereco order by motos_disponiveis DESC;