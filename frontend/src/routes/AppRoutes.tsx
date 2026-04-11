import { Navigate, Route, Routes } from 'react-router-dom';
import { ArchivesPage, CategoryPage, PostListPage, PostPage } from '../pages';
import { Layout, NotFound } from '../components';
import { useCategory, useYearOfMonth } from '../hooks';

const CategoryRedirectRoute = (): React.JSX.Element => {
  const category = useCategory();
  return <Navigate to={`/archives/categories/${category}/1`} replace />;
};

const ArchivePageRedirectRoute = (): React.JSX.Element => {
  const { year, month } = useYearOfMonth();

  if (!year || !month) {
    return <Navigate to="/error" replace />;
  }

  return <Navigate to={`/archives/${year}/${month}/1`} replace />;
};

const AppRoutes = (): React.JSX.Element => {
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route path="/" element={<Navigate to="/page/1" replace />} />
        <Route path="/error" element={<NotFound />} />
        <Route path="/archives/categories/:category" element={<CategoryRedirectRoute />} />
        <Route path="/archives/:year/:month" element={<ArchivePageRedirectRoute />} />
        <Route path="/page/:page" element={<PostListPage />} />
        <Route path="/archives/categories/:category/:page" element={<CategoryPage />} />
        <Route path="/archives/:year/:month/:page" element={<ArchivesPage />} />
        <Route path="/*" element={<PostPage />} />
      </Route>
    </Routes>
  );
};

export default AppRoutes;
