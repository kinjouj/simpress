import { useEffect, useState } from 'react';

const Footer = (): React.JSX.Element => {
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    setTimeout(() => {
      setLoaded(true);
    }, 500);
  }, []);

  return (
    <footer className="mt-auto" style={{ opacity: loaded ? 1 : 0, minHeight: '80px' }}>
      <div className="footer-content text-center">
        Powered by &nbsp;
        <a href="https://github.com/kinjouj/simpress">simpress</a>
        (octopress like site generator)
      </div>
    </footer>
  );
};

export default Footer;
