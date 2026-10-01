import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import EntryList from '../../src/components/EntryList';
import { testEntryData } from '../fixtures/testEntryData';
import type { EntryType } from '../../src/types';

describe('EntryList', () => {
  test('<EntryList> test', async () => {
    const entries: EntryType[] = [testEntryData];
    render(
      <MemoryRouter>
        <EntryList entries={entries} />
      </MemoryRouter>
    );

    const elms = await screen.findAllByRole('listitem', { name: 'entry' });
    expect(elms).toHaveLength(1);
  });
});
