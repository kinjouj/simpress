import { HashRouter } from 'react-router-dom';
import { Footer, Header, PageToTopFloatingButton } from './components';
import AppRoutes from './routes/AppRoutes';

const App = (): React.JSX.Element => {
  return (
    <>
      <Header />
      <HashRouter>
        <AppRoutes />
      </HashRouter>
      <PageToTopFloatingButton />
      <Footer />
    </>
  );
};

export default App;
