const motosRoutes = require('express')();
const pool = require('../db/connect');
var cors = require('cors')
motosRoutes.use(cors())

motoController = require('../controllers/motoController')

motosRoutes.get('/', motoController.getAllWithLocal)

motosRoutes.get('/when/:date', motoController.getAllWhen)

motosRoutes.get('/:id', async (req, res) => {
    const { id } = req.params
    const { rows } = await pool.query('SELECT * FROM motos WHERE id = $1', [id])
    res.send(rows[0])
})

module.exports = motosRoutes