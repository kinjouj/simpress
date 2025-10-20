const PageToTopFloatingButton = (): React.JSX.Element => {
  const onClickHandler = (): void => {
    document.documentElement.scrollTo({ top: 0, behavior: 'smooth' });
    document.body.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <button
      id="btn-back-to-top"
      type="button"
      className="btn btn-info btn-floating btn-lg"
      onClick={onClickHandler}
      aria-label="page to top"
    >
      <i className="fas fa-arrow-up"></i>
    </button>
  );
};

export default PageToTopFloatingButton;
