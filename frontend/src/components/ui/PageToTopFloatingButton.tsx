import { useCallback } from 'react';

const PageToTopFloatingButton = (): React.JSX.Element => {
  const onClickHandler = useCallback((): void => {
    document.body.scrollTo({ top: 0, behavior: 'smooth' });
  }, []);

  return (
    <button
      type="button"
      className="btn btn-info btn-floating"
      aria-label="page to top"
      style={{ position: 'fixed', bottom: '20px', right: '30px' }}
      onClick={onClickHandler}>
      <i className="fas fa-arrow-up"></i>
    </button>
  );
};

export default PageToTopFloatingButton;
