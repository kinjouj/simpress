import { render, screen } from '@testing-library/react';
import PostListSkeleton from '../../../src/components/Skeleton/PostListSkeleton';

describe('PostListSkeleton', () => {
  test('renders five skeleton placeholders', () => {
    render(<PostListSkeleton />);

    const items = screen.getAllByRole('listitem', { name: 'post-skeleton' });
    expect(items).toHaveLength(5);
  });
});
