const motofastersRoutes = require('express')();
const pool = require('../db/connect');
var cors = require('cors')
motofastersRoutes.use(cors())

motofastersRoutes.get('/', async (req, res) => {
    const { rows } = await pool.query('SELECT * FROM motofasters')
    res.send(rows)
})

motofastersRoutes.get('/zona/:zona/turno/:turno', async (req, res) => {
    const { zona, turno } = req.params
    const query = `SELECT * FROM motofasters WHERE zona=$1 and turno=$2`
    const { rows } = await pool.query(query, [zona, turno])
    res.send(rows)
})


motofastersRoutes.get('/:id', async (req, res) => {
    const { id } = req.params
    const { rows } = await pool.query('SELECT * FROM motofasters WHERE id = $1', [id])
    res.send(rows[0])
})

module.exports = motofastersRoutes