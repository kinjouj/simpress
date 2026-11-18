import { act, render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import Simpress from '../../src/api/Simpress';
import AppRoutes from '../../src/routes/AppRoutes';
import { testEntryData } from '../fixtures/testEntryData';

vi.mock('../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

const renderRoutes = (path: string): void => {
  render(
    <MemoryRouter initialEntries={[path]}>
      <AppRoutes />
    </MemoryRouter>
  );
  act(() => {
    vi.runAllTimers();
  });
};

describe('AppRoutes', () => {
  beforeEach(() => {
    vi.useFakeTimers({ shouldAdvanceTime: true });
    SimpressMock.getRecentEntries.mockResolvedValue([testEntryData]);
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  describe('page list', () => {
    beforeEach(() => {
      SimpressMock.getEntriesByPage.mockResolvedValue({ entries: [testEntryData], total_pages: 1 });
    });

    it('shows entries at /', async () => {
      renderRoutes('/');

      const entries = await screen.findAllByRole('listitem', { name: 'entry' });
      expect(entries).toHaveLength(1);
    });

    it('shows entries at /page/1', async () => {
      renderRoutes('/page/1');

      const entries = await screen.findAllByRole('listitem', { name: 'entry' });
      expect(entries).toHaveLength(1);
    });
  });

  describe('category list', () => {
    beforeEach(() => {
      SimpressMock.getEntriesByCategory.mockResolvedValue({ entries: [testEntryData], total_pages: 1 });
    });

    it('shows entries at /archives/categories/test', async () => {
      renderRoutes('/archives/categories/test');

      const entries = await screen.findAllByRole('listitem', { name: 'entry' });
      expect(entries).toHaveLength(1);
    });

    it('shows entries at /archives/categories/test/1', async () => {
      renderRoutes('/archives/categories/test/1');

      const entries = await screen.findAllByRole('listitem', { name: 'entry' });
      expect(entries).toHaveLength(1);
    });
  });

  describe('archive list', () => {
    beforeEach(() => {
      SimpressMock.getEntriesByArchive.mockResolvedValue({ entries: [testEntryData], total_pages: 1 });
    });

    it('shows entries at /archives/1234/01', async () => {
      renderRoutes('/archives/1234/01');

      const entries = await screen.findAllByRole('listitem', { name: 'entry' });
      expect(entries).toHaveLength(1);
    });

    it('shows entries at /archives/1234/01/1', async () => {
      renderRoutes('/archives/1234/01/1');

      const entries = await screen.findAllByRole('listitem', { name: 'entry' });
      expect(entries).toHaveLength(1);
    });
  });

  describe('entry', () => {
    beforeEach(() => {
      SimpressMock.getEntry.mockResolvedValue(testEntryData);
    });

    it('shows the entry at /test.html', async () => {
      renderRoutes('/test.html');

      const title = await screen.findByRole('heading', { name: testEntryData.title });
      expect(title).toBeInTheDocument();
    });
  });

  describe('error pages', () => {
    it('shows Not Found at /error', async () => {
      renderRoutes('/error');

      expect(await screen.findByText('Not Found')).toBeInTheDocument();
    });

    it('redirects bad year to error', async () => {
      renderRoutes('/archives/a/01');

      expect(await screen.findByText('Not Found')).toBeInTheDocument();
    });
  });
});
