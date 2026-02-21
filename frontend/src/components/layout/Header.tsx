import { Button, Container, Nav, Navbar } from 'react-bootstrap';

const Header = (): React.JSX.Element => {
  return (
    <>
      <Navbar className="p-0 sticky-top" expand>
        <Container className="p-0" fluid>
          <Navbar.Collapse className="p-3">
            <Nav className="gap-3">
              <Nav.Item>
                <Button href="/">
                  <i className="fa-solid fa-home"></i>
                </Button>
              </Nav.Item>
              <Nav.Item>
                <Button href="https://x.com">
                  <i className="fa-brands fa-x-twitter"></i>
                </Button>
              </Nav.Item>
            </Nav>
            <Nav className="ms-auto mx-2">
              <Nav.Item>
                {/* search-modal */}
              </Nav.Item>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>
      <header>
        <div className="logo text-center py-6">
          <a href="/" className="fw-bold">frontend test</a>
        </div>
      </header>
    </>
  );
};

export default Header;
