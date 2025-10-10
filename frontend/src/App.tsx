import React from 'react';
import { HashRouter, Routes, Route } from 'react-router-dom';
import PostList from './components/PostList';
import CategoryPostList from './components/CategoryPostList';
import Post from './components/Post';

const App = (): React.JSX.Element => {
  return (
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
    </React.StrictMode>
  );
};

export default App;
