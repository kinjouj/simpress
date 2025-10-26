import { render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import Pager from '../../../src/components/ui/Pager';
import Simpress from '../../../src/api/Simpress';

const mockUsePage = jest.fn<number, []>();
jest.mock('../../../src/hooks', () => ({
  usePage: (): number => mockUsePage(),
}));

jest.mock('../../../src/api/Simpress');
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

    await waitFor(() => expect(mockUsePage).toHaveBeenCalled());
    await waitFor(() => expect(SimpressMock.getPageInfo).toHaveBeenCalled());

    const pageTextElement = screen.getByText('11');
    expect(pageTextElement).toBeInTheDocument();
    expect(pageTextElement.tagName).toBe('SPAN');

    const pageLinkElemeent = screen.getByRole('link', { name: '12' });
    expect(pageLinkElemeent).toBeInTheDocument();
    expect(pageLinkElemeent.tagName).toBe('A');
  });

  test('Simpress.getPageInfoがエラーだった場合', async () => {
    mockUsePage.mockReturnValue(1);
    SimpressMock.getPageInfo.mockRejectedValue(new Error('ERROR'));

    render(
      <MemoryRouter>
        <Pager />
      </MemoryRouter>
    );

    await waitFor(() => expect(mockUsePage).toHaveBeenCalled());
    await waitFor(() => expect(SimpressMock.getPageInfo).toHaveBeenCalled());

    const nav = screen.queryByRole('navigation');
    expect(nav).not.toBeInTheDocument();
  });

  test('Simpress.getPageInfoが0を返した場合', async () => {
    mockUsePage.mockReturnValue(1);
    SimpressMock.getPageInfo.mockResolvedValue(0);

    render(
      <MemoryRouter>
        <Pager />
      </MemoryRouter>
    );

    await waitFor(() => expect(mockUsePage).toHaveBeenCalled());
    await waitFor(() => expect(SimpressMock.getPageInfo).toHaveBeenCalled());
    const nav = screen.queryByRole('navigation');
    expect(nav).not.toBeInTheDocument();
  });
});
