import { render, screen } from '@testing-library/react';
import EntryPageSkeleton from '../../src/components/EntryPageSkeleton';

describe('EntryPageSkeleton', () => {
  it('shows the article skeleton', () => {
    render(<EntryPageSkeleton />);

    expect(screen.getByRole('article')).toBeInTheDocument();
  });
});
