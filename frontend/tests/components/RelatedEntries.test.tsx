import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import { RelatedEntries } from '../../src/components';
import { testEntryData } from '../fixtures/testEntryData';

describe('RelatedEntries', () => {
  it('<RelatedEntries> test', async () => {
    render(
      <MemoryRouter>
        <RelatedEntries similarities={testEntryData.similarities} />
      </MemoryRouter>
    );

    expect(await screen.findAllByRole('listitem')).toHaveLength(2);
  });
});
