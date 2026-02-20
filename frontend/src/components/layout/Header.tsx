const Header = (): React.JSX.Element => {
  return (
    <>
      <nav className="navbar navbar-expand p-0 sticky-top">
        <div className="container-fluid p-0">
          <div className="navbar-collapse p-3">
            <ul className="navbar-nav gap-3">
              <li className="nav-item">
                <a href="/" className="btn btn-primary">
                  <i className="fa-solid fa-home"></i>
                </a>
              </li>
              <li className="nav-item">
                <a href="https://x.com/kinjou_j" className="btn btn-primary">
                  <i className="fa-brands fa-x-twitter"></i>
                </a>
              </li>
            </ul>
            <ul className="navbar-nav ms-auto mx-2">
              <li className="nav-item">
                {/* search-modal */}
              </li>
            </ul>
          </div>
        </div>
      </nav>
      <header>
        <div className="logo text-center py-6">
          <a href="/" className="fw-bold">kinjouj.github.io</a>
        </div>
      </header>
    </>
  );
};

export default Header;
