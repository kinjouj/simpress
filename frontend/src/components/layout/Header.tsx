import { useState } from 'react';
import { Button, Container, Form, InputGroup, Modal, Nav, Navbar } from 'react-bootstrap';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faHome, faMagnifyingGlass } from '@fortawesome/free-solid-svg-icons';
import { faXTwitter } from '@fortawesome/free-brands-svg-icons';

/* eslint-disable react/jsx-no-bind */
const Header = (): React.JSX.Element => {
  const [show, setShow] = useState(false);
  const handleClose = (): void => setShow(false);
  const handleShow = (): void => setShow(true);
  const handleSubmit = (): void => handleClose();

  return (
    <>
      <Navbar className="p-0 sticky-top" expand>
        <Container className="p-0" fluid>
          <Navbar.Collapse className="p-3">
            <Nav className="gap-3">
              <Nav.Item>
                <Button href="/">
                  <FontAwesomeIcon icon={faHome} />
                </Button>
              </Nav.Item>
              <Nav.Item>
                <Button href="https://x.com">
                  <FontAwesomeIcon icon={faXTwitter} />
                </Button>
              </Nav.Item>
            </Nav>
            <Nav className="ms-auto mx-2">
              <Nav.Item>
                <Button variant="primary" aria-label="Search" onClick={handleShow}>
                  <FontAwesomeIcon icon={faMagnifyingGlass} />
                </Button>
                <Modal show={show} contentClassName="bg-transparent border-0" onHide={handleClose} centered>
                  <Modal.Body>
                    <Form action="https://www.google.com/search" method="GET" onSubmit={handleSubmit}>
                      <InputGroup>
                        <input type="hidden" name="hl" value="ja" />
                        <input type="hidden" name="sitesearch" value="kinjouj.github.io" />
                        <Form.Control type="search" name="q" placeholder="Search" className="rounded-2 py-4" autoFocus />
                      </InputGroup>
                    </Form>
                  </Modal.Body>
                </Modal>
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
/* eslint-enable react/jsx-no-bind */

export default Header;
