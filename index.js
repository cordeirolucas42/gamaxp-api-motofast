require('dotenv').config()
const cors = require('cors')
const got = require('got');
const express = require('express')
const app = express()
app.use(cors())

const motosRoutes = require('./routes/motos')
const locaisRoutes = require('./routes/locais')

app.get('/', (req, res) => {
  res.send("API MotoFast")
})

app.use('/motos', motosRoutes)
app.use('/locais', locaisRoutes)

app.get('/cep/:cep', async (req, res) => {
  const { cep } = req.params
  const endereco = await got(`https://brasilapi.com.br/api/cep/v2/${cep}`)
  res.send(endereco.body)
})

app.listen(process.env.PORT || 5000, () => {
  console.log(`Example app listening at http://localhost:${process.env.PORT || 5000}`)
})