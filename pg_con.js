const Pool = require('pg').Pool
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'login',
  password: '1234',
  port: 5433,
})


module.exports = pool;