# Product Scraper

This repo fulfills the requirement described here<br/>
https://docs.google.com/document/d/1dMbd50Vb8VT0gluSTUg1pVq7M1Pfi-kszS2N78HJJgc/edit?tab=t.0#heading=h.zfh9vbe22ws6


## Design Choices

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

## Getting Started

- Clone the repo `https://github.com/srijan-kapoor/product_scraper.git`
- Move into directory `cd product_scraper`

### Running the Rails Server
- In one terminal, run `bundle` to install the dependencies.
- Run `bin/rake db:setup` to create the databases (called product_scraper_development by default).
- Run `bin/rails s -p 3001` to run the rails server.

### Running the React Client
- In the other terminal, `cd` into `product_scraper/client`.
- Run `yarn install`.
- Run `yarn start` and go to `localhost:3000` in your browser.

### Sidekiq
- Run `bin/rails sidekiq` to run the sidekiq server in a separate terminal.

## Incomplete Aspects and Future Work

- **Error Handling**: Improve error handling for network failures and unexpected data formats.
- **Scalability**: Optimize the scraper for handling larger datasets and other ecommerce websites.
- **User Interface**: Enhance the UI for better user experience and accessibility.

