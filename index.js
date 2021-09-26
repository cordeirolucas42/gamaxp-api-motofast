require('dotenv').config()
const buscaCep = require('busca-cep');
var cors = require('cors')
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
  let endereco = await buscaCep(cep)
  res.send(endereco)
})

app.listen(process.env.PORT || 5000, () => {
  console.log(`Example app listening at http://localhost:${process.env.PORT || 5000}`)
})