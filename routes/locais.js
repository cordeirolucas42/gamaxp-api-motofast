const locaisRoutes = require('express')();
const pool = require('../db/connect');
const bodyParser = require('body-parser')
var cors = require('cors')
locaisRoutes.use(bodyParser.urlencoded({ extended: true }))
locaisRoutes.use(cors())

locaisRoutes.get('/', async (req, res) => {
    console.log("get /locais")
    const result = await pool.query('select * from locais')
    res.send(result.rows)
})

locaisRoutes.get('/:id', async (req, res) => {
const { id } = req.params
console.log(`get /locais/:${id}`)
const { rows } = await pool.query('SELECT * FROM locais WHERE local_id = $1', [id])
res.send(rows[0])
})

module.exports = locaisRoutes