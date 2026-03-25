import { Navigate, Route, Routes } from 'react-router-dom';
import { ArchivesPage, CategoryPage, PostListPage, PostPage } from '../pages';
import { Layout } from '../components';
import { useCategory, useYearOfMonth } from '../hooks';

const CategoryRedirectRoute = (): React.JSX.Element => {
  const category = useCategory();
  return <Navigate to={`/archives/category/${category}/1`} replace />;
};

const ArchivePageRedirectRoute = (): React.JSX.Element => {
  const { year, month } = useYearOfMonth();

  return <Navigate to={`/archives/${year}/${month}/1`} replace />;
};

const AppRoutes = (): React.JSX.Element => {
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route path="/" element={<Navigate to="/page/1" replace />} />
        <Route path="/archives/category/:category" element={<CategoryRedirectRoute />} />
        <Route path="/archives/:year/:month" element={<ArchivePageRedirectRoute />} />
        <Route path="/page/:page" element={<PostListPage />} />
        <Route path="/archives/category/:category/:page" element={<CategoryPage />} />
        <Route path="/archives/:year/:month/:page" element={<ArchivesPage />} />
        <Route path="/*" element={<PostPage />} />
      </Route>
    </Routes>
  );
};

export default AppRoutes;
