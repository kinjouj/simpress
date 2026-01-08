import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

const container = createRoot(document.getElementById('root')!); // eslint-disable-line
container.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
