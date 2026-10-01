import { render, screen } from '@testing-library/react';
import EntryListSkeleton from '../../src/components/EntryListSkeleton';

describe('EntryListSkeleton', () => {
  it('renders five skeleton placeholders', () => {
    render(<EntryListSkeleton />);

    const items = screen.getAllByRole('listitem', { name: 'entry-skeleton' });
    expect(items).toHaveLength(5);
  });
});
