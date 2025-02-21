import React, { useState } from "react";
import "./App.css";
import ProductList from "./ProductList";
import Search from "./Search";
import ProductItem from "./ProductItem";

const App = () => {
  const [searchResults, setSearchResults] = useState([]);

  return (
    <div className="App">
      <h1>Product Scraper</h1>
      <Search setSearchResults={setSearchResults} />
      {searchResults.length === 0 ? (
        <ProductList />
      ) : (
        <ProductItem products={searchResults} />
      )}
    </div>
  );
};

export default App;
