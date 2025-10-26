import { HashRouter } from 'react-router-dom';
import Header from './components/layout/Header';
import Footer from './components/layout/Footer';
import PageToTopFloatingButton from './components/ui/PageToTopFloatingButton';
import AppRoutes from './routes/AppRoutes';

const App = (): React.JSX.Element => {
  return (
    <>
      <Header />
      <HashRouter>
        <AppRoutes />
      </HashRouter>
      <Footer />
      <PageToTopFloatingButton />
    </>
  );
};

export default App;
