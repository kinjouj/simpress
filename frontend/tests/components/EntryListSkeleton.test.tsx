import { render, screen } from '@testing-library/react';
import EntryListSkeleton from '../../src/components/EntryListSkeleton';

describe('EntryListSkeleton', () => {
  test('renders five skeleton placeholders', () => {
    render(<EntryListSkeleton />);

    const items = screen.getAllByRole('listitem', { name: 'entry-skeleton' });
    expect(items).toHaveLength(5);
  });
});
