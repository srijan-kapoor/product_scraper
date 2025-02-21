import React from "react";
import { useLocation } from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";

const ProductDetail = () => {
  const location = useLocation();
  const { product } = location.state || {};

  if (!product) {
    return <div>Product not found</div>;
  }

  return (
    <div className="container mt-5">
      <h5>{product.title}</h5>
      <img
        src={product.image_url}
        alt={product.title}
        height="240"
        width="240"
      />
      <p>{product.description}</p>
      <p>Price: ${product.price}</p>
      <p>Category: {product.category.name}</p>
      <p>
        <a href={product.url} target="_blank" rel="noopener noreferrer">
          View Product
        </a>
      </p>
      <p>Seller Name: {product.seller_name}</p>
      <p>Size: {product.size}</p>
    </div>
  );
};

export default ProductDetail;
