import { HashRouter } from 'react-router-dom';
import Header from './components/Header';
import PageToTopFloatingButton from './components/PageToTopFloatingButton';
import AppRoutes from './routes/AppRoutes';

const App = (): React.JSX.Element => {
  return (
    <>
      <Header />
      <HashRouter>
        <AppRoutes />
      </HashRouter>
      <PageToTopFloatingButton />
    </>
  );
};

export default App;
