import { ClipLoader } from 'react-spinners';

interface MyClipLoaderProps {
  loading?: boolean
}

const MyClipLoader = ({ loading = true }: MyClipLoaderProps): React.JSX.Element => {
  return (
    <div className="container d-flex justify-content-center align-items-center" style={{ minHeight: '50vh' }}>
      <ClipLoader loading={loading} />
    </div>
  );
};

export default MyClipLoader;
