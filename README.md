# 🏍️ motofast

A FORMA MAIS RÁPIDA DE IR EM BUSCA DOS SEUS SONHOS

## Documentação API motofast

Uma breve descrição das rotas utilizadas pela aplicação motofast

### Path: https://motofast-api.herokuapp.com/

### Rotas:

#### - GET

**/motos**: Recupera a lista de motos no banco de dados com os campos abaixo:

    "placa": "HZW-9905",

    "manutencao": false,

    "alugada": boolean,

    "aluguel_data_retirada": string,
    
    "aluguel_data_entrega": string,
    
    "aluguel_local_retirada": string,
    
    "aluguel_local_entrega": string,
    
    "reservada": boolean,
    
    "reserva_data_retirada": string,
    
    "reserva_data_entrega": string,
    
    "reserva_local_retirada": string,
    
    "reserva_local_entrega": string,
    
    "endereco": string
    
**/motos/:id**: Recupera a moto com id = :id e os mesmos campos acima

**/locais/**: Recupera a lista de locais no banco de dados com os campos abaixo:

    "local_id": integer,
    
    "endereco": string,
    
    "latitude": string,
    
    "longitude": string,
    
    "zona": string
    
**/locais/:id**: Recupera o local com local_id = :id e os mesmos campos acima

**/locais/proximos/:cep/inicio/:inicio/fim/:fim**: Busca o ponto de aluguel (local) mais próximo de :cep, tal que existam motos disponíveis no período inquerido

**/motofasters**: Recupera a lista de motofasters no banco de dados com os campos abaixo:

    "id": integer,
    
    "nome": string,
    
    "zona": Enum('Norte', 'Sul', 'Leste', 'Oeste', 'Centro'),
    
    "turno": Enum('Manhã', 'Tarde', 'Noite', 'Madrugada')

**/motofasters/:id**: Recupera o motofaster com local_id = :id e os mesmos campos acima

**/motofasters/zona/:zona/turno/:turno**: Lista todos os motofasters com zona = :zona e turno = :turno

## Tecnologias Utilizadas [Backend]

* Node.js
* Express
* Pg
* PostgreSQL
* Heroku


## Equipe

### Desenvolvimento Web

* [Erick Santos](https://github.com/erickscoelhor)
* [Lucas Cordeiro](https://github.com/cordeirolucas42)

### UI/UX Design

* Geovanna Luvian
* Vinícius Lopes

### Growth Marketing

* Grabrielle Côrtes
* Raquel Hauauini

### Inside Sales

* Rosemberg Freitas
* Wayne Mendes
