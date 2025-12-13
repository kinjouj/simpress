import { ClipLoader } from 'react-spinners';

const MyClipLoader = ({ loading = true }: { loading?: boolean }): React.JSX.Element => {
  return (
    <div className="container d-flex justify-content-center align-items-center" style={{ minHeight: '50vh' }}>
      <ClipLoader loading={loading} />
    </div>
  );
};

export default MyClipLoader;
