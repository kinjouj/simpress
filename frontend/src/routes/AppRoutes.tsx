import { Navigate, Route, Routes } from 'react-router-dom';
import PostListPage from '../pages/PostListPage';
import CategoryPage from '../pages/CategoryPage';
import ArchivesPage from '../pages/ArchivesPage';
import PostPage from '../pages/PostPage';

const AppRoutes = (): React.JSX.Element => {
  return (
    <Routes>
      <Route path="/" element={<Navigate to="/page/1" replace />} />
      <Route path="/page/:page" element={<PostListPage />} />
      <Route path="/archives/category/:category" element={<CategoryPage />} />
      <Route path="/archives/:year/:month" element={<ArchivesPage />} />
      <Route path="/*" element={<PostPage />} />
    </Routes>
  );
};

export default AppRoutes;
