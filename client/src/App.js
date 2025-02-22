import React, { useState } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import "./App.css";
import ProductList from "./ProductList";
import Search from "./Search";
import ProductItem from "./ProductItem";
import ProductDetail from "./ProductDetail";

const App = () => {
  const [searchResults, setSearchResults] = useState([]);

  return (
    <Router>
      <div className="App">
        <Routes>
          <Route
            path="/"
            element={
              <>
                <h1>Product Scraper</h1>
                <Search setSearchResults={setSearchResults} />
              </>
            }
          />
        </Routes>

        <Routes>
          <Route
            path="/"
            element={
              searchResults.length === 0 ? (
                <ProductList />
              ) : (
                <ProductItem products={searchResults} />
              )
            }
          />
          <Route path="/product/:id" element={<ProductDetail />} />
        </Routes>
      </div>
    </Router>
  );
};

export default App;
