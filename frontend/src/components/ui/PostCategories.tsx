import { Link } from 'react-router';
import { Stack, type StackProps } from 'react-bootstrap';
import type { TaxonomiesType } from '../../types';

interface PostCategoriesProps extends StackProps {
  taxonomies: TaxonomiesType
}

const PostCategories = ({ taxonomies, ...rest }: PostCategoriesProps): React.JSX.Element => {
  const props: StackProps = {
    direction: 'horizontal',
    gap: 3,
    ...rest,
  };

  return (
    <Stack {...props}>
      {Object.entries(taxonomies).map(([taxonomy, terms]) => {
        return terms.map((term) => (
          <div key={term.key}>
            <Link to={`/archives/${taxonomy}/${term.key}`} className="post-category">{term.name}</Link>
          </div>
        ));
      })}
    </Stack>
  );
};

export default PostCategories;
