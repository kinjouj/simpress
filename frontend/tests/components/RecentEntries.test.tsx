import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import Simpress from '../../src/api/Simpress';
import { RecentEntries } from '../../src/components';
import { testEntryData } from '../fixtures/testEntryData';

vi.mock('../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

describe('RecentEntries', () => {
  it('取得中はNotFoundを表示しない', () => {
    let resolveFetch: (value: (typeof testEntryData)[]) => void = () => {};
    SimpressMock.getRecentEntries.mockReturnValue(
      new Promise((resolve) => {
        resolveFetch = resolve;
      })
    );

    render(
      <MemoryRouter>
        <RecentEntries />
      </MemoryRouter>
    );

    expect(screen.queryByText(/not found/i)).not.toBeInTheDocument();
    void resolveFetch;
  });

  it('最近のエントリを表示する', async () => {
    SimpressMock.getRecentEntries.mockResolvedValue([testEntryData]);
    render(
      <MemoryRouter>
        <RecentEntries />
      </MemoryRouter>
    );

    const el = await screen.findAllByRole('listitem');
    expect(el).toHaveLength(1);
  });
});
