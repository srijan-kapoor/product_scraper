import React, { Component } from "react";
import "./App.css";
import ScraperForm from "./ScraperForm";
class App extends Component {
  render() {
    return (
      <div className="App">
        <h1>Product Scraper</h1>
        <ScraperForm />
      </div>
    );
  }
}

export default App;
