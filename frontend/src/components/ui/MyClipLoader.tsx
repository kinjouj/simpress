import { ClipLoader } from 'react-spinners';
import type { CSSProperties } from 'react';

interface MyClipLoaderProps {
  loading?: boolean
}

const cssOverride: CSSProperties = {
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
};

const MyClipLoader = ({ loading = true }: MyClipLoaderProps): React.JSX.Element => {
  return <ClipLoader loading={loading} cssOverride={cssOverride} />;
};

export default MyClipLoader;
