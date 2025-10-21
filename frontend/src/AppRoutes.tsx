import { Navigate, Route, Routes } from 'react-router-dom';
import PostListPage from './pages/PostListPage';
import CategoryPostListPage from './pages/CategoryPostListPage';
import ArchivesPostListPage from './pages/ArchivesPostListPage';
import PostPage from './pages/PostPage';

const AppRoutes = (): React.JSX.Element => {
  return (
    <Routes>
      <Route path="/" element={<Navigate to="/page/1" replace />} />
      <Route path="/page/:page" element={<PostListPage />} />
      <Route path="/archives/category/:category" element={<CategoryPostListPage />} />
      <Route path="/archives/:year/:month" element={<ArchivesPostListPage />} />
      <Route path="/*" element={<PostPage />} />
    </Routes>
  );
};

export default AppRoutes;
