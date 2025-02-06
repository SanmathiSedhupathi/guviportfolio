import React from "react";
import "./styles.css";

const App = () => {
  return (
    <div className="container">
      <header>
        <h1>Sanmathi's Portfolio</h1>
        <p>Web Developer | Backend Specialist</p>
      </header>
      <section>
        <h2>About Me</h2>
        <p>I'm a passionate web developer with expertise in React, Node.js, and Docker.</p>
      </section>
      <section>
        <h2>Projects</h2>
        <ul>
          <li>📌 Inventory Management System</li>
          <li>📌 AI-Powered Agriculture Diagnosis</li>
          <li>📌 E-Gram Panchayat Portal</li>
        </ul>
      </section>
      <footer>
        <p>Contact: sanmathi@example.com</p>
      </footer>
    </div>
  );
};

export default App;
