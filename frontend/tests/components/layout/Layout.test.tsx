import { render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router';
import Simpress from '../../../src/api/Simpress';
import Layout from '../../../src/components/layout/Layout';
import { testEntryData } from '../../fixtures/testEntryData';

vi.mock('../../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

describe('Layout', () => {
  it('ヘッダー、フッター、本文、最近のエントリを表示する', async () => {
    SimpressMock.getRecentEntries.mockResolvedValueOnce([testEntryData]);

    render(
      <MemoryRouter initialEntries={['/']}>
        <Routes>
          <Route element={<Layout />}>
            <Route path="/" element={<div>page content</div>} />
          </Route>
        </Routes>
      </MemoryRouter>
    );

    expect(screen.getByText('page content')).toBeInTheDocument();
    expect(screen.getByText('Recent Entries')).toBeInTheDocument();

    const entries = await screen.findAllByRole('listitem', {}, { timeout: 10000 });
    expect(entries).toHaveLength(1);
  });
});
