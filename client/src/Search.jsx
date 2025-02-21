import React, { useState, useEffect } from "react";
import axios from "axios";

const Search = ({ setSearchResults }) => {
  const [query, setQuery] = useState("");

  useEffect(() => {
    const delayDebounce = setTimeout(async () => {
      if (query) {
        const response = await axios.get(`/api/products.json?query=${query}`);
        setSearchResults(response.data);
      } else {
        setSearchResults([]);
      }
    }, 500);

    return () => clearTimeout(delayDebounce);
  }, [query, setSearchResults]);

  return (
    <div className="container py-4">
      <div className="row mb-4">
        <div className="col-md-6">
          <h3 className="mb-3 text-start px-2">Search in listed products</h3>
          <div className="d-flex px-2">
            <input
              type="text"
              className="form-control"
              value={query}
              onChange={e => setQuery(e.target.value)}
              placeholder="Enter product title"
            />
          </div>
        </div>
      </div>
    </div>
  );
};

export default Search;
