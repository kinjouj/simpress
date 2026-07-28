import { useCallback } from 'react';
import { Stack } from 'react-bootstrap';
import { Link } from 'react-router';
import { useFetchData } from '../hooks';
import Simpress from '../api/Simpress';
import type { TaxonomyType } from '../types';

const SidebarCategoriesContent = ({ categories }: { categories: TaxonomyType[] }): React.JSX.Element => {
  const sortedList = [...categories].sort((a, b) => (b.count ?? 0) - (a.count ?? 0));

  return (
    <Stack direction="vertical" gap={1}>
      {sortedList.map((category: TaxonomyType) => (
        <div key={category.key}>
          <Link to={`/archives/categories/${category.key}`}>{category.name} ({category.count})</Link>
          {!!(category.children && Object.keys(category.children).length > 0) && (
            <Stack direction="vertical" className="ms-3">
              <SidebarCategoriesContent categories={category.children} />
            </Stack>
          )}
        </div>
      ))}
    </Stack>
  );
};

const SidebarCategories = (): React.JSX.Element => {
  const fetcher = useCallback(() => {
    return Simpress.getCategories();
  }, []);

  const { data, isLoading, isError } = useFetchData(fetcher);

  if (isError) {
    return <div>Error</div>;
  }

  if (isLoading) {
    return <div>loading...</div>;
  }

  if (data === null) {
    return <div>Error</div>;
  }

  return (
    <SidebarCategoriesContent categories={data} />
  );
};

export default SidebarCategories;
