const express = require("express");
const cors = require("cors");
const mysql = require("mysql2");

const app = express();
app.use(cors());
app.use(express.json());

// Aurora Global DB connection
const db = mysql.createConnection({
  host: process.env.DB_HOST,       // from Helm chart
  user: "dbadmin",                 // your Aurora username
  password: process.env.DB_PASSWORD,
  database: "three_tier_db"
});

// CRUD: list
app.get("/api/list", (req, res) => {
  db.query("SELECT * FROM items", (err, rows) => {
    if (err) return res.status(500).json(err);
    res.json(rows);
  });
});

// CRUD: create
app.post("/api/create", (req, res) => {
  const name = req.body.name;
  db.query("INSERT INTO items(name) VALUES(?)", [name], (err) => {
    if (err) return res.status(500).json(err);
    res.json({ status: "success" });
  });
});

app.listen(8080, () => console.log("Backend running on port 8080"));