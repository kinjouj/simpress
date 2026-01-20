const Header = (): React.JSX.Element => {
  return (
    <>
      <nav className="navbar navbar-expand-lg border-bottom border-secondary p-0">
        <div className="container-fluid">
          <nav className="navbar-collapse collapse">
            <ul className="nav navbar-nav">
              <li className="nav-item">
                <a className="nav-link" href="mailto:kinjoujgmail.com">Contact</a>
              </li>
            </ul>
            <ul className="nav navbar-nav mavbar-right ms-auto">
              <li className="nav-item">
                <form action="https://www.google.com/search" method="GET">
                  <input type="hidden" name="hl" value="ja" />
                  <input type="hidden" name="sitesearch" value="kinjouj.github.io" />
                  <input type="search" name="q" className="form-control" />
                </form>
              </li>
            </ul>
          </nav>
        </div>
      </nav>
      <div>
        <header className="logo-header text-center">
          <h2><a href="/">kinjouj.github.io</a></h2>
        </header>
      </div>
    </>
  );
};

export default Header;
