import { ClipLoader } from 'react-spinners';
import type { CSSProperties } from 'react';

const cssOverride: CSSProperties = {
  position: 'absolute',
  top: '50%',
  left: '50%',
};

const MyClipLoader = ({ loading = true }: { loading: boolean }): React.JSX.Element => {
  return <ClipLoader loading={loading} cssOverride={cssOverride} />;
};

export default MyClipLoader;
