import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import ProductItem from "./ProductItem";
import ScraperForm from "./ScraperForm";

const ProductList = () => {
  const [products, setProducts] = useState([]);

  const fetchProducts = async () => {
    const response = await axios.get("/api/products.json");
    setProducts(response.data);
  };

  useEffect(() => {
    fetchProducts();
  }, []);

  return (
    <div className="container">
      <ScraperForm setProducts={setProducts} />
      <ProductItem products={products} />
    </div>
  );
};

export default ProductList;
