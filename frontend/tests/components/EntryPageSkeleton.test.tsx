import { render } from '@testing-library/react';
import EntryPageSkeleton from '../../src/components/EntryPageSkeleton';

describe('EntryPageSkeleton', () => {
  it('entry-contentを持つスケルトンを表示する', () => {
    const { container } = render(<EntryPageSkeleton />);
    expect(container.innerHTML).not.toBeNull();
    expect(container.querySelector('.entry-content')).not.toBeNull();
  });
});
