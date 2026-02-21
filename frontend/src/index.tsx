import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
import 'bootstrap/dist/css/bootstrap.min.css';
import '../../scss/style.scss';

const container = createRoot(document.getElementById('root')!); // eslint-disable-line
container.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
