import { Navigate, Route, Routes } from 'react-router-dom';
import { ArchivesPage, CategoryPage, PostListPage, PostPage } from '../pages';

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
