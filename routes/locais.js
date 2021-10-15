const locaisRoutes = require('express')();
const pool = require('../db/connect');
var cors = require('cors')
locaisRoutes.use(cors())

localController = require('../controllers/localController')

locaisRoutes.get('/', localController.getAll)

locaisRoutes.get('/:id', async (req, res) => {
    const { id } = req.params
    const { rows } = await pool.query('SELECT * FROM locais WHERE local_id = $1', [id])
    res.send(rows[0])
})

locaisRoutes.get('/proximos/:cep/inicio/:inicio/fim/:fim', localController.getAvaiableWhen)

module.exports = locaisRoutes