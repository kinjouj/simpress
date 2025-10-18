import { HashRouter, Routes, Route, Navigate } from 'react-router-dom';
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
          <Route path="/" element={<Navigate to="/page/1" replace />} />
          <Route path="/page/:page" element={<PostList />} />
          <Route path="/archives/category/:category" element={<CategoryPostList />} />
          <Route path="/archives/:year/:month" element={<ArchivesPostList />} />
          <Route path="/*" element={<Post />} />
        </Routes>
      </HashRouter>
      <PageToTopFloatingButton />
    </>
  );
};

export default App;
