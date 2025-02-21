import React from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import { Link } from "react-router-dom";

const ProductItem = ({ products }) => {
  const productsByCategory = {};
  products.forEach(product => {
    const categoryName = product.category.name;
    if (!productsByCategory[categoryName]) {
      productsByCategory[categoryName] = [];
    }
    productsByCategory[categoryName].push(product);
  });

  const categories = [...new Set(products.map(p => p.category.name))].sort();

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
                    <small className="text-muted">
                      {product.category.name}
                    </small>
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
