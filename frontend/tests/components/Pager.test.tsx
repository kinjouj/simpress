import { render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import Pager from '../../src/components/Pager';
import type Simpress from '../../src/simpress';
import '@testing-library/jest-dom';

const mockUsePage = jest.fn<number, []>();
jest.mock('../../src/hooks', () => ({
  usePage: (): number => mockUsePage(),
}));

const mockGetPageInfo = jest.fn<Promise<number>, []>();
jest.mock('../../src/simpress', (): Simpress => ({
  getPageInfo: () => mockGetPageInfo(),
}));

describe('Pager', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('<Pager> test', async () => {
    mockUsePage.mockReturnValue(11);
    mockGetPageInfo.mockResolvedValue(30);

    render(
      <MemoryRouter>
        <Pager />
      </MemoryRouter>
    );

    await waitFor(() => {
      expect(screen.getByText('11')).toBeInTheDocument();
      expect(screen.getByRole('link', { name: '12' })).toBeInTheDocument();
    });
  });

  test('Simpress.getPageInfoがエラーだった場合', async () => {
    mockUsePage.mockReturnValue(1);
    mockGetPageInfo.mockRejectedValue(new Error('ERROR'));

    const { container } = render(
      <MemoryRouter>
        <Pager />
      </MemoryRouter>
    );

    await waitFor(() => {
      expect(container).toBeEmptyDOMElement();
    });
  });

  test('Simpress.getPageInfoが0を返した場合', async () => {
    mockUsePage.mockReturnValue(1);
    mockGetPageInfo.mockResolvedValue(0);

    render(
      <MemoryRouter>
        <Pager />
      </MemoryRouter>
    );

    await waitFor(() => {
      const nav = screen.queryByRole('navigation');
      expect(nav).not.toBeInTheDocument();
    });

    expect(mockGetPageInfo).toHaveBeenCalledTimes(1);
  });
});
