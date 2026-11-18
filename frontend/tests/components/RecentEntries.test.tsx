import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import Simpress from '../../src/api/Simpress';
import { RecentEntries } from '../../src/components';
import { testEntryData } from '../fixtures/testEntryData';

vi.mock('../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

describe('RecentEntries', () => {
  it('shows recent entries', async () => {
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
