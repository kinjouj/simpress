import { render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router';
import ArchivesPage from '../../src/pages/ArchivesPage';
import Simpress from '../../src/api/Simpress';
import { testPostData } from '../fixtures/testPostData';
import type { RenderResult } from '@testing-library/react';

vi.mock('../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

const renderArchives = (): RenderResult => {
  return render(
    <MemoryRouter initialEntries={['/archives/1234/01/1']}>
      <Routes>
        <Route path="/archives/:year/:month/:page" element={<ArchivesPage />} />
      </Routes>
    </MemoryRouter>
  );
};

describe('ArchivesPage', () => {
  beforeEach(() => {
    vi.spyOn(window, 'scrollTo').mockImplementation(() => {});
  });

  afterEach(() => {
    vi.clearAllMocks();
  });

  test('<ArchivesPage> test', async () => {
    SimpressMock.getPostsByArchive.mockResolvedValue([testPostData]);
    renderArchives();

    const posts = await screen.findAllByRole('listitem', { name: 'post' }, { timeout: 10000 });
    expect(posts).toHaveLength(1);
  });

  test('useYearOfMonthから返ってくる値にnullが入ってる場合', async () => {
    render(
      <MemoryRouter>
        <ArchivesPage />
      </MemoryRouter>
    );

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });

  test('Simpress.getPostsByArchiveがエラーを吐いた場合', async () => {
    SimpressMock.getPostsByArchive.mockRejectedValue(new Error('ERROR'));
    renderArchives();

    expect(await screen.findByText('Not Found', {}, { timeout: 10000 })).toBeInTheDocument();
  });
});
