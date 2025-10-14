import { HashRouter, Routes, Route } from 'react-router-dom';
import Header from './components/Header';
import PageToTopFloatingButton from './components/PageToTopFloatingButton';
import PostList from './pages/PostListPage';
import ArchivesPostList from './pages/ArchivesPostListPage';
import CategoryPostList from './pages/CategoryPostListPage';
import Post from './pages/PostPage';

const App = (): React.JSX.Element => {
  return (
    <>
      <Header />
      <HashRouter>
        <Routes>
          <Route path="/" element={<PostList />} />
          <Route path="/page/:page" element={<PostList />} />
          <Route path="/archives/:year/:month" element={<ArchivesPostList />} />
          <Route path="/archives/category/:category" element={<CategoryPostList />} />
          <Route path="/*" element={<Post />} />
        </Routes>
      </HashRouter>
      <PageToTopFloatingButton />
    </>
  );
};

export default App;
