import React, { useState, useEffect } from "react";
import axios from "axios";

function App() {
  const [items, setItems] = useState([]);
  const [name, setName] = useState("");

  useEffect(() => {
    axios.get("/api/list")
      .then(res => setItems(res.data))
      .catch(err => console.error(err));
  }, []);

  const addItem = () => {
    axios.post("/api/create", { name })
      .then(() => window.location.reload())
      .catch(err => console.error(err));
  };

  return (
    <div style={{ padding: "40px", fontFamily: "Arial" }}>
      <h1>3-Tier App (AWS EKS Multi-Region)</h1>

      <input
        type="text"
        placeholder="Enter Item"
        onChange={e => setName(e.target.value)}
      />
      <button onClick={addItem}>Add</button>

      <ul>
        {items.map(i => (
          <li key={i.id}>{i.name}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;