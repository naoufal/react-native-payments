import React from 'react';
import { render } from 'react-dom';
import App from '../common/App';

if (window.PaymentRequest) {
  render(<App />, document.getElementById('app'));
  // Don't render the app on Browsers that don't support PaymentRequest
} else {
  document.write(
    `Your browser doesn't <a href="https://caniuse.com/#search=PaymentRequest">support the PaymentRequest API</a>.`
  );
}
