import { HashRouter } from 'react-router';
import AppRoutes from './routes/AppRoutes';

const App = (): React.JSX.Element => {
  return (
    <HashRouter>
      <AppRoutes />
    </HashRouter>
  );
};

export default App;
