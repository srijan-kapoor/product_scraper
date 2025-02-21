import React, { useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";

const ScraperForm = ({ onProductAdd }) => {
  const [url, setUrl] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleSubmit = async e => {
    e.preventDefault();
    setLoading(true);
    setError(null);
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
      onProductAdd();
      setUrl("");
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
          <form onSubmit={handleSubmit} className="d-flex gap-2">
            <input
              type="text"
              className="form-control"
              value={url}
              onChange={e => setUrl(e.target.value)}
              placeholder="Enter product URL"
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
        </div>
      </div>

      {loading && (
        <div className="text-center">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Loading...</span>
          </div>
        </div>
      )}
    </div>
  );
};

export default ScraperForm;
