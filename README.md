# Product Scraper

![Screenshot 2025-02-22 at 17 31 39](https://github.com/user-attachments/assets/ec6b6b9e-bed4-4c3d-9495-c9532167d934)

![Screenshot 2025-02-22 at 17 33 00](https://github.com/user-attachments/assets/bfd68fa3-3b9b-44c0-90e0-9d0e68b195f2)

## Design

- **Architecture**: The application is built using a client-server model with a Ruby on Rails backend and a React frontend.
- **Database**: It uses PostgreSQL for its robustness and scalability.
- **Scraping Library**: Waitr, an open-source library for scraping product data and mimicing user behavior in browser.

## Assumptions

- The product data source is stable and does not frequently change its structure.
- Users have a basic understanding of Ruby on Rails and React for setup and troubleshooting.

## Limitations

- The scraper is not optimized for scrapping ecommerce websites other than Flipkart and for handling rate limiting.

## Project Dependencies
- **Ruby**: 3.0.1
- **Ruby on Rails**: 7.1.1
- **React**: 18.2.0
- **PostgreSQL**:  14.x
- **Redis**: 4.0.1

## Getting Started

- Clone the repo `https://github.com/srijan-kapoor/product_scraper.git`
- Move into directory `cd product_scraper`

### Running the Rails Server
- In one terminal, run `bundle` to install the dependencies.
- Run `bin/rake db:setup` to create the databases (called product_scraper_development by default).
- Run `bin/rails db:migrate` to migrate the database.
- Run `bin/rails s -p 3001` to run the rails server.

### Running the React Client
- In the other terminal, `cd` into `product_scraper/client`.
- Run `yarn install`.
- Run `yarn start` and go to `localhost:3000` in your browser.

### Sidekiq
- Run `bin/rails sidekiq` to run the sidekiq server in a separate terminal.

### Redis
- Run `redis-server` to run the redis server in a separate terminal.

### Running test suite
- Run `bundle exec rspec` to run the test suite.

## Incomplete Aspects and Future Work

- **Error Handling**: Improve error handling for network failures and unexpected data formats.
- **Scalability**: Optimize the scraper for handling larger datasets and other ecommerce websites.
- **User Interface**: Enhance the UI for better user experience and accessibility.

