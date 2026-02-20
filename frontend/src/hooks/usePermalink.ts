import { useLocation, useParams } from 'react-router-dom';

export const usePermalink = (): string | null => {
  const location = useLocation();
  const { '*': permalink } = useParams<{ '*': string }>();
  let { source } = (location.state as { source?: string | null }) || {};

  if (source == null && permalink) {
    const jsonPath = permalink.replace(/(\.[^/.]+)?$/, '.json');
    source = `/${jsonPath}`;
  }

  return source ?? null;
};
