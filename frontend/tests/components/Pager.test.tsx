import { render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import Pager from '../../src/components/Pager';
import Simpress from '../../src/api/Simpress';
import '@testing-library/jest-dom';

const mockUsePage = jest.fn<number, []>();
jest.mock('../../src/hooks', () => ({
  usePage: (): number => mockUsePage(),
}));

jest.mock('../../src/api/Simpress');
const SimpressMock = Simpress as jest.Mocked<typeof Simpress>;

describe('Pager', () => {
  test('<Pager> test', async () => {
    mockUsePage.mockReturnValue(11);
    SimpressMock.getPageInfo.mockResolvedValue(30);

    render(
      <MemoryRouter>
        <Pager />
      </MemoryRouter>
    );

    expect(mockUsePage).toHaveBeenCalled();
    expect(SimpressMock.getPageInfo).toHaveBeenCalled();
    await waitFor(() => {
      expect(screen.getByText('11')).toBeInTheDocument();
      expect(screen.getByRole('link', { name: '12' })).toBeInTheDocument();
    });
  });

  test('Simpress.getPageInfoがエラーだった場合', async () => {
    mockUsePage.mockReturnValue(1);
    SimpressMock.getPageInfo.mockRejectedValue(new Error('ERROR'));

    render(
      <MemoryRouter>
        <Pager />
      </MemoryRouter>
    );

    expect(mockUsePage).toHaveBeenCalled();
    expect(SimpressMock.getPageInfo).toHaveBeenCalled();
    await waitFor(() => {
      const nav = screen.queryByRole('navigation');
      expect(nav).not.toBeInTheDocument();
    });
  });

  test('Simpress.getPageInfoが0を返した場合', async () => {
    mockUsePage.mockReturnValue(1);
    SimpressMock.getPageInfo.mockResolvedValue(0);

    render(
      <MemoryRouter>
        <Pager />
      </MemoryRouter>
    );

    expect(mockUsePage).toHaveBeenCalled();
    expect(SimpressMock.getPageInfo).toHaveBeenCalled();
    await waitFor(() => {
      const nav = screen.queryByRole('navigation');
      expect(nav).not.toBeInTheDocument();
    });
  });
});
