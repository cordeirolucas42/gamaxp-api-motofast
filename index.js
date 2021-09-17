require('dotenv').config()
const bodyParser = require('body-parser')
const { Pool } = require('pg');
const express = require('express')
const app = express()
app.use(bodyParser.urlencoded({ extended: true }))

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false
    }
});

app.get('/', async (req, res) => {
  res.send("API MotoFast")  
})

// Distribuir para a pasta routes
app.get('/motos', async (req, res) => {
  console.log("get /motos")
  const result = await pool.query('select * from motos')
  console.log(JSON.stringify(result.rows))
  res.send(result.rows)  
})

app.get('/motos/:id', async (req, res) => {
  const { id } = req.params
  console.log(`get /motos/:${id}`)
  const { rows } = await pool.query('SELECT * FROM motos WHERE id = $1', [id])
  console.log(JSON.stringify(rows))
  res.send(rows[0])
})

// Não tá funcionando ainda
// app.post('/motos', async (req, res) => {
//   console.log("post /motos")
//   const query = 'INSERT INTO motos(marca,modelo,preco,ano,cor,cambio) VALUES($1, $2, $3, $4, $5, $6)'
//   console.log((req))
//   const fields = Object.values(req.body.moto)
//   await pool.query(query, fields)
//   res.redirect("/motos")
// })

app.listen(process.env.PORT || 5000, () => {
  console.log(`Example app listening at http://localhost:${process.env.PORT || 5000}`)
})