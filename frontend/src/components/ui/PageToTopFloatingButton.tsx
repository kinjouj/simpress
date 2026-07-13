import { useCallback } from 'react';
import { Button } from 'react-bootstrap';
import { faArrowUp } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const PageToTopFloatingButton = (): React.JSX.Element => {
  const onClickHandler = useCallback((): void => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }, []);

  return (
    <Button type="button" aria-label="page to top" className="top-elevator" onClick={onClickHandler}>
      <FontAwesomeIcon icon={faArrowUp} />
    </Button>
  );
};

export default PageToTopFloatingButton;
