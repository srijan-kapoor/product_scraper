import React, { useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";

const ScraperForm = ({ setProducts }) => {
  const [url, setUrl] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(false);

  const handleSubmit = async e => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setSuccess(false);
    try {
      const response = await axios.post(
        "/api/products",
        {
          product_url: url
        },
        {
          headers: {
            Accept: "application/json",
            "Content-Type": "application/json"
          }
        }
      );
      setProducts(prevProducts => [...prevProducts, response.data.product]);
      setUrl("");
      setSuccess(true);
    } catch (error) {
      setError(error.response?.data?.error || "Error fetching product");
      console.error("Error fetching product:", error);
    }
    setLoading(false);
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
          {success && (
            <div className="alert alert-success mt-3" role="alert">
              Product successfully added!
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
