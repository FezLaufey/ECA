const express = require('express');
const app = express();
const dotenv = require('dotenv').config();
const cookieParser = require('cookie-parser');
const formidable = require('formidable');
const pool = require("./pg_con.js");
const md5 = require("md5");
const session = require('express-session');
const PgSession = require('connect-pg-simple')(session);
const cors = require('cors'); // Import the cors module
const crypto = require('crypto');


//emailreset
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
    service: 'Gmail', // or another email service
    auth: {
        user: 'sw01081021@gmail.com',
        pass: 'rwcr rcbc cbgl gsbs'
    }
});

function sendResetEmail(to, token) {
    const resetLink = `http://localhost:10000/reset-password?token=${token}`;
    const mailOptions = {
        from: 'SW01081021@gmail.com',
        to: to,
        subject: 'Password Reset',
        text: `You requested a password reset. Click the link to reset your password: ${resetLink}`,
        html: `<p>You requested a password reset. Click the link to reset your password:</p><a href="${resetLink}">Reset Password</a>`
    };

    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
            console.error('Error sending email:', error);
        } else {
            console.log('Email sent:', info.response);
        }
    });
}


// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());


var bodyParser = require("body-parser");
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(cors());

app.use(session({
  secret: 'secret', // Change this to a secure key
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false } // Set to true in production with HTTPS
}));

const path = require('path');

const testDbConnection = async () => {
  try {
    const client = await pool.connect();
    console.log('Database connection successful');
    client.release();
  } catch (error) {
    console.error('Database connection failed', error);
    process.exit(1);
  }
};

testDbConnection();

app.get('/all-users', async (req, res) => {
  try {
    const query = 'SELECT * FROM users';
    const result = await pool.query(query);
    return res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error retrieving data:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({ error: 'Username and password are required' });
    }

    const query = 'SELECT * FROM users WHERE username = $1';
    const result = await pool.query(query, [username]);

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Invalid username or password' });
    }

    const user = result.rows[0];

    if (password === user.password) {
      req.session.userId = user.uid;
      return res.status(200).json({ message: 'Login successful' });
    } else {
      return res.status(401).json({ error: 'Invalid username or password' });
    }
  } catch (error) {
    console.error('Error during login:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/sign', async (req, res) => {
  try {
    const { username, password, email } = req.body;

    if (!username || !password)  {
      return res.status(400).json({ error: 'Username and password are required' });
    }

    if (!email)  {
      return res.status(400).json({ error: 'Email is required' });
    }

    const query = 'SELECT * FROM users WHERE username = $1';
    const result = await pool.query(query, [username]);

    if (result.rows.length > 0) {
      return res.status(401).json({ error: 'Username already exists' });
    }

    const query2 = 'SELECT * FROM users WHERE email = $1';
    const result2= await pool.query(query2,[email]);

    if (result2.rows.length > 0) {
      return res.status(401).json({ error: 'Email is already in use' });
    }

    const insertQuery = 'INSERT INTO users (username, password, email) VALUES ($1, $2, $3) RETURNING *';
    const insertQueryResult = await pool.query(insertQuery, [username, password, email]);
    return res.status(201).json({ message: 'User registered successfully', user: insertQueryResult.rows[0] });
  } catch (error) {
    console.error('Error during registration:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/forgot-password', async (req, res) => {
  const { email } = req.body;
  try {
      const result = await pool.query('SELECT * FROM Users WHERE email = $1', [email]);
      if (result.rows.length > 0) {
          const token = crypto.randomBytes(20).toString('hex');
          const expiration = Date.now() + 3600000; // 1 hour
          await pool.query('UPDATE Users SET reset_token = $1, reset_token_expiration = $2 WHERE email = $3', 
              [token, new Date(expiration), email]);
          
          sendResetEmail(email, token);
          res.status(200).send('Password reset email sent');
      } else {
          res.status(404).send('User not found');
      }
  } catch (err) {
      console.error(err);
      res.status(500).send('Error processing password reset request');
  }
});

app.get('/reset-password', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'resetpassword.html'));
});


// Route to reset password
app.post('/reset-password', async (req, res) => {
  const { token, newPassword } = req.body;
  try {
      const result = await pool.query('SELECT * FROM Users WHERE reset_token = $1 AND reset_token_expiration > $2', 
          [token, new Date()]);
      if (result.rows.length > 0) {
          await pool.query('UPDATE Users SET password = $1, reset_token = NULL, reset_token_expiration = NULL WHERE reset_token = $2', 
              [newPassword, token]);
          res.status(200).send('Password reset successful, You may now log in like usual');
      } else {
          res.status(400).send('Invalid or expired token');
      }
  } catch (err) {
      console.error(err);
      res.status(500).send('Error resetting password');
  }
});



app.post('/logout', (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).json({ error: 'Could not log out, please try again' });
    }
    res.clearCookie('connect.sid');
    return res.status(200).json({ message: 'Logout successful' });
  });
});

