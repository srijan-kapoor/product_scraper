import { useEffect } from "react";
import consumer from "../utils/cable";
import CryptoJS from "crypto-js";

export const useProductChannel = (productUrl, onProductUpdate, onError) => {
  useEffect(() => {
    console.log("useProductChannel", productUrl);

    const channelHash = CryptoJS.MD5(productUrl).toString();
    const channelName = `product_updates_${channelHash}`;

    const subscription = consumer.subscriptions.create(
      {
        channel: "ProductUpdatesChannel",
        product_url: productUrl
      },
      {
        connected: () => {
          console.log("Connected to channel:", channelName);
        },
        disconnected: () => {
          console.log("Disconnected from channel:", channelName);
        },
        received: data => {
          if (data.status === "complete") {
            onProductUpdate(data.product);
          } else if (data.status === "error") {
            onError(data.errors);
          }
        }
      }
    );

    return () => {
      subscription.unsubscribe();
    };
  }, [productUrl, onProductUpdate, onError]);
};
