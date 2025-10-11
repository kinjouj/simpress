import { HashRouter, Routes, Route } from 'react-router-dom';
import Header from './components/Header';
import PostList from './components/PostList';
import CategoryPostList from './components/CategoryPostList';
import Post from './components/Post';

const App = (): React.JSX.Element => {
  return (
    <>
      <Header />
      <HashRouter>
        <Routes>
          <Route path="/" element={<PostList />} />
          <Route path="/page/:page" element={<PostList />} />
          <Route path="/category/:category" element={<CategoryPostList />} />
          <Route path="/*" element={<Post />} />
        </Routes>
      </HashRouter>
    </>
  );
};

export default App;
