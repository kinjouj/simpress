import { useCallback } from 'react';
import { Button } from 'react-bootstrap';

const PageToTopFloatingButton = (): React.JSX.Element => {
  const onClickHandler = useCallback((): void => {
    document.body.scrollTo({ top: 0, behavior: 'smooth' });
  }, []);

  return (
    <Button type="button" aria-label="page to top" className="top-elevator" onClick={onClickHandler}>
      <i className="fas fa-arrow-up"></i>
    </Button>
  );
};

export default PageToTopFloatingButton;
