import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import Simpress from '../../src/api/Simpress';
import SidebarCategories from '../../src/components/SidebarCategories';

vi.mock('../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

describe('SidebarCategories', () => {
  test('renders categories sorted by post count, most posts first', async () => {
    SimpressMock.getCategories.mockResolvedValue([
      { key: 'ruby', name: 'Ruby', count: 1 },
      { key: 'js', name: 'JavaScript', count: 3 },
    ]);

    render(
      <MemoryRouter>
        <SidebarCategories />
      </MemoryRouter>
    );

    const links = await screen.findAllByRole('link');
    expect(links.map((link) => link.textContent)).toEqual(['JavaScript (3)', 'Ruby (1)']);
    expect(links[0]).toHaveAttribute('href', '/archives/categories/js');
  });

  test('renders nested child categories', async () => {
    SimpressMock.getCategories.mockResolvedValue([
      {
        key: 'programming',
        name: 'Programming',
        count: 4,
        children: [{ key: 'ruby', name: 'Ruby', count: 4 }],
      },
    ]);

    render(
      <MemoryRouter>
        <SidebarCategories />
      </MemoryRouter>
    );

    expect(await screen.findByText('Ruby (4)')).toBeInTheDocument();
  });

  test('shows an error message when the request fails', async () => {
    SimpressMock.getCategories.mockRejectedValue(new Error('ERROR'));

    render(
      <MemoryRouter>
        <SidebarCategories />
      </MemoryRouter>
    );

    expect(await screen.findByText('Error')).toBeInTheDocument();
  });
});
