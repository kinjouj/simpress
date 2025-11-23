import { useCallback } from 'react';

const PageToTopFloatingButton = (): React.JSX.Element => {
  const onClickHandler = useCallback((): void => {
    document.body.scrollTo({ top: 0, behavior: 'smooth' });
  }, []);

  return (
    <button
      id="btn-back-to-top"
      type="button"
      className="btn btn-info btn-floating"
      aria-label="page to top"
      onClick={onClickHandler}
    >
      <i className="fas fa-arrow-up"></i>
    </button>
  );
};

export default PageToTopFloatingButton;
