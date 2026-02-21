import { HashRouter } from 'react-router-dom';
import { Container } from 'react-bootstrap';
import { Footer, Header, PageToTopFloatingButton } from './components';
import AppRoutes from './routes/AppRoutes';

const App = (): React.JSX.Element => {
  return (
    <div className="d-flex flex-column min-vh-100">
      <Header />
      <main className="flex-grow-1">
        <Container className="mt-5">
          <HashRouter>
            <AppRoutes />
          </HashRouter>
        </Container>
      </main>
      <PageToTopFloatingButton />
      <Footer />
    </div>
  );
};

export default App;
