const Header = (): React.JSX.Element => {
  return (
    <>
      <nav className="navbar navbar-expand-lg p-0">
        <div className="container-fluid">
          <nav className="navbar-collapse collapse">
            <ul className="nav navbar-nav navbar-right ms-auto">
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
      <div className="logo-header text-center">
        <h2>
          <a href="/">Simpress Demo</a>
        </h2>
      </div>
    </>
  );
};

export default Header;