function isAuthenticated(req, res, next) {
  if (req.session.userId) {
    return next();
  } else {
    return res.status(401).json({ error: 'You must be logged in to access this page' });
  }
}

app.get('/data', async (req, res) => {
  try {
      const result = await pool.query('SELECT id,power,timestamp FROM readings ORDER BY timestamp DESC LIMIT 1');
      res.json(result.rows);
  } catch (err) {
      console.error(err);
      res.status(500).send('Error fetching data');
  }
});

app.get('/data2', async (req, res) => {
  try {
      const result = await pool.query('SELECT power FROM readings ORDER BY timestamp DESC LIMIT 1');
      let power = result.rows[0].power;
      power = parseFloat(power).toFixed(2);
      res.json({ power });
  } catch (err) {
      console.error(err);
      res.status(500).send('Error fetching data');
  }
});


app.get('/dataavg', async (req, res) => {
  try {
      const result = await pool.query('SELECT AVG(power) AS avg_power FROM readings');
      let avgPower = result.rows[0].avg_power;
      avgPower = parseFloat(avgPower).toFixed(2);
      res.json({ avgPower });
  } catch (err) {
      console.error(err);
      res.status(500).send('Error fetching data');
  }
});

app.get('/edataavg', async (req, res) => {
  try {
      const result = await pool.query('SELECT AVG(power) AS avg_power FROM readings');
      let avgPower = result.rows[0].avg_power;
      avgPower = parseFloat(avgPower/1000 * 24 * 21.8/100).toFixed(2);
      res.json({ avgPower });
  } catch (err) {
      console.error(err);
      res.status(500).send('Error fetching data');
  }
});




app.post('/saveDevice',isAuthenticated, async (req, res) => {
  console.log('Received body value:', req.body); 
  const { dname, avgPower, estimatedCost } = req.body;

  const userId = req.session.userId;
  console.log('UserID: ',userId);


  try {
      const result = await pool.query(
          'INSERT INTO devices (dname, avg_power, estimated_cost, user_id) VALUES ($1, $2, $3, $4)',
          [dname, avgPower, estimatedCost, userId]
      );
      res.status(201).send('Device data saved successfully');
  } catch (err) {
      console.error(err);
      res.status(500).send('Error saving device data');
  }
});




app.post('/data3', async (req, res) => {
  console.log('Received body value:', req.body); 
  const { voltage, current, power } = req.body;
  try {
    const query = 'INSERT INTO readings(voltage, current, power) VALUES($1, $2, $3)';
    const values = [voltage, current, power];
    await pool.query(query, values);
    res.status(200).send('Data saved to database');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error saving data to database');
  }
});

app.delete('/newdevice', async (req, res) => {
  try {
      await pool.query('DELETE FROM readings');
      res.status(200).send('All records deleted successfully');
  } catch (err) {
      console.error(err);
      res.status(500).send('Error deleting records');
  }
});


// Route to get devices for the current user
app.get('/devices', isAuthenticated, async (req, res) => {
  const userId = req.session.userId;
  try {
      const result = await pool.query('SELECT id, dname FROM Devices WHERE user_id = $1', [userId]);
      res.json(result.rows);
  } catch (err) {
      console.error(err);
      res.status(500).send('Error fetching devices from the database');
  }
});

// Route to get device data by id
app.get('/device/:id', isAuthenticated, async (req, res) => {
  const deviceId = req.params.id;
  const userId = req.session.userId;
  try {
      const result = await pool.query('SELECT dname, avg_power, estimated_cost FROM Devices WHERE id = $1 AND user_id = $2', [deviceId, userId]);
      if (result.rows.length > 0) {
          res.json(result.rows[0]);
      } else {
          res.status(404).send('Device not found');
      }
  } catch (err) {
      console.error(err);
      res.status(500).send('Error fetching device data');
  }
});

// Route to delete a device by id
app.delete('/device/:id', isAuthenticated, async (req, res) => {
  const deviceId = req.params.id;
  const userId = req.session.userId;
  try {
      const result = await pool.query('DELETE FROM Devices WHERE id = $1 AND user_id = $2', [deviceId, userId]);
      if (result.rowCount > 0) {
          res.status(200).send('Device deleted successfully');
      } else {
          res.status(404).send('Device not found');
      }
  } catch (err) {
      console.error(err);
      res.status(500).send('Error deleting device');
  }
});

// Route to get devices for chart for the current user
app.get('/chart', isAuthenticated, async (req, res) => {
  const userId = req.session.userId;
  try {
      const result = await pool.query('SELECT dname, estimated_cost FROM Devices WHERE user_id = $1', [userId]);
      res.json(result.rows);
  } catch (err) {
      console.error(err);
      res.status(500).send('Error fetching chart data from the database');
  }
});




app.get('/dashboard', isAuthenticated, (req, res) => {
  res.send('Welcome to your dashboard');
});

app.get('/analysis', isAuthenticated, (req, res) => {
  res.send('Welcome to analysis tab');
});


app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
  res.send('Welcome to the Login System');
});

app.listen(10000, () => {
  console.log("Server started SEES");
});
