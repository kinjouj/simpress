import { Col, Container, Row } from 'react-bootstrap';
import { Outlet } from 'react-router-dom';
import { PageToTopFloatingButton } from '../ui';
import RecentPosts from '../RecentPosts';
import Footer from './Footer';
import Header from './Header';

const Layout = (): React.JSX.Element => {
  return (
    <div className="d-flex flex-column min-vh-100">
      <Header />
      <Container className="mt-5">
        <Row className="g-0">
          <Col lg={8}>
            <main className="flex-grow-1">
              <Outlet />
            </main>
          </Col>
          <Col xs={12} lg={4} as="aside" className="sidebar ms-auto ps-5">
            <div id="recent_posts">
              <h4>Recent Posts</h4>
              <RecentPosts />
            </div>
            {/*
            <div id="categories">
              <h4>Categories</h4>
              <SidebarCategories />
            </div>
            */}
          </Col>
        </Row>
      </Container>
      <Footer />
      <PageToTopFloatingButton />
    </div>
  );
};

export default Layout;
