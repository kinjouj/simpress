import { render } from '@testing-library/react';
import EntryPageSkeleton from '../../src/components/EntryPageSkeleton';

describe('EntryPageSkeleton', () => {
  test('<EntryPageSkeleton> test', () => {
    const { container } = render(<EntryPageSkeleton />);
    expect(container.innerHTML).not.toBeNull();
    expect(container.querySelector('.entry-content')).not.toBeNull();
  });
});
