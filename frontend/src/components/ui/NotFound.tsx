import { Container } from 'react-bootstrap';

const NotFound = (): React.JSX.Element => {
  return (
    <Container className="min-vh-100 d-flex justify-content-center m-5 p-5">
      <h1 className="display-1 fw-bold">Not Found</h1>
    </Container>
  );
};

export default NotFound;
