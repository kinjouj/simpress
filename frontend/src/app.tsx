import React from 'react';
import { createRoot } from 'react-dom/client';
import { HashRouter, Routes, Route } from 'react-router-dom';
import PostList from './components/post_list';
import CategoryPostList from './components/category_post_list';
import Post from './components/post';

const container = document.getElementById('root');

if (container != null) {
  const root = createRoot(container);
  root.render(
    <React.StrictMode>
      <div><h1>Simpress Demo</h1></div>
      <HashRouter>
        <Routes>
          <Route path="/" element={<PostList />} />
          <Route path="/page/:page" element={<PostList />} />
          <Route path="/category/:category" element={<CategoryPostList />} />
          <Route path="/*" element={<Post />} />
        </Routes>
      </HashRouter>
    </React.StrictMode>,
  );
} else {
  alert('ERROR');
}
