import React, { useState, useCallback } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { useProductChannel } from "./hooks/useProductChannel";

const ScraperForm = ({ setProducts }) => {
  const [url, setUrl] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [successMessage, setSuccessMessage] = useState("");

  const handleProductUpdate = useCallback(
    data => {
      setProducts(prevProducts => {
        const existingProducts = prevProducts.filter(
          p => p.product_id !== data.product_id
        );
        return [...existingProducts, data];
      });
      setLoading(false);
      setSuccessMessage("Product added!");
    },
    [setProducts]
  );

  const handleError = useCallback(errors => {
    setError(Array.isArray(errors) ? errors.join(", ") : errors);
    setLoading(false);
  }, []);

  useProductChannel(url, handleProductUpdate, handleError);

  const handleSubmit = async e => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setSuccessMessage("");

    try {
      const response = await axios.post(
        "/api/products",
        { product_url: url },
        {
          headers: {
            Accept: "application/json",
            "Content-Type": "application/json"
          }
        }
      );

      if (response.status === 200) {
        // Product already exists
        setProducts(prevProducts => {
          const existingProducts = prevProducts.filter(
            p => p.product_id !== response.data.product.product_id
          );
          return [...existingProducts, response.data.product];
        });
        setSuccessMessage("Product already exists!");
        setLoading(false);
      }
      // For status 202, we'll wait for WebSocket update
      // setUrl("");
    } catch (error) {
      setError(error.response?.data?.error || "Error fetching product");
      setLoading(false);
      console.error("Error fetching product:", error);
    }
  };

  return (
    <div className="container py-4">
      <div className="row mb-4">
        <div className="col-md-6">
          <h5 className="mb-2 text-start">Scrape</h5>
          <form onSubmit={handleSubmit} className="d-flex gap-2">
            <input
              type="text"
              className="form-control"
              value={url}
              onChange={e => setUrl(e.target.value)}
              placeholder="Enter product URL (Flipkart only)"
              disabled={loading}
            />
            <button
              type="submit"
              className="btn btn-primary"
              disabled={loading || !url}
            >
              Submit
            </button>
          </form>
          {error && (
            <div className="alert alert-danger mt-3" role="alert">
              {error}
            </div>
          )}
          {successMessage && (
            <div className="alert alert-success mt-3" role="alert">
              {successMessage}
            </div>
          )}
        </div>
      </div>

      {loading && (
        <div className="text-center">
          <div className="alert alert-info" role="alert">
            Scraping in progress. Please wait..
          </div>
        </div>
      )}
    </div>
  );
};

export default ScraperForm;
