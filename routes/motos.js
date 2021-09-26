const motosRoutes = require('express')();
const pool = require('../db/connect');
var cors = require('cors')
motosRoutes.use(cors())

motoController = require('../controllers/motoController')

motosRoutes.get('/', motoController.getAllWithLocal)

motosRoutes.get('/when/:date', motoController.getAllWhen)

motosRoutes.get('/:id', async (req, res) => {
const { id } = req.params
console.log(`get /motos/:${id}`)
const { rows } = await pool.query('SELECT * FROM motos WHERE id = $1', [id])
res.send(rows[0])
})
  
// Não tá funcionando ainda
// motosRoutes.post('/motos', async (req, res) => {
//   console.log("post /motos")
//   const query = 'INSERT INTO motos(marca,modelo,preco,ano,cor,cambio) VALUES($1, $2, $3, $4, $5, $6)'
//   console.log((req))
//   const fields = Object.values(req.body.moto)
//   await pool.query(query, fields)
//   res.redirect("/motos")
// })

module.exports = motosRoutes