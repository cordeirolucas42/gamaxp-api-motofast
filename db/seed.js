require('dotenv').config()
const { Client } = require('pg');
const client = new Client({
  connectionString: process.env.DATABASE_URL,
//   ssl: {
//     rejectUnauthorized: false
//   }
});

client
  .query('select * from motos')
  .then(res => console.log(res))
  .catch(e => console.error(e.stack))
