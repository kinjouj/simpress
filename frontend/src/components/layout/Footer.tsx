import { useEffect, useState } from 'react';

const Footer = (): React.JSX.Element => {
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    setTimeout(() => {
      setLoaded(true);
    }, 500);
  }, []);

  return (
    <footer className="text-center mt-5 py-5" style={{ opacity: loaded ? 1 : 0, minHeight: '80px' }}>
      Powered by simpress(octopress like site generator)
    </footer>
  );
};

export default Footer;
