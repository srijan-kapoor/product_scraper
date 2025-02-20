import React, { useState } from "react";
import axios from "axios";

const ScraperForm = () => {
  const [url, setUrl] = useState("");
  const [product, setProduct] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async e => {
    e.preventDefault();
    setLoading(true);
    try {
      const response = await axios.post("/api/products", { product_url: url });
      console.log(response.data);
      setProduct(response.data);
    } catch (error) {
      console.error("Error fetching product:", error);
    }
    setLoading(false);
  };

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={url}
          onChange={e => setUrl(e.target.value)}
          placeholder="Enter product URL"
        />
        <button type="submit" disabled={loading}>
          {loading ? "Loading..." : "Scrape"}
        </button>
      </form>
      {loading && <p>Loading...</p>}
      {product && !loading && (
        <div>
          <h2>{product.title}</h2>
          <p>{product.description}</p>
          <p>{product.price}</p>
        </div>
      )}
    </div>
  );
};

export default ScraperForm;
