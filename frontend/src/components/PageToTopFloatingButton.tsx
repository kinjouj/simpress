const PageToTopFloatingButton = (): React.JSX.Element => {
  const onClickHandler = (): void => {
    document.documentElement.scrollTo({ top: 0, behavior: 'smooth' });
    document.body.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <button type="button" className="btn btn-info btn-floating btn-lg" id="btn-back-to-top" onClick={onClickHandler}>
      <i className="fas fa-arrow-up"></i>
    </button>
  );
};

export default PageToTopFloatingButton;
