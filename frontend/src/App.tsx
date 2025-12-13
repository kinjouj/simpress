import { useEffect } from 'react';
import { HashRouter, NavigationType, useLocation, useNavigationType } from 'react-router-dom';
import { Footer, Header, PageToTopFloatingButton } from './components';
import AppRoutes from './routes/AppRoutes';

const ScrollToTop = (): React.JSX.Element | null => {
  const location = useLocation();
  const navType = useNavigationType();

  useEffect(() => {
    if (navType !== NavigationType.Push) {
      return;
    }

    window.scrollTo({ top: 0, left: 0, behavior: 'instant' });
  }, [location, navType]);

  return null;
};

const App = (): React.JSX.Element => {
  useEffect(() => {
    if ('scrollRestoration' in window.history) {
      window.history.scrollRestoration = 'auto';
    }
  }, []);

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
