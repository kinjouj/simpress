import { Navigate, Route, Routes } from 'react-router-dom';
import { ArchivesPage, CategoryPage, PostListPage, PostPage } from '../pages';
import { Layout } from '../components';

const AppRoutes = (): React.JSX.Element => {
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route path="/" element={<Navigate to="/page/1" replace />} />
        <Route path="/page/:page" element={<PostListPage />} />
        <Route path="/archives/category/:category" element={<CategoryPage />} />
        <Route path="/archives/:year/:month" element={<ArchivesPage />} />
        <Route path="/*" element={<PostPage />} />
      </Route>
    </Routes>
  );
};

export default AppRoutes;
