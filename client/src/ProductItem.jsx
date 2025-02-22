import React from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import { Link } from "react-router-dom";
import axios from "axios";

const ProductItem = ({ products, setProducts }) => {
  const productsByCategory = {};
  products.forEach(product => {
    const categoryName = product.category.name;
    if (!productsByCategory[categoryName]) {
      productsByCategory[categoryName] = [];
    }
    productsByCategory[categoryName].push(product);
  });

  const categories = [...new Set(products.map(p => p.category.name))].sort();

  const handleRefetch = async productId => {
    try {
      await axios.put(`/api/products/${productId}.json`);
      alert("Refetch request submitted successfully");
      setProducts(prevProducts =>
        prevProducts.map(p => (p.id === productId ? { ...p } : p))
      );
    } catch (error) {
      console.error("Error submitting refetch request:", error);
    }
  };

  return (
    <div className="container">
      {categories.map(category => (
        <div key={category} className="mb-5">
          <h3 className="mb-3 text-start">
            {category} ({productsByCategory[category].length})
          </h3>
          <div className="row">
            {productsByCategory[category].map(product => (
              <div key={product.id} className="col-md-4 mb-4">
                <div className="card" style={{ minHeight: "400px" }}>
                  <div className="text-center p-3" style={{ height: "240px" }}>
                    <img
                      src={product.image_url}
                      height="240"
                      width="240"
                      alt={product.title}
                      style={{ objectFit: "contain" }}
                    />
                  </div>
                  <div className="card-body">
                    <h5 className="card-title">
                      <Link
                        to={`/product/${product.id}`}
                        state={{ product: product }}
                      >
                        {product.title}
                      </Link>
                    </h5>
                    <p className="card-text">{product.price}</p>
                  </div>
                  <div className="card-footer">
                    <div className="d-flex justify-content-between align-items-center">
                      <small className="text-muted">
                        {product.category.name}
                      </small>
                      <button
                        className="btn btn-sm btn-outline-secondary"
                        onClick={() => handleRefetch(product.id)}
                      >
                        Refetch
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
};

export default ProductItem;
