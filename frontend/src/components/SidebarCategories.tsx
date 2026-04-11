import { useCallback } from 'react';
import { Stack } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { useFetchData } from '../hooks';
import Simpress from '../api/Simpress';
import type { CategoriesType, CategoryType } from '../types';

const SidebarCategoriesContent = ({ categories }: { categories: CategoriesType }): React.JSX.Element => {
  const categoryList = Object.values(categories);
  const sortedList = [...categoryList].sort((a, b) => b.count - a.count);

  return (
    <Stack direction="vertical" gap={1}>
      {sortedList.map((category: CategoryType) => (
        <div key={category.key}>
          <Link to={`/archives/categories/${category.key}`}>{category.name}</Link>
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

  const { data, isError } = useFetchData(fetcher);

  if (data == null || isError) {
    return <div>Error</div>;
  }

  return (
    <SidebarCategoriesContent categories={data} />
  );
};

export default SidebarCategories;
