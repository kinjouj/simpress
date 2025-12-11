import { useEffect } from 'react';
import { HashRouter, useLocation } from 'react-router-dom';
import { Footer, Header, PageToTopFloatingButton } from './components';
import AppRoutes from './routes/AppRoutes';

const ScrollToTop = (): React.JSX.Element | null => {
  const location = useLocation();

  useEffect(() => {
    window.scrollTo({ top: 0, left: 0, behavior: 'instant' });
  }, [location]);

  return null;
};

const App = (): React.JSX.Element => {
  return (
    <>
      <Header />
      <HashRouter>
        <ScrollToTop />
        <AppRoutes />
      </HashRouter>
      <PageToTopFloatingButton />
      <Footer />
    </>
  );
};

export default App;
